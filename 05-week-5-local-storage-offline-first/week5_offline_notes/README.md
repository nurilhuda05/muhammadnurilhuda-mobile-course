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