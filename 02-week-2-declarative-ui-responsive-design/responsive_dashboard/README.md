# Demo
## Aplikasi hasil akhir pada emulator ukuran ponsel 5
![Screenshot](Screenshot/Emulator%20ukuran%205.png)

## Aplikasi hasil akhir pada emulator ukuran ponsel 10
![Screenshot](Screenshot/Emulator%20ukuran%2010.png)

## Dark mode pada emulator
![Screenshot](Screenshot/Dark%20mode%20pada%20emulator.png)


# Eksperimen warm-up
1. Expanded membuat widget menggunakan sisa ruang yang tersedia. Jika dihapus, teks yang terlalu panjang dapat menyebabkan overflow.
![Screenshot](Screenshot/Hasil%20Menghapus%20Expanded.png)

2. MainAxisSize.min membuat tinggi kartu seminimal mungkin sesuai isi. MainAxisSize.max membuat kartu menggunakan ruang maksimum yang tersedia.
![Screenshot](Screenshot/Mengganti%20MainAxisSize.png)

3. Saya menambahkan data Email menggunakan Row dan Expanded agar posisi label dan nilainya tetap rapi.
![Screenshot](Screenshot/Menambahkan%20Email.png)


# Eksperimen Layout
1. Ubah breakpoint dari 700 menjadi nilai lain dan amati perubahan jumlah kolom. <br>
Hasilnya, jumlah kolom pada dashboard berubah sesuai dengan lebar layar. Semakin kecil nilai breakpoint, semakin cepat dashboard berubah menjadi 2 kolom. Sebaliknya, semakin besar nilai breakpoint, layar membutuhkan ukuran yang lebih lebar untuk menampilkan 2 kolom.

2. Ubah themeMode menjadi ThemeMode.dark, lalu kembalikan ke ThemeMode.system. <br>
Ketika menggunakan ThemeMode.dark, aplikasi selalu menggunakan tema gelap. Sedangkan ThemeMode.system membuat tampilan mengikuti pengaturan tema pada perangkat.

3. Uji aplikasi dengan ukuran layar emulator yang berbeda. <br>
Ketika layar berukuran kecil, dashboard menampilkan 1 kolom, sedangkan pada layar yang lebih lebar menampilkan 2 kolom. Perubahan ini terjadi secara otomatis karena penggunaan LayoutBuilder dan breakpoint.

4. Tambahkan Semantics atau label yang bermakna pada elemen yang penting bagi screen reader. <br>
Semantics digunakan untuk meningkatkan aksesibilitas aplikasi, terutama bagi pengguna yang menggunakan screen reader. Dengan memberikan label deskriptif pada kartu informasi, screen reader dapat mengetahui dan menjelaskan fungsi serta isi dari elemen tersebut kepada pengguna.


# AI Prompt Challenge
1. Prompt Desain
Promt: "Bandingkan dua tata letak dashboard akademik untuk Flutter: versi GridView dan versi LayoutBuilde + Column. Jelaskan trade-off responsif dan aksesibilitasnya." <br>
Output Penting: AI menjelaskan bahwa GridView cocok untuk dashboard
dengan banyak card karena dapat menyusun card dalam bentuk grid. Sedangkan LayoutBuilder memberikan kontrol terhadap perubahan layoutm berdasarkan ukuran layar. AI merekomendasikan untuk menggabungkan LayoutBuilder dan GridView untuk dashboard akademik karena LayoutBuilder menentukan jumlah kolom berdasarkan ukuran layar, sedangkan GridView menyusun card dengan rapi. <br>
Keputusan: Saya memilih menggunakan LayoutBuilder + GridView. <br>
Alasan Teknis: LayoutBuilder digunakan untuk menentukan jumlah kolom berdasarkan lebar layar. GridView digunakan untuk menyusun card agar rapi dan responsif. <br>

2. Prompt penguatan konsep
Promt: "Jelaskan kapan penggunaan Expanded justru menyebabkan overflow di dalam Row, beri contoh kode yang gagal dan perbaikannya." <br>
Output Penting: AI menjelaskan bahwa Expanded digunakan agar widget mengisi ruang yang tersedia di dalam Row atau Colum. Overflow dapat terjadi jika ruang yang tersedia tidak cukup, misalnya terlalu banyak widget berada di dalam Row atau widget di dalam Expanded memiliki ukuran tetap yang terlalu besar. Contohnya, penggunaan Expanded dengan Container yang memiliki width terlalu besar dapat menyebabkan tampilan melebihi lebar layar. Perbaikannya adalah menghindari ukuran tetap yang terlalu besar dan membiarkan Expanded menyesuaikan ukuran dengan ruang yang tersedia<br>
Keputusan: "Saya tetap menggunakan Expanded pada dashboard karena Expandedm membantu membuat tampilan menjadi responsif. Pada dashboard, Expanded digunakan pada bagian teks profil dan pada GridView. <br>
Alasan Teknis: Expanded pada bagian profil membuat teks menggunakan sisa ruang
yang tersedia setelah CircleAvatar dan SizedBox. Expanded pada GridView membuat GridView menggunakan ruang yang tersedia di dalam Column. Penggunaan membuat layout tetap responsif dan tidak mengalami overflow. <br>

3. Verification prompt
Promt: "Periksa kembali rekomendasi layout di atas: apakah tetap responsif di bawah 600px, apakah mengurangi aksesibilitas, dan apakah ada widget yang tidak tersedia di Flutter stabil saat ini?" <br>
Output Penting: AI menyarankan agar layout diuji pada beberapa ukuran layar, terutama layar sempit di bawah 600px dan layar yang lebih lebar. Penggunaan LayoutBuilder dan breakpoint membantu dashboard menyesuaikan jumlah kolom berdasarkan ukuran layar. Penggunaan Semantics pada informasi penting seperti profile, dark mode, dan dashboard card membantu meningkatkan aksesibilitas. Widget yang digunakan seperti LayoutBuilder, GridView, Expanded, Container, Row, Column, dan CupertinoSwitch tersedia pada Flutter dan dapat digunakan. <br>
Keputusan: Saya mempertahankan struktur dashboard yang menggunakan LayoutBuilder, GridView, Expanded, dan Semantics. Saya menggunakan breakpoint untuk mengubah tampilan menjadi 1 kolom pada layar sempit dan 2 kolom pada layar lebar. <br>
Alasan Teknis: LayoutBuilder dapat mengetahui ukuran ruang yang tersedia, sehingga jumlah kolom dapat disesuaikan dengan ukuran layar. GridView digunakan untuk menyusun card agar tetap rapi. Expanded membantu widget menggunakan ruang yang tersedia secara fleksibel. Semantics dipertahankan agar aplikasi tetap dapat digunakan dengan bantuan teknologi pembaca layar. <br>


# Flutter analyze
![Screenshot](Screenshot/Flutter%20Analyze.jpeg)

# Flutter test
![Screenshot](Screenshot/Flutter%20Test.jpeg)

# Layar sempit
![Screenshot](Screenshot/Layar%20Sempit.jpeg)

# Layar lebar
![Screenshot](Screenshot/Layar%20Lebar.jpeg)

# Dark mode
![Screenshot](Screenshot/Dark%20Mode.jpeg)

# Light mode
![Screenshot](Screenshot/Light%20Mode.jpeg)


# Refeleksi
1. Apa perbedaan cara berpikir imperative dan declarative saat membangun UI? <br>
    Pada pendekatan imperative, programmer harus menjelaskan langkah demi langkah bagaimana UI dibuat dan diperbarui. Sedangkan, pada pendekatan declarative, programmer hanya perlu menjelaskan tampilan yang diinginkan berdasarkan kondisi atau data saat ini, dan framework akan mengatur perubahan UI secara otomatis.

2. Kapan Expanded membantu dan kapan penggunaannya justru menghasilkan layout error? <br>
    Expanded membantu ketika kita ingin sebuah widget mengisi sisa ruang yang tersedia di dalam Row atau Column. Tapi, Expended dapat menyebabkan layout error jika digunakan di luar widget induk Row atau Column Selain itu, error juga sering muncul ketika Expanded ditempatkan di dalam widget yang memiliki batas ukuran tidak terbatas.

3. Bagaimana breakpoint dan theme memengaruhi pengalaman pengguna? <br>
    Breakpoint digunakan untuk menyesuaikan tata letak berdasarkan ukuran layar perangkat, seperti smartphone, tablet, atau desktop. Dengan adanya breakpoint, aplikasi dapat menampilkan susunan komponen yang berbeda sesuai ukuran layar sehingga tetap mudah digunakan dan tidak terlihat berantakan. SAedangkan, theme digunakan untuk mengatur tampilan visual aplikasi Penggunaan theme yang konsisten membuat aplikasi lebih menarik, mudah dikenali, dan nyaman digunakan. Selain itu, dukungan tema terang dan gelap dapat meningkatkan kenyamanan pengguna dalam berbagai kondisi pencahayaan

4. Apa yang Anda verifikasi dari rekomendasi AI setelah tugas inti selesai? <br>
    Yang saya verifikasi dari rekomendasi AI adalah apakah tampilan tetap responsif di berbagai ukuran layar, mudah digunakan oleh semua pengguna, dan semua widget dapat digunakan di Flutter. Hasilnya, layout tetap berjalan dengan baik, fitur aksesibilitas tetap tersedia, dan semua widget yang digunakan didukung oleh Flutter versi stabil.


