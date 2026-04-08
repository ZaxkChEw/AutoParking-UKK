import paho.mqtt.client as mqtt
import json
import math
import threading
from django.utils import timezone
from .models import TransaksiParkir, AreaParkir
from .models import StrukQueue

BROKER       = "localhost"
PORT         = 1883
NAMA_PETUGAS = "dhea"

TOPIC_CONFIG       = f"parking/{NAMA_PETUGAS}/config/petugas"
TOPIC_ENTRY_RFID   = f"parking/{NAMA_PETUGAS}/entry/rfid"
TOPIC_EXIT_RFID    = f"parking/{NAMA_PETUGAS}/exit/rfid"
TOPIC_ENTRY_SERVO  = f"parking/{NAMA_PETUGAS}/entry/servo"
TOPIC_EXIT_SERVO   = f"parking/{NAMA_PETUGAS}/exit/servo"
TOPIC_LCD          = f"parking/{NAMA_PETUGAS}/lcd"

# Urutan lahan parkir
URUTAN_LAHAN = ["BSP", "LKW", "TXS"]

_mqtt_client   = None
_petugas_aktif = None
_processing    = False 

def set_petugas_aktif(username):
    global _petugas_aktif
    _petugas_aktif = username

def get_petugas_aktif():
    return _petugas_aktif

def _hitung_biaya(waktu_masuk, waktu_keluar=None):
    waktu_akhir = waktu_keluar if waktu_keluar else timezone.now()
    durasi_jam  = math.ceil((waktu_akhir - waktu_masuk).total_seconds() / 3600) or 1
    return durasi_jam, durasi_jam * 2000

def _format_nominal(biaya):
    return f"{biaya:,}".replace(",", ".")

def _lcd(line1, line2=""):
    _publish(TOPIC_LCD, f"{line1}|{line2}")

# ===================== ALOKASI LAHAN =====================
def _get_area_tersedia():
    for kd in URUTAN_LAHAN:
        try:
            area   = AreaParkir.objects.get(kd_area=kd)
            terisi = TransaksiParkir.objects.filter(kd_area=area, status__in=["IN", "OUT"]).count()
            if terisi < area.kapasitas:
                return area
        except AreaParkir.DoesNotExist:
            continue
    return None

# ===================== CALLBACK =====================
def on_connect(client, userdata, flags, rc):
    if rc == 0:
        print("[MQTT] Connected to Mosquitto Broker")
        client.subscribe(TOPIC_ENTRY_RFID)
        client.subscribe(TOPIC_EXIT_RFID)
        print(f"[MQTT] Subscribe: {TOPIC_ENTRY_RFID}")
        print(f"[MQTT] Subscribe: {TOPIC_EXIT_RFID}")
    else:
        print(f"[MQTT] Gagal connect, rc={rc}")

def on_message(client, userdata, msg):
    global _processing

    if _processing:
        print("[MQTT] ⚠️ Pesan diabaikan, masih proses...")
        return

    _processing = True

    topic = msg.topic
    try:
        payload = json.loads(msg.payload.decode())
    except json.JSONDecodeError:
        payload = {"rfid": msg.payload.decode().strip()}

    print(f"[MQTT] {topic} → {payload}")

    card_id = payload.get("rfid", "").upper()
    if not card_id:
        _processing = False
        return

    if topic == TOPIC_ENTRY_RFID:
        handle_masuk(card_id)
    elif topic == TOPIC_EXIT_RFID:
        handle_keluar(card_id)

    _processing = False

# ===================== BROADCAST =====================
def broadcast_petugas_login(username):
    set_petugas_aktif(username)
    _publish(TOPIC_CONFIG, json.dumps({"petugas": username}))
    print(f"[MQTT] Broadcast login: {username}")

def broadcast_petugas_logout(username):
    set_petugas_aktif(None)
    _publish(TOPIC_CONFIG, json.dumps({"petugas": "unknown"}))
    print(f"[MQTT] Broadcast logout: {username}")

