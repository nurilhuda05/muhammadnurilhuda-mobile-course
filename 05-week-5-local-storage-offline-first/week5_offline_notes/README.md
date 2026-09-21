# PRAKTIKUM 3
## Gambar 1 Mengaktifkan Force Offline
![screenshot](screenshot/praktikum%203.1.jpeg)
Langkah:<br>
Pengujian diawali dengan membuka halaman Settings, kemudian mengaktifkan fitur Force Offline. Fitur ini digunakan untuk mensimulasikan kondisi aplikasi tanpa koneksi internet sehingga pengujian tidak bergantung pada kondisi jaringan yang tersedia.<br>

Hasil observasi:<br>
Setelah Force Offline diaktifkan, switch berubah menjadi ON. Kondisi tersebut menunjukkan bahwa aplikasi sedang disimulasikan dalam keadaan offline <br>

## Gambar 2 Menambahkan Catatan Saat Offline
![screenshot](screenshot/praktikum%203.2.jpeg)
Langkah:<br>
Setelah Force Offline aktif, pengguna kembali ke halaman Notes dan menambahkan catatan. Pada kondisi ini, catatan dibuat dan disimpan secara lokal meskipun aplikasi sedang berada dalam kondisi offline.<br>

Hasil observasi:<br>
Catatan berhasil ditambahkan dan ditampilkan pada halaman Notes. Pada bagian atas terlihat Notes - Dirty: 2, yang menunjukkan terdapat dua catatan yang memiliki status dirty atau belum tersinkron. Hal ini menunjukkan bahwa aplikasi tetap dapat menyimpan data secara lokal ketika berada dalam kondisi offline.<br>

## Gambar 3 Membuka Kembali Aplikasi
![screenshot](screenshot/praktikum%203.3.jpeg)
Langkah:<br>
Aplikasi kemudian ditutup melalui perangkat Android dan dibuka kembali untuk memeriksa apakah data yang sebelumnya disimpan secara offline masih tersedia.<br>

Hasil observasi:<br>
Setelah aplikasi dibuka kembali, catatan yang sebelumnya dibuat tetap tersedia pada halaman Notes. Data tersebut tidak hilang meskipun aplikasi telah ditutup, sehingga menunjukkan bahwa penyimpanan lokal menggunakan SQLite berhasil mempertahankan data. Jumlah data dirty juga tetap dapat ditampilkan sesuai dengan data yang belum tersinkron.<br>


## Gambar 4 Menonaktifkan Force Offline
![screenshot](screenshot/praktikum%203.4.jpeg)
Langkah:<br>
Setelah memastikan data lokal tetap tersedia, pengguna membuka halaman Settings dan menonaktifkan Force Offline. Langkah ini dilakukan untuk mensimulasikan kondisi aplikasi kembali memiliki koneksi internet.<br>

Hasil observasi:<br>
Switch Force Offline berubah menjadi OFF. Hal ini menunjukkan bahwa aplikasi telah dikembalikan ke kondisi online sehingga proses sinkronisasi data dapat dilakukan.<br>

## Gambar 5 Melakukan Sinkronisasi
![screenshot](screenshot/praktikum%203.5.jpeg)
Langkah:<br>
Setelah kondisi online dikembalikan, pengguna kembali ke halaman Notes dan menekan tombol Sync yang ditandai dengan ikon sinkronisasi.<br>

Hasil observasi:<br>
Proses sinkronisasi berhasil dilakukan. Sebelum sinkronisasi terdapat catatan dengan status dirty, sedangkan setelah proses selesai jumlah pada bagian atas berubah menjadi Notes - Dirty: 0. Catatan tetap tersedia pada aplikasi, tetapi statusnya sudah tidak dirty sehingga menunjukkan bahwa proses dirty sync berhasil dilakukan.<br>

# AI VERIFICATION


## 1. Penggunaan SharedPreferences
AI menyarankan SharedPreferences digunakan untuk menyimpan preferensi aplikasi, seperti pengaturan tema. AI tidak menyarankan daftar catatan disimpan di SharedPreferences.Hal ini sesuai dengan project yang dibuat. Pada project ini, SharedPreferences digunakan untuk menyimpan dark_mode dan waktu terakhir aplikasi dibuka. Sedangkan data catatan disimpan menggunakan SQLite melalui sqflite.<br>
Hasil verifikasi: sesuai.

## 2. Dukungan untuk Sync
AI memberikan contoh skema yang memiliki updated_at dan sync_status. Artinya, AI tidak hanya memikirkan CRUD, tetapi juga memperhatikan kebutuhan sinkronisasi data.<br>
Pada project yang dibuat, tabel notes memiliki updated_at dan dirty. Field dirty digunakan untuk mengetahui apakah catatan masih perlu disinkronkan atau sudah selesai disinkronkan. Field updated_at digunakan untuk menyimpan waktu terakhir catatan diperbarui.<br>
Jadi, kebutuhan antrean sync pada project sudah dapat diterapkan walaupun nama field yang digunakan berbeda dengan contoh dari AI.<br>
Hasil verifikasi: sesuai.

## 3. Verifikasi Fitur Real-time
AI menjelaskan bahwa Drift memiliki fitur Stream/watch() yang dapat digunakan untuk mengamati perubahan data. Dengan fitur tersebut, perubahan data dapat diketahui oleh aplikasi sehingga tampilan dapat diperbarui.<br>
Penjelasan tersebut memiliki dasar karena AI menyebutkan penggunaan Stream/watch(). Namun, pada project ini saya tidak menggunakan Drift, tetapi menggunakan sqflite. Oleh karena itu, fitur watch() dari Drift tidak digunakan dalam implementasi project.<br>
Hasil verifikasi: sesuai dengan penjelasan AI, tetapi belum digunakan pada project.

## 4. Verifikasi Boilerplate
AI menjelaskan bahwa Drift membutuhkan konfigurasi tambahan seperti code generation dan build_runner. Namun, saya belum melakukan percobaan langsung untuk menginstal Drift dan membuat migration pada project.<br>
Karena belum melakukan percobaan tersebut, saya belum dapat memastikan secara langsung apakah jumlah boilerplate yang dijelaskan AI benar-benar sesuai dengan kondisi saat instalasi.<br>
Hasil verifikasi: belum dilakukan secara langsung.

## 5. Keputusan Akhir
Setelah melakukan verifikasi, saya memilih menggunakan SharedPreferences untuk menyimpan preferensi dan sqflite untuk menyimpan catatan.<br>
SharedPreferences digunakan karena data yang disimpan hanya berupa pengaturan sederhana seperti dark_mode. Sementara itu, sqflite digunakan untuk menyimpan catatan karena data catatan membutuhkan database yang lebih terstruktur dan dapat digunakan untuk CRUD.<br>
Selain itu, sqflite sudah dapat memenuhi kebutuhan project saat ini. Tabel notes sudah memiliki dirty dan updated_at yang digunakan untuk mendukung proses sinkronisasi data. Oleh karena itu, saya tetap menggunakan SharedPreferences + sqflite dan tidak mengganti implementasi project menjadi Drift.