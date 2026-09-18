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

# AI PROMPT CHALLENGE
## AI Verification Checklist
1. Apakah UI memanggil Dio secara langsung (dilarang) atau lewat repository?<br>
Tidak, UI sama sekali tidak memanggil Dio secara langsung. Sesuai dengan prinsip arsitektur yang bersih, pemanggilan Dio disembunyikan di dalam Repository layer, dan UI hanya berinteraksi melalui Provider layer.<br>
2. Apakah fromJson aman null, atau masih memakai cast langsung yang bisa crash?<br>
Fungsi fromJson yang telah dibuat sepenuhnya aman dari null dan tidak memakai cast langsung yang dapat menyebabkan crash. <br>
3. Apakah semua tipe DioExceptionType (timeout, connectionError, badResponse) dipetakan ke pesan pengguna?<br>
Ya, semua tipe DioExceptionType yang umum terjadi telah dipetakan menjadi pesan error yang ramah pengguna <br>
4. Apakah baseUrl/timeout terpusat di satu client, bukan tersebar di tiap method?<br>
Ya, baseUrl dan timeout sudah terpusat di satu client, sehingga kita tidak perlu menulisnya berulang-ulang di setiap method atau repositori.<br
5. Apakah test AI benar-benar menguji kasus field hilang, atau hanya happy path? Tambahkan minimal 1 edge case sendiri.<br>
Ya, tes yang dibuat tidak hanya menguji happy path, tetapi juga telah menguji kasus field yang hilang secara menyeluruh. Selain menguji JSON kosong, telah ditambahkan pula 1 edge case ekstrim di mana endpoint merespons dengan tipe data yang sepenuhnya salah (seperti angka yang berisi string dan boolean) serta field yang secara eksplisit bernilai null. Seluruh edge case tersebut telah berhasil ditangani oleh model menggunakan nilai fallback/default yang aman sehingga mencegah terjadinya crash (TypeError). <br>
6. Jalankan flutter analyze dan flutter test, apakah hasil AI lolos tanpa warning?<br>
![screenshoot](screenshoot/AI%20Challenge%201.png)