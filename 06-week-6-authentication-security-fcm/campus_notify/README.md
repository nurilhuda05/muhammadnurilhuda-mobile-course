# PRAKTIKUM 2
## Hasil Pengujian Firebase Cloud Messaging
- Notifikasi berhasil dikirim dari Firebase Console.
- Saat aplikasi berada pada kondisi background, banner notifikasi muncul pada perangkat Android.
- Ketika banner notifikasi ditekan, aplikasi berhasil terbuka kembali.
![screenshot](screenshot/praktikum%202.1.jpeg)


# PRAKTIKUM 3
## Hasil Pengujian Foreground
![screenshot](screenshot/praktikum%203.1%20foreground.jpeg)
Pada pengujian ini, aplikasi sedang dalam keadaan terbuka atau aktif. Setelah notifikasi dikirim dari Firebase, notifikasi berhasil muncul di layar menggunakan local notification. Hal ini menunjukkan bahwa aplikasi dapat menerima dan menampilkan notifikasi saat sedang digunakan.<br>

## Hasil Pengujian Background
![screenshot](screenshot/praktikum%203.2%20background.jpeg)
Pada pengujian ini, aplikasi berada di background setelah tombol Home ditekan. Saat notifikasi dikirim dari Firebase, notifikasi berhasil muncul di panel notifikasi Android. Ketika notifikasi diklik, aplikasi berhasil terbuka kembali.<br>

## Hasil Pengujian Terminated
![screenshot](screenshot/praktikum%203.3%20terminated.jpeg)
Pada pengujian ini, aplikasi ditutup sepenuhnya dari Recent Apps. Setelah notifikasi dikirim dari Firebase, notifikasi tetap berhasil diterima oleh perangkat. Saat notifikasi diklik, aplikasi berhasil terbuka kembali meskipun sebelumnya dalam keadaan tertutup.