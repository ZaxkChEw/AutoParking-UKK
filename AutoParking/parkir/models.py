from django.db import models
from django.utils import timezone
import random
import string
import math

class User(models.Model):
    id = models.AutoField(primary_key=True)
    namaLengkap = models.CharField(max_length=100)
    username = models.CharField(max_length=50)
    password = models.CharField(max_length=255)
    level = models.CharField(max_length=20)

    class Meta:
        db_table = "user"

class AreaParkir(models.Model):
    kd_area = models.CharField(max_length=10, primary_key=True)
    nama_area = models.CharField(max_length=50)
    kapasitas = models.IntegerField()

    class Meta:
        db_table = "area_parkir"

    def __str__(self):
        return self.nama_area

class TransaksiParkir(models.Model):
    STATUS_CHOICES = [
        ('IN',   'Masuk'),
        ('OUT',  'Keluar'),
        ('DONE', 'Selesai'),
    ]

    kd_transaksi    = models.CharField(max_length=10, primary_key=True)
    waktu_masuk     = models.DateTimeField()
    waktu_keluar    = models.DateTimeField(null=True, blank=True, default=None)
    biaya           = models.IntegerField(null=True, blank=True, default=0)
    jenis_kendaraan = models.CharField(max_length=20, default="Motor")
    kd_area         = models.ForeignKey(AreaParkir, on_delete=models.CASCADE, db_column='kd_area')
    status          = models.CharField(max_length=20, choices=STATUS_CHOICES, default='IN')
    id_transaksi    = models.CharField(max_length=50)
    noPlat          = models.CharField(max_length=20)
    card_id         = models.CharField(max_length=50, default="")

    class Meta:
        db_table = "transaksi_parkir"

    def save(self, *args, **kwargs):
        if not self.kd_transaksi:
            self.kd_transaksi = self._generate_kd_transaksi()
        if not self.id_transaksi:
            self.id_transaksi = self._generate_id_transaksi()
        if not self.card_id:
            self.card_id = self._generate_card_id()
        if not self.noPlat:
            self.noPlat = self.generate_plat()
        super().save(*args, **kwargs)

    @staticmethod
    def _generate_kd_transaksi():
        # Format: huruf A-Z + angka 1-99, contoh: B7, E18, A23
        while True:
            huruf  = random.choice(string.ascii_uppercase)
            angka  = random.randint(1, 99)
            kd     = f"{huruf}{angka}"
            if not TransaksiParkir.objects.filter(kd_transaksi=kd).exists():
                return kd

    @staticmethod
    def _generate_id_transaksi():
        # Random huruf besar + huruf kecil + angka, 8 karakter
        chars = string.ascii_letters + string.digits
        while True:
            id_tr = ''.join(random.choices(chars, k=8))
            if not TransaksiParkir.objects.filter(id_transaksi=id_tr).exists():
                return id_tr

    @staticmethod
    def _generate_card_id():
        # Format: RFID_XxxXxxX
        chars = string.ascii_letters + string.digits
        suffix = ''.join(random.choices(chars, k=7))
        return f"RFID_{suffix}"

    @staticmethod
    def generate_plat():
        huruf_depan    = random.choice(string.ascii_uppercase)
        angka          = str(random.randint(100, 9999))
        huruf_belakang = ''.join(random.choices(string.ascii_uppercase, k=2))
        return f"{huruf_depan} {angka} {huruf_belakang}"

    def hitung_durasi(self):
        waktu_akhir = self.waktu_keluar if self.waktu_keluar else timezone.now()
        return math.ceil((waktu_akhir - self.waktu_masuk).total_seconds() / 3600) or 1

    def hitung_biaya(self):
        return self.hitung_durasi() * 2000

class ParkingSession(models.Model):
    plate_number   = models.CharField(max_length=20)
    check_in_time  = models.DateTimeField(default=timezone.now)
    check_out_time = models.DateTimeField(null=True, blank=True)
    is_active      = models.BooleanField(default=True)

    def __str__(self):
        return f"{self.plate_number} - {'Active' if self.is_active else 'Done'}"

class StrukQueue(models.Model):
    kd_transaksi = models.CharField(max_length=10)
    struk        = models.TextField()
    created_at   = models.DateTimeField(auto_now_add=True)
    sudah_diambil = models.BooleanField(default=False)

    class Meta:
        db_table = "struk_queue"