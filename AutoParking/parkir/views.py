from django.shortcuts import render, redirect, get_object_or_404
from django.http import JsonResponse, HttpResponse
from django.utils import timezone
from django.db import connection
from django.views.decorators.http import require_POST
from .models import TransaksiParkir, AreaParkir, ParkingSession
from .mqtt_client import (
    publish_message,
    approve_keluar, reject_keluar,
    broadcast_petugas_login, broadcast_petugas_logout, 
)
import math
import hashlib
import random
import string
from .mqtt_client import pop_struk_terbaru
from .models import TransaksiParkir, AreaParkir, ParkingSession, User
from reportlab.lib.pagesizes import A4
from reportlab.platypus import SimpleDocTemplate, Table, TableStyle, Paragraph, Spacer
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet
from datetime import datetime
from django.db.models import Sum, Count
from django.db.models.functions import TruncMonth

# ================= HELPER AUTOMATIC =================

def hitung_durasi_biaya(waktu_masuk, waktu_keluar=None):
    waktu_akhir = waktu_keluar if waktu_keluar else timezone.now()
    durasi_jam  = math.ceil((waktu_akhir - waktu_masuk).total_seconds() / 3600) or 1
    return durasi_jam, durasi_jam * 2000

def get_shift(waktu):
    jam = waktu.hour
    if 5 <= jam <= 11:    return "Pagi"
    elif 12 <= jam <= 15: return "Siang"
    elif 16 <= jam <= 17: return "Sore"
    else:                 return "Malam"
    
def cek_struk(request):
    data = pop_struk_terbaru()
    print(f"[CEK STRUK] dipanggil, ada: {data is not None}")
    if data:
        return JsonResponse({"ada": True, "kd_transaksi": data["kd_transaksi"], "struk": data["struk"]})
    return JsonResponse({"ada": False})

def generate_struk(transaksi, operator):
    durasi_jam, biaya = hitung_durasi_biaya(transaksi.waktu_masuk, transaksi.waktu_keluar)
    shift = get_shift(transaksi.waktu_keluar)
    return f"""STRUK AUTOPARKING
---------------------------------------------
Jenis Transaksi : Cash
ID Card         : {transaksi.card_id}
Masuk           : {transaksi.waktu_masuk.strftime('%Y-%m-%d %H:%M:%S')}
Keluar          : {transaksi.waktu_keluar.strftime('%Y-%m-%d %H:%M:%S')}
Plat Nomor      : {transaksi.noPlat}
Lama Parkir     : {durasi_jam} jam
Biaya Parkir    : Rp {biaya:,}
---------------------------------------------
Operator        : {operator} ({shift})
=============================================
"""

# ================= LOGIN =================
def login_view(request):
    if request.method == 'POST':
        username     = request.POST.get('username')
        password     = request.POST.get('password')
        password_md5 = hashlib.md5(password.encode()).hexdigest()

        with connection.cursor() as cursor:
            cursor.execute(
                "SELECT username, level FROM user WHERE username=%s AND password=%s",
                [username, password_md5]
            )
            user = cursor.fetchone()

        if user:
            request.session['username'] = user[0]
            request.session['level']    = user[1]
            if user[1] == 'petugas':
                broadcast_petugas_login(user[0])
                return redirect('petugas')
            elif user[1] == 'admin':
                return redirect('admin')
            elif user[1] == 'owner':
                return redirect('owner')
            

        return render(request, 'login.html', {'error': 'Username atau password salah'})

    return render(request, 'login.html')

