# PRAKTIKUM 2
## Hasil Pengujian Firebase Cloud Messaging
- Notifikasi berhasil dikirim dari Firebase Console.
- Saat aplikasi berada pada kondisi background, banner notifikasi muncul pada perangkat Android.
- Ketika banner notifikasi ditekan, aplikasi berhasil terbuka kembali.
![screenshot](screenshot/praktikum%202.1.jpeg)


# PRAKTIKUM 3
## Hasil Pengujian Foreground
![screenshot](screenshot/praktikum%203.1%20foreground.jpeg)<br>
Pada pengujian ini, aplikasi sedang dalam keadaan terbuka atau aktif. Setelah notifikasi dikirim dari Firebase, notifikasi berhasil muncul di layar menggunakan local notification. Hal ini menunjukkan bahwa aplikasi dapat menerima dan menampilkan notifikasi saat sedang digunakan.<br>

## Hasil Pengujian Background
![screenshot](screenshot/praktikum%203.2%20background.jpeg)<br>
Pada pengujian ini, aplikasi berada di background setelah tombol Home ditekan. Saat notifikasi dikirim dari Firebase, notifikasi berhasil muncul di panel notifikasi Android. Ketika notifikasi diklik, aplikasi berhasil terbuka kembali.<br>

## Hasil Pengujian Terminated
![screenshot](screenshot/praktikum%203.3%20terminated.jpeg)<br>
Pada pengujian ini, aplikasi ditutup sepenuhnya dari Recent Apps. Setelah notifikasi dikirim dari Firebase, notifikasi tetap berhasil diterima oleh perangkat. Saat notifikasi diklik, aplikasi berhasil terbuka kembali meskipun sebelumnya dalam keadaan tertutup.


# AI CHALLENGE
**1. Apakah background handler berupa fungsi top-level dengan @pragma('vm:entry-point')? (tolak jika berupa method kelas).**<br>
Iya.Buktinya dapat dilihat pada file push_service.dart, di mana fungsi background handler dideklarasikan di tingkat paling atas (top-level) dan menggunakan anotasi @pragm('vm:entry-point')<br>

**2. Apakah onTokenRefresh benar-benar mengirim token baru ke backend, bukan hanya dicetak ke log?**<br>
Iya, benar-benar dikirim ke backend.Alurnya adalah sebagai berikut:<br>
1. Pada file push_service.dart, listener onTokenRefresh memanggil callback onToken setiap kali ada token baru
2. Kemudian pada file main.dart, callback tersebut didefinisikan untuk meneruskan token ke deviceRepo.registerToken
3. Terakhir, di dalam device_repository.dart, fungsi registerToken benar-benar melakukan HTTP POST ke endpoint /devices menggunakan Dio

Jadi, token baru tidak hanya dicetak ke log, melainkan secara aktif diproses hingga dikirim ke backend lewat API.<br>

**3. Apakah foreground memakai local notification manual?**<br>
Iya, aplikasi memakai local notification secara manual saat berada di foreground.Buktinya bisa dilihat di dalam file push_service.dart pada fungsi listenForeground. Ketika ada pesan masuk saat aplikasi sedang terbuka, pesan tersebut ditangkap dan kemudian ditampilkan secara manual menggunakan fungsi _showLocalNotification (yang memanggil flutter_local_notifications).Hal ini dilakukan karena Firebase Cloud Messaging secara otomatis tidak menampilkan banner notifikasi (heads-up notification) apabila aplikasi sedang aktif/terbuka di layar pengguna (foreground). Oleh karena itu, notifikasi harus dimunculkan secara manual agar tetap terlihat oleh user.<br>

**4. Apakah klik dari ketiga state (foreground/background/terminated) masuk ke rute yang benar? Buktikan dengan tabel pengujian.**<br>
Iya, masuk ke rute yang benar. Berikut adalah tabel mekanisme penanganannya:<br>

| State Aplikasi | Komponen Penanganan | Bukti / Mekanisme di Kode |
| :--- | :--- | :--- |
| **Foreground** | `flutter_local_notifications` | Saat notifikasi (banner) diklik, fungsi `onDidReceiveNotificationResponse` menangkap payload dan menyimpannya ke `pendingDeepLink`. Fungsi `handleTerminated()` kemudian membaca variabel ini dan melakukan navigasi via `go(pendingDeepLink)`. |
| **Background** | `FirebaseMessaging.onMessageOpenedApp` | Saat notifikasi di notification tray diklik, listener ini mendeteksi pesan dan langsung memanggil `go(route)` menggunakan string route dari `message.data['route']`. |
| **Terminated** | `FirebaseMessaging.instance.getInitialMessage()` | Saat aplikasi dibuka melalui klik notifikasi dalam kondisi tertutup, fungsi ini mengekstrak data dari notifikasi dan mengeksekusi navigasi menggunakan `initial.data['route']`. |

**5. Apakah token/secret tidak di-hardcode dan tidak di-log penuh? Perbaiki bila AI melanggarnya.**<br>
Iya. Token FCM tidak ditulis langsung di dalam kode, tapi diambil otomatis dari perangkat lewat Firebase. Saya juga sudah memperbaiki kodenya agar token disamarkan saat dicetak, sehingga rahasia tetap aman dan tidak bocor secara penuh di log aplikasi.<br>


# REFACTORING
## Hasil Flutter Analyze dan Flutter Test
![screenshot](screenshot/flutter%20analyze%20dan%20flutter%20test.png)