# ===================== HANDLER MASUK =====================
def handle_masuk(card_id):
    sedang_parkir = TransaksiParkir.objects.filter(
        card_id=card_id,
        status__in=["IN", "OUT"]
    ).exists()

    if sedang_parkir:
        _lcd("Kendaraan", "Sedang Parkir")
        print(f"[MASUK] Ditolak - {card_id} sudah parkir")
        print(f"════ LOG: Kartu {card_id} ditolak masuk (sudah parkir) ════")
        return

    area = _get_area_tersedia()
    if not area:
        _lcd("Lahan Parkir", "Sudah Penuh!")
        print(f"[MASUK] Semua lahan penuh")
        return

    transaksi = TransaksiParkir.objects.create(
        card_id         = card_id,
        kd_area         = area,
        waktu_masuk     = timezone.now(),
        jenis_kendaraan = "Motor",
        status          = "IN",
    )

    _publish(TOPIC_ENTRY_SERVO, "OPEN")
    _lcd("Selamat Datang", transaksi.kd_transaksi)

    print(f"════════════════════════════════════════")
    print(f"  ✅ KENDARAAN MASUK")
    print(f"  Card ID   : {card_id}")
    print(f"  Area      : {area.nama_area}")
    print(f"  Kode      : {transaksi.kd_transaksi}")
    print(f"  Waktu     : {transaksi.waktu_masuk.strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"════════════════════════════════════════")

# ===================== HANDLER KELUAR =====================
def handle_keluar(card_id):
    transaksi = TransaksiParkir.objects.filter(
        card_id=card_id,
        status="IN"
    ).first()

    if not transaksi:
        _lcd("Kendaraan", "Tidak Parkir")
        print(f"[KELUAR] Ditolak - {card_id} tidak sedang parkir")
        print(f"════ LOG: Kartu {card_id} ditolak keluar (tidak sedang parkir) ════")
        return

    waktu_keluar      = timezone.now()
    durasi_jam, biaya = _hitung_biaya(transaksi.waktu_masuk, waktu_keluar)
    nominal           = _format_nominal(biaya)

    transaksi.waktu_keluar = waktu_keluar
    transaksi.biaya        = biaya
    transaksi.status       = "OUT"
    transaksi.save()

    nama_area = transaksi.kd_area.nama_area
    kd        = transaksi.kd_transaksi

    struk = f"""
STRUK AUTOPARKING
---------------------------------------------
Kode Transaksi  : {kd}
ID Transaksi    : {transaksi.id_transaksi}
ID Card         : {card_id}
Area Parkir     : {nama_area}
Masuk           : {transaksi.waktu_masuk.strftime('%Y-%m-%d %H:%M:%S')}
Keluar          : {waktu_keluar.strftime('%Y-%m-%d %H:%M:%S')}
Lama Parkir     : {durasi_jam} jam
Biaya Parkir    : Rp {nominal}
---------------------------------------------
"""
    StrukQueue.objects.create(kd_transaksi=kd, struk=struk)

    _lcd(f"Rp {nominal}", f"{durasi_jam} jam")

    print(f"════════════════════════════════════════")
    print(f"  🚗 KENDARAAN KELUAR (menunggu approve)")
    print(f"  Card ID   : {card_id}")
    print(f"  Area      : {nama_area}")
    print(f"  Kode      : {kd}")
    print(f"  Masuk     : {transaksi.waktu_masuk.strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"  Keluar    : {waktu_keluar.strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"  Durasi    : {durasi_jam} jam")
    print(f"  Biaya     : Rp {nominal}")
    print(f"  ⏳ Menunggu petugas approve di web...")
    print(f"════════════════════════════════════════")

# ===================== CETAK STRUK =====================
def pop_struk_terbaru():
    from .models import StrukQueue
    struk = StrukQueue.objects.filter(sudah_diambil=False).order_by('created_at').first()
    if struk:
        struk.sudah_diambil = True
        struk.save()
        return {"kd_transaksi": struk.kd_transaksi, "struk": struk.struk}
    return None

# ===================== APPROVE KELUAR =====================
def approve_keluar(kd_transaksi):
    try:
        transaksi = TransaksiParkir.objects.get(kd_transaksi=kd_transaksi, status="OUT")
    except TransaksiParkir.DoesNotExist:
        return False, "Transaksi tidak ditemukan"

    transaksi.status = "DONE"
    transaksi.save()

    durasi_jam, biaya = _hitung_biaya(transaksi.waktu_masuk, transaksi.waktu_keluar)
    nominal           = _format_nominal(biaya)
    nama_area         = transaksi.kd_area.nama_area
    kd                = transaksi.kd_transaksi

    _publish(TOPIC_EXIT_SERVO, "OPEN")
    _lcd("Selamat Jalan!", f"Rp {nominal}")

    print(f"════════════════════════════════════════")
    print(f"  ✅ APPROVE KELUAR - PALANG DIBUKA")
    print(f"  Kode      : {kd}")
    print(f"  Area      : {nama_area}")
    print(f"  Durasi    : {durasi_jam} jam")
    print(f"  Biaya     : Rp {nominal}")
    print(f"════════════════════════════════════════")

    return True, "Berhasil"

# ===================== REJECT KELUAR =====================
def reject_keluar(kd_transaksi):
    try:
        transaksi = TransaksiParkir.objects.get(kd_transaksi=kd_transaksi, status="OUT")
    except TransaksiParkir.DoesNotExist:
        return False, "Transaksi tidak ditemukan"

    transaksi.status       = "IN"
    transaksi.waktu_keluar = None
    transaksi.biaya        = 0
    transaksi.save()

    _lcd("Akses Ditolak", "Hub. Petugas")

    print(f"════════════════════════════════════════")
    print(f"  ❌ REJECT KELUAR")
    print(f"  Kode      : {kd_transaksi}")
    print(f"  Status    : Dikembalikan ke IN")
    print(f"════════════════════════════════════════")

    return True, "Ditolak"

# ===================== PUBLISH HELPER =====================
def _publish(topic, payload):
    global _mqtt_client
    if _mqtt_client and _mqtt_client.is_connected():
        _mqtt_client.publish(topic, payload)
    else:
        import random, string
        unique_id = ''.join(random.choices(string.ascii_lowercase + string.digits, k=6))
        c = mqtt.Client(client_id=f"pub-{unique_id}")
        c.connect(BROKER, PORT, 60)
        c.publish(topic, payload)
        c.disconnect()

def publish_message(message):
    _publish("parking/gate", message)

# ===================== START MQTT =====================
def start_mqtt():
    global _mqtt_client

    if _mqtt_client and _mqtt_client.is_connected():
        print("[MQTT] Sudah konek, skip!")
        return _mqtt_client

    import random, string
    unique_id = ''.join(random.choices(string.ascii_lowercase + string.digits, k=6))
    client = mqtt.Client(client_id=f"django-parkir-{unique_id}", clean_session=True)
    client.on_connect = on_connect
    client.on_message = on_message
    client.connect(BROKER, PORT, keepalive=60)
    _mqtt_client = client
    threading.Thread(target=client.loop_forever, daemon=True).start()
    print("[MQTT] Client started (Mosquitto localhost:1883)")
    return client