from django.urls import path
from . import views

urlpatterns = [
    path('',                                          views.login_view,         name='login'),
    path('logout/',                                   views.logout_view,        name='logout'),
    path('petugas/',                                  views.petugas_dashboard,  name='petugas'),
    # PETUGAS DASHBOARD
    path('check-in/',                                 views.check_in),
    path('check-out/',                                views.check_out),
    path('petugas/aksi/keluar/<str:kd_transaksi>/',   views.aksi_buka_keluar,   name='aksi_buka_keluar'),
    path('petugas/aksi/tolak/<str:kd_transaksi>/',    views.aksi_tolak_keluar,  name='aksi_tolak_keluar'),
    path('cek-struk/',                                views.cek_struk,          name='cek_struk'),
    # ADMIN DASHBOARD
    path('admin/',                                    views.admin_dashboard,    name='admin'),
    path('admin/tambah-user/',                        views.tambah_user,        name='tambah_user'),
    path('admin/edit-user/<int:user_id>/',            views.edit_user,          name='edit_user'),
    path('admin/hapus-user/<int:user_id>/',           views.hapus_user,         name='hapus_user'),
    path('admin/tambah-area/',                        views.tambah_area,        name='tambah_area'),
    path('admin/edit-area/<str:kd_area>/',            views.edit_area,          name='edit_area'),
    path('admin/hapus-area/<str:kd_area>/',           views.hapus_area,         name='hapus_area'),
    # OWNER DASHBOARD
    path('owner/',                                    views.owner_dashboard,    name='owner'),
    path('owner/export-pdf/',                         views.export_pdf_owner,   name='export_pdf_owner'),
]