# ================= DASHBOARD PETUGAS =================
def petugas_dashboard(request):
    if request.session.get('level') != 'petugas':
        return redirect('login')

    areas     = AreaParkir.objects.all()
    data_area = []
    for area in areas:
        aktif    = TransaksiParkir.objects.filter(kd_area=area, status='IN').count()
        selesai  = TransaksiParkir.objects.filter(kd_area=area, status='DONE').count()
        tersedia = area.kapasitas - aktif
        data_area.append({'area': area, 'aktif': aktif, 'selesai': selesai, 'tersedia': tersedia})

    # Kendaraan sedang parkir (IN)
    kendaraan_masuk = TransaksiParkir.objects.filter(status='IN').order_by('-waktu_masuk')
    for k in kendaraan_masuk:
        k.durasi_display, k.biaya_display = hitung_durasi_biaya(k.waktu_masuk)

    # Kendaraan menunggu buka palang (OUT)
    kendaraan_keluar = TransaksiParkir.objects.filter(status='OUT').order_by('-waktu_keluar')
    for k in kendaraan_keluar:
        k.durasi_display, k.biaya_display = hitung_durasi_biaya(k.waktu_masuk, k.waktu_keluar)

    # Riwayat selesai (DONE)
    log_riwayat = TransaksiParkir.objects.filter(status='DONE').order_by('-waktu_keluar')[:100]
    for index, log in enumerate(log_riwayat, 1):
        log.no_urut = index
        log.durasi_display, _ = hitung_durasi_biaya(log.waktu_masuk, log.waktu_keluar)

    context = {
        'data_area':        data_area,
        'kendaraan_masuk':  kendaraan_masuk,
        'kendaraan_keluar': kendaraan_keluar,
        'log_riwayat':      log_riwayat,
    }
    return render(request, 'petugas/petugas_dashboard.html', context)

# ================= TRANSAKSI CHECK-IN/OUT PETUGAS =================
def check_in(request):
    plate = request.GET.get("plate")
    if not plate:
        return JsonResponse({"error": "Plate number required"})
    ParkingSession.objects.create(plate_number=plate)
    publish_message("OPEN_IN")
    return JsonResponse({"message": "Check-in success", "plate": plate})

def check_out(request):
    plate = request.GET.get("plate")
    try:
        session = ParkingSession.objects.get(plate_number=plate, is_active=True)
    except ParkingSession.DoesNotExist:
        return JsonResponse({"error": "Plate not found"})
    session.check_out_time = timezone.now()
    session.is_active      = False
    session.save()
    publish_message("OPEN_OUT")
    return JsonResponse({"message": "Check-out success", "plate": plate})

# ================= BUKA PALANG PETUGAS =================
@require_POST
def aksi_buka_keluar(request, kd_transaksi):
    if request.session.get('level') != 'petugas':
        return JsonResponse({"success": False, "message": "Unauthorized"}, status=403)

    success, msg = approve_keluar(kd_transaksi)
    if success:
        try:
            transaksi = TransaksiParkir.objects.get(kd_transaksi=kd_transaksi)
            struk     = generate_struk(transaksi, request.session.get('username', 'Petugas'))
            with open(f"struk_{kd_transaksi}.txt", "w") as f:
                f.write(struk)
        except Exception as e:
            print(f"[STRUK] Error: {e}")

    return JsonResponse({"success": success, "message": msg})

@require_POST
def aksi_tolak_keluar(request, kd_transaksi):
    if request.session.get('level') != 'petugas':
        return JsonResponse({"success": False, "message": "Unauthorized"}, status=403)
    success, msg = reject_keluar(kd_transaksi)
    return JsonResponse({"success": success, "message": msg})

# ================= DASHBOARD ADMIN =================
def admin_dashboard(request):
    if request.session.get('level') != 'admin':
        return redirect('login')

    sedang_parkir = TransaksiParkir.objects.filter(status='IN').count()
    total_selesai = TransaksiParkir.objects.filter(status='DONE').count()

    bulan_ini = timezone.now().replace(day=1, hour=0, minute=0, second=0, microsecond=0)
    transaksi_bulan_ini = TransaksiParkir.objects.filter(status='DONE', waktu_keluar__gte=bulan_ini)
    total_pendapatan = sum(
        hitung_durasi_biaya(t.waktu_masuk, t.waktu_keluar)[1]
        for t in transaksi_bulan_ini
    )

    daftar_user = User.objects.all().order_by('id')        
    daftar_area = AreaParkir.objects.all().order_by('kd_area')  

    context = {
        'sedang_parkir':    sedang_parkir,
        'total_selesai':    total_selesai,
        'total_pendapatan': total_pendapatan,
        'daftar_user':      daftar_user,
        'daftar_area':      daftar_area,
    }
    return render(request, 'admin/admin_dashboard.html', context)

