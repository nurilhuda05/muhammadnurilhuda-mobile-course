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

# REFACTORING CHALLENGE
## Hasil
![screenshoot](screenshoot/Refactoring%201.png)

![screenshoot](screenshoot/Refactoring%202.png)


# TESTING
## Hasil
![screenshoot](screenshoot/Testing%201.png)


# REFLEKSI
1. Mengapa UI dilarang memanggil Dio langsung? Apa yang rusak jika aturan ini dilanggar?<br>
UI sebaiknya tidak memanggil Dio secara langsung karena setiap bagian program memiliki tugas masing-masing. UI bertugas menampilkan data, sedangkan Repository bertugas mengambil data dari API. Jika UI langsung memanggil Dio, kode menjadi lebih sulit dirawat dan diuji. Selain itu, jika Dio ingin diganti dengan library lain seperti http, banyak bagian UI yang harus diubah. Dengan menggunakan Repository, perubahan tersebut cukup dilakukan pada bagian yang berhubungan dengan API.<br>
2. Kapan pagination client-side cukup, dan kapan harus mengandalkan pagination server (_page/_limit)?<br>
Pagination client-side cukup digunakan jika jumlah data tidak terlalu banyak. Contohnya daftar kontak yang hanya berisi sekitar 100 sampai 500 data. Semua data masih bisa diambil sekaligus tanpa terlalu membebani aplikasi.Pagination server lebih cocok jika jumlah datanya sangat banyak. Contohnya data transaksi, berita, atau timeline media sosial. Data dapat diambil sedikit demi sedikit menggunakan _page dan _limit, sehingga penggunaan internet dan memori HP lebih ringan.<br>
3. Bagaimana exception repository berubah menjadi AsyncError tanpa try/catch di setiap widget? Kapan try/catch eksplisit tetap dibutuhkan?<br>
Jika Repository mengalami error dan melempar exception, Riverpod dapat menangkap error tersebut melalui AsyncNotifier atau FutureProvider. Status data kemudian berubah menjadi AsyncError. UI cukup membaca status tersebut untuk menampilkan pesan error. Try/catch tetap dapat digunakan jika ingin menangani error secara khusus. Contohnya saat pengguna menekan tombol untuk mengirim data, login, atau saat aplikasi perlu menampilkan Snackbar atau Dialog ketika terjadi error. <br>
4. Bagian mana dari hasil AI yang Anda perbaiki, dan mengapa?<br>
Bagian yang diperbaiki adalah struktur folder, import, dan cara menghubungkan Provider dengan Repository. Hal ini dilakukan karena kode dari AI belum tentu sesuai dengan struktur project yang sudah dibuat. Selain itu, pada bagian unit test terkadang ada import yang kurang atau kode yang belum sesuai dengan fungsi yang ada di project. Perbaikan dilakukan agar kode dapat dijalankan dengan baik dan tetap mengikuti struktur aplikasi yang sudah digunakan.