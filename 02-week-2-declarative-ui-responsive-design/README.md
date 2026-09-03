Eksperimen warm-up
1. Expanded membuat widget menggunakan sisa ruang yang tersedia. Jika dihapus, teks yang terlalu panjang dapat menyebabkan overflow.

2. MainAxisSize.min membuat tinggi kartu seminimal mungkin sesuai isi. MainAxisSize.max membuat kartu menggunakan ruang maksimum yang tersedia.

3. Saya menambahkan data Email menggunakan Row dan Expanded agar posisi label dan nilainya tetap rapi.


Eksperimen Layout
1. Ubah breakpoint dari 700 menjadi nilai lain dan amati perubahan jumlah kolom.

Hasilnya, jumlah kolom pada dashboard berubah sesuai dengan lebar layar. Semakin kecil nilai breakpoint, semakin cepat dashboard berubah menjadi 2 kolom. Sebaliknya, semakin besar nilai breakpoint, layar membutuhkan ukuran yang lebih lebar untuk menampilkan 2 kolom.

2. Ubah themeMode menjadi ThemeMode.dark, lalu kembalikan ke ThemeMode.system.

Ketika menggunakan ThemeMode.dark, aplikasi selalu menggunakan tema gelap. Sedangkan ThemeMode.system membuat tampilan mengikuti pengaturan tema pada perangkat.

3. Uji aplikasi dengan ukuran layar emulator yang berbeda.

Ketika layar berukuran kecil, dashboard menampilkan 1 kolom, sedangkan pada layar yang lebih lebar menampilkan 2 kolom. Perubahan ini terjadi secara otomatis karena penggunaan LayoutBuilder dan breakpoint.

4. Tambahkan Semantics atau label yang bermakna pada elemen yang penting bagi screen reader.

Semantics digunakan untuk meningkatkan aksesibilitas aplikasi, terutama bagi pengguna yang menggunakan screen reader. Dengan memberikan label seperti “Dark mode” pada CupertinoSwitch, screen reader dapat mengetahui dan menjelaskan fungsi switch tersebut kepada pengguna.

Ai Promt Challenge

1. Promt Desain
Promt: "Anda adalah seorang Mobile Enginer yang sangat jago dan pintar. Bandingkan dua tata letak dashboard akademik untuk Flutter: versi GridView dan versi LayoutBuilder + Column. Kemudian jelaskan menggunakan bahasa yang sederhana trade-off responsif dan aksesibilitasnya"

Output Penting: AI menjelaskan bahwa GridView cocok untuk dashboard
dengan banyak card karena dapat menyusun card dalam bentuk grid. Sedangkan
LayoutBuilder memberikan kontrol terhadap perubahan layout
berdasarkan ukuran layar. AI merekomendasikan untuk menggabungkan LayoutBuilder dan GridView
untuk dashboard akademik karena LayoutBuilder menentukan
jumlah kolom berdasarkan ukuran layar, sedangkan GridView
menyusun card dengan rapi.

Keputusan: Saya memilih menggunakan LayoutBuilder + GridView.

Alasan Teknis: LayoutBuilder digunakan untuk menentukan jumlah kolom
berdasarkan lebar layar. GridView digunakan untuk menyusun
card agar rapi dan responsif.


2. Prompt penguatan konsep
Promt: "Anda adalah seorang Mobile Enginer yang sangat jago dan pintar. Jelaskan menggunakan bahasa yang sederhana kapan penggunaan Expanded justru menyebabkan overflow di dalam Row, beri contoh kode yang gagal dan perbaikannya."

Output Penting: AI menjelaskan bahwa Expanded digunakan agar widget mengisi
ruang yang tersedia di dalam Row atau Colum. Overflow dapat terjadi jika ruang yang tersedia tidak cukup, misalnya terlalu banyak widget berada di dalam Row atau widget
di dalam Expanded memiliki ukuran tetap yang terlalu besar. Contohnya, penggunaan Expanded dengan Container yang memiliki width terlalu besar dapat menyebabkan tampilan melebihi lebar layar. Perbaikannya adalah menghindari ukuran tetap yang terlalu besar
dan membiarkan Expanded menyesuaikan ukuran dengan ruang yang tersedia.

Keputusan: "Saya tetap menggunakan Expanded pada dashboard karena Expanded
membantu membuat tampilan menjadi responsif. Pada dashboard, Expanded digunakan pada bagian teks profil dan pada GridView.

Alasan Teknis: Expanded pada bagian profil membuat teks menggunakan sisa ruang
yang tersedia setelah CircleAvatar dan SizedBox. Expanded pada GridView membuat GridView menggunakan ruang yang tersedia di dalam Column. Penggunaan membuat layout tetap responsif dan tidak mengalami overflow.

3. Verification prompt
Promt: "Anda adalah seorang Mobile Enginer yang sangat jago dan pintar.Periksa kembali rekomendasi layout di atas: apakah tetap responsif di bawah 600px, apakah mengurangi aksesibilitas, dan apakah ada widget yang tidak tersedia di Flutter stabil saat ini?"

Output Penting: AI menyarankan agar layout diuji pada beberapa ukuran layar,
terutama layar sempit di bawah 600px dan layar yang lebih lebar. Penggunaan LayoutBuilder dan breakpoint membantu dashboard menyesuaikan jumlah kolom berdasarkan ukuran layar. Penggunaan Semantics pada informasi penting seperti profile, dark mode, dan dashboard card membantu meningkatkan aksesibilitas. Widget yang digunakan seperti LayoutBuilder, GridView,
Expanded, Container, Row, Column, dan CupertinoSwitch tersedia pada Flutter dan dapat digunakan.

Keputusan: Saya mempertahankan struktur dashboard yang menggunakan LayoutBuilder, GridView, Expanded, dan Semantics. Saya menggunakan breakpoint untuk mengubah tampilan menjadi 1 kolom pada layar sempit dan 2 kolom pada layar lebar.

Alasan Teknis: LayoutBuilder dapat mengetahui ukuran ruang yang tersedia, sehingga jumlah kolom dapat disesuaikan dengan ukuran layar. GridView digunakan untuk menyusun card agar tetap rapi. Expanded membantu widget menggunakan ruang yang tersedia secara fleksibel. Semantics dipertahankan agar aplikasi tetap dapat digunakan dengan bantuan teknologi pembaca layar.


