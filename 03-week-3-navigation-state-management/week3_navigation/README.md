# Praktikum 1
![screenshot](screenshot/Praktikum%201.png)

# Praktikum 2
![screenshot](screenshot/Praktikum%202.png)

# Refleksi Praktikum 3 3
Mengapa menampilkan ulang data lama (stale data) dengan indikator refresh kadang lebih baik daripada mengosongkan layar? Kapan pola itu penting? <br>
Karena pengguna masih dapat melihat informasi yang tersedia sambil menunggu data terbaru dimuat. Jika layar langsung dikosongkan, pengguna dapat merasa aplikasi lambat atau bahkan mengira terjadi kesalahan. Pola ini penting pada aplikasi yang sering mengambil data dari internet, seperti aplikasi ecommerce, media sosial, atau berita, agar pengalaman pengguna tetap nyaman dan informasi tetap dapat diakses selama proses pembaruan data berlangsung.

# AI Promt Chalenge
## Promt
Buatkan halaman Flutter bernama StatsPage menggunakan flutter_riverpod.
Requirements:<br>
- ConsumerWidget dengan satu AsyncNotifierProvider yang mensimulasikan
  pengambilan data statistik (delay 2 detik, kadang gagal 30%).<br>
- UI harus menangani loading (spinner), error (pesan + tombol retry),
  dan success (ListView 3 item).<br>
- Berikan unit test untuk notifier-nya.<br>
Jelaskan setiap bagian kode dalam komentar.
## Hasil
![screenshot](screenshot/AI%20Prompt%20Challenge%201.png)
![screenshot](screenshot/AI%20Prompt%20Challenge%202.png)
## AI Verification Checklist
- Apakah state diubah secara immutable (tidak ada state.add() atau mutasi list langsung)? <br>
Ya, state sudah diubah secara immutable (tidak mutasi langsung). <br>
- Apakah ref.watch hanya dipakai di dalam build, dan ref.read di callback?<br>
Ya, ref.watch hanya dipakai di dalam build, dan ref.read di callback. <br>
- Apakah ketiga state AsyncValue benar-benar ditangani (bukan hanya success)?<br>
Ya, ketiga state AsyncValue benar-benar ditangani (bukan hanya success).<br>
- Apakah provider dideklarasikan dengan tipe eksplisit dan tidak duplikat dengan provider lain?<br>
Ya, provider dideklarasikan dengan tipe eksplisit dan tidak duplikat dengan provider lain.<br>
- Apakah kode AI memakai API Riverpod versi lama (StateProvider antipattern, StateNotifierProvider usang, atau Consumer bertingkat yang tidak perlu)? Perbaiki ke pola Notifier/ConsumerWidget.<br>
Tidak, kode AI TIDAK menggunakan API Riverpod versi lama. Kode sudah menggunakan standar Riverpod versi terbaru (Riverpod 2.0+) dengan pola AsyncNotifier dan ConsumerWidget. <br>
- Jalankan flutter analyze dan flutter test, apakah hasil AI lolos tanpa warning?<br>
![screenshot](screenshot/Flutter%20Analyze%20&%20Flutter%20Test%20AI%20Promt%20Challenge.png)


# Recactoring Challenge
Hasil Flutter analyze dan flutter test pada refactoring challenge
![screenshot](screenshot/Flutter%20Analyze%20&%20Flutter%20Test%20Refactoring%20Challenge.png)