# ================= CRUD USER ADMIN =================
def tambah_user(request):
    if request.session.get('level') != 'admin':
        return JsonResponse({'success': False, 'message': 'Unauthorized'}, status=403)

    if request.method == 'POST':
        username     = request.POST.get('username', '').strip()
        role         = request.POST.get('role', '').strip()
        password     = request.POST.get('password', '').strip()

        if not username or not role or not password:
            return JsonResponse({'success': False, 'message': 'Semua kolom harus diisi!'})

        if User.objects.filter(username=username).exists():
            return JsonResponse({'success': False, 'message': 'Username sudah ada!'})

        password_md5 = hashlib.md5(password.encode()).hexdigest()
        User.objects.create(username=username, password=password_md5, level=role, namaLengkap=username)

        return JsonResponse({'success': True, 'message': 'User berhasil ditambahkan!'})

def edit_user(request, user_id):
    if request.session.get('level') != 'admin':
        return JsonResponse({'success': False, 'message': 'Unauthorized'}, status=403)

    if request.method == 'POST':
        username = request.POST.get('username', '').strip()
        role     = request.POST.get('role', '').strip()
        password = request.POST.get('password', '').strip()

        if not username or not role:
            return JsonResponse({'success': False, 'message': 'Semua kolom harus diisi!'})

        try:
            user = User.objects.get(id=user_id)
            user.username = username
            user.level    = role
            if password:
                user.password = hashlib.md5(password.encode()).hexdigest()
            user.save()
            return JsonResponse({'success': True, 'message': 'User berhasil diupdate!'})
        except User.DoesNotExist:
            return JsonResponse({'success': False, 'message': 'User tidak ditemukan!'})


def hapus_user(request, user_id):
    if request.session.get('level') != 'admin':
        return JsonResponse({'success': False, 'message': 'Unauthorized'}, status=403)

    if request.method == 'POST':
        try:
            user = User.objects.get(id=user_id)
            user.delete()
            return JsonResponse({'success': True, 'message': 'User berhasil dihapus!'})
        except User.DoesNotExist:
            return JsonResponse({'success': False, 'message': 'User tidak ditemukan!'})

# ================= CRUD KAPASITAS ADMIN =================
def tambah_area(request):
    if request.session.get('level') != 'admin':
        return JsonResponse({'success': False, 'message': 'Unauthorized'}, status=403)

    if request.method == 'POST':
        kd_area   = request.POST.get('kd_area', '').strip().upper()
        nama_area = request.POST.get('nama_area', '').strip()
        kapasitas = request.POST.get('kapasitas', '').strip()

        if not kd_area or not nama_area or not kapasitas:
            return JsonResponse({'success': False, 'message': 'Semua kolom harus diisi!'})

        if AreaParkir.objects.filter(kd_area=kd_area).exists():
            return JsonResponse({'success': False, 'message': 'Kode area sudah ada!'})

        AreaParkir.objects.create(kd_area=kd_area, nama_area=nama_area, kapasitas=int(kapasitas))
        return JsonResponse({'success': True, 'message': 'Lahan berhasil ditambahkan!'})


def edit_area(request, kd_area):
    if request.session.get('level') != 'admin':
        return JsonResponse({'success': False, 'message': 'Unauthorized'}, status=403)

    if request.method == 'POST':
        kd_area_baru = request.POST.get('kd_area', '').strip().upper()
        nama_area    = request.POST.get('nama_area', '').strip()
        kapasitas    = request.POST.get('kapasitas', '').strip()

        if not kd_area_baru or not nama_area or not kapasitas:
            return JsonResponse({'success': False, 'message': 'Semua kolom harus diisi!'})

        try:
            area = AreaParkir.objects.get(kd_area=kd_area)

            if kd_area != kd_area_baru:
                if AreaParkir.objects.filter(kd_area=kd_area_baru).exists():
                    return JsonResponse({'success': False, 'message': 'Kode area sudah dipakai!'})
                area.delete()
                AreaParkir.objects.create(
                    kd_area=kd_area_baru,
                    nama_area=nama_area,
                    kapasitas=int(kapasitas)
                )
            else:
                area.nama_area = nama_area
                area.kapasitas = int(kapasitas)
                area.save()

            return JsonResponse({'success': True, 'message': 'Lahan berhasil diupdate!'})
        except AreaParkir.DoesNotExist:
            return JsonResponse({'success': False, 'message': 'Lahan tidak ditemukan!'})


def hapus_area(request, kd_area):
    if request.session.get('level') != 'admin':
        return JsonResponse({'success': False, 'message': 'Unauthorized'}, status=403)

    if request.method == 'POST':
        try:
            area = AreaParkir.objects.get(kd_area=kd_area)
            area.delete()
            return JsonResponse({'success': True, 'message': 'Lahan berhasil dihapus!'})
        except AreaParkir.DoesNotExist:
            return JsonResponse({'success': False, 'message': 'Lahan tidak ditemukan!'})

# ================= DASHBOARD OWNER =================
def owner_dashboard(request):
    if request.session.get('level') != 'owner':
        return redirect('login')

    # default: dari awal bulan sampai hari ini
    hari_ini   = timezone.now().date()
    awal_bulan = hari_ini.replace(day=1)

    dari_str   = request.GET.get('dari',   awal_bulan.strftime('%Y-%m-%d'))
    sampai_str = request.GET.get('sampai', hari_ini.strftime('%Y-%m-%d'))
    status_filter = request.GET.get('status', 'SEMUA')

    try:
        dari   = datetime.strptime(dari_str,   '%Y-%m-%d').date()
        sampai = datetime.strptime(sampai_str, '%Y-%m-%d').date()
    except ValueError:
        dari   = awal_bulan
        sampai = hari_ini

    # filter transaksi
    qs = TransaksiParkir.objects.filter(
        waktu_masuk__date__gte=dari,
        waktu_masuk__date__lte=sampai,
    )
    if status_filter != 'SEMUA':
        qs = qs.filter(status=status_filter)
    transaksi = qs.order_by('-waktu_masuk')

    for t in transaksi:
        t.durasi_display, t.biaya_display = hitung_durasi_biaya(t.waktu_masuk, t.waktu_keluar)

    # log aktivitas terbaru
    log_aktivitas = TransaksiParkir.objects.filter(status='DONE').order_by('-waktu_keluar')[:50]
    for l in log_aktivitas:
        l.durasi_display, l.biaya_display = hitung_durasi_biaya(l.waktu_masuk, l.waktu_keluar)

    # grafik
    tahun_ini = timezone.now().year
    pendapatan_bulanan = (
        TransaksiParkir.objects
        .filter(status='DONE', waktu_keluar__year=tahun_ini)
        .annotate(bulan=TruncMonth('waktu_keluar'))
        .values('bulan')
        .annotate(total=Sum('biaya'))
        .order_by('bulan')
    )
    bulan_labels = ['Jan','Feb','Mar','Apr','Mei','Jun','Jul','Agu','Sep','Okt','Nov','Des']
    grafik_labels, grafik_data = [], []
    for p in pendapatan_bulanan:
        grafik_labels.append(bulan_labels[p['bulan'].month - 1])
        grafik_data.append(p['total'] or 0)

    jumlah_in   = TransaksiParkir.objects.filter(status='IN').count()
    jumlah_done = TransaksiParkir.objects.filter(status='DONE').count()

    context = {
        'transaksi':     transaksi,
        'dari':          dari_str,
        'sampai':        sampai_str,
        'status_filter': status_filter,
        'log_aktivitas': log_aktivitas,
        'grafik_labels': grafik_labels,
        'grafik_data':   grafik_data,
        'jumlah_in':     jumlah_in,
        'jumlah_done':   jumlah_done,
    }
    return render(request, 'owner/owner_dashboard.html', context)

# ================= EXPORT PDF OWNER =================
def export_pdf_owner(request):
    if request.session.get('level') != 'owner':
        return redirect('login')

    hari_ini   = timezone.now().date()
    awal_bulan = hari_ini.replace(day=1)

    dari_str      = request.GET.get('dari',   awal_bulan.strftime('%Y-%m-%d'))
    sampai_str    = request.GET.get('sampai', hari_ini.strftime('%Y-%m-%d'))
    status_filter = request.GET.get('status', 'SEMUA')

    try:
        dari   = datetime.strptime(dari_str,   '%Y-%m-%d').date()
        sampai = datetime.strptime(sampai_str, '%Y-%m-%d').date()
    except ValueError:
        dari   = awal_bulan
        sampai = hari_ini

    qs = TransaksiParkir.objects.filter(
        waktu_masuk__date__gte=dari,
        waktu_masuk__date__lte=sampai,
    )
    if status_filter != 'SEMUA':
        qs = qs.filter(status=status_filter)
    transaksi = qs.order_by('-waktu_masuk')

    response = HttpResponse(content_type='application/pdf')
    response['Content-Disposition'] = f'attachment; filename="transaksi_{dari_str}_sd_{sampai_str}.pdf"'

    doc   = SimpleDocTemplate(response, pagesize=A4)
    style = getSampleStyleSheet()
    elems = []

    elems.append(Paragraph("Laporan Transaksi Parkir", style['Title']))
    elems.append(Paragraph(f"Periode: {dari_str} s/d {sampai_str} | Status: {status_filter}", style['Normal']))
    elems.append(Spacer(1, 12))

    data = [['No', 'Plat No', 'Area', 'Jam Masuk', 'Jam Keluar', 'Durasi', 'Biaya', 'Status']]
    for i, t in enumerate(transaksi, 1):
        durasi, biaya = hitung_durasi_biaya(t.waktu_masuk, t.waktu_keluar)
        data.append([
            str(i), t.noPlat, t.kd_area.kd_area,
            t.waktu_masuk.strftime('%d/%m %H:%M'),
            t.waktu_keluar.strftime('%d/%m %H:%M') if t.waktu_keluar else '-',
            f"{durasi} jam", f"Rp {biaya:,}", t.status
        ])

    tabel = Table(data, repeatRows=1)
    tabel.setStyle(TableStyle([
        ('BACKGROUND',     (0,0), (-1,0), colors.HexColor('#111111')),
        ('TEXTCOLOR',      (0,0), (-1,0), colors.white),
        ('FONTSIZE',       (0,0), (-1,0), 9),
        ('FONTSIZE',       (0,1), (-1,-1), 8),
        ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.white, colors.HexColor('#fff8e1')]),
        ('GRID',           (0,0), (-1,-1), 0.5, colors.HexColor('#e0e0e0')),
        ('ALIGN',          (0,0), (-1,-1), 'CENTER'),
        ('VALIGN',         (0,0), (-1,-1), 'MIDDLE'),
        ('PADDING',        (0,0), (-1,-1), 6),
    ]))
    elems.append(tabel)
    doc.build(elems)
    return response

# ================= LOGOUT =================
def logout_view(request):
    username = request.session.get('username')
    if username:
        broadcast_petugas_logout(username)
    request.session.flush()
    return redirect('login')