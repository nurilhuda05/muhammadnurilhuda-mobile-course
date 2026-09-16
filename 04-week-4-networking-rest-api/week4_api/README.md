# PRAKTIKUM 2
## Uji Skenario Error
1. Skenario 1 – Internet Normal <br>
Pengujian dilakukan saat emulator terhubung ke internet. Aplikasi berhasil mengambil data dari REST API dan menampilkan daftar post pada halaman.
![screenshoot](screenshoot/Praktikum%202.1.png)

2. Skenario 2 – Internet Dimatikan <br>
engujian dilakukan dengan mematikan koneksi internet emulator. Aplikasi gagal mengambil data dan menampilkan pesan “Tidak dapat terhubung ke server” serta tombol “Coba lagi”.
![screenshoot](screenshoot/Praktikum%202.2.png)

3. Skenario 3 – URL API Salah <br>
Pengujian dilakukan dengan mengganti URL API menjadi alamat yang salah. Aplikasi gagal terhubung ke server dan menampilkan pesan error yang mudah dipahami pengguna.
![screenshoot](screenshoot/Praktikum%202.3.png)

# PRAKTIKUM 3
## Hasil
![screenshoot](screenshoot/Praktikum%203.1.png)
Pada Praktikum 3, aplikasi berhasil menerapkan pagination dengan menampilkan data dari REST API sebanyak 10 data per halaman. Data berikutnya akan dimuat ketika pengguna melakukan scroll ke bagian bawah, disertai indikator loading.<br>
