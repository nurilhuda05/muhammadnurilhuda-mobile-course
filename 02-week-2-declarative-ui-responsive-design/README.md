Eksperimen Layout
1. Ubah breakpoint dari 700 menjadi nilai lain dan amati perubahan jumlah kolom.

Hasilnya, jumlah kolom pada dashboard berubah sesuai dengan lebar layar. Semakin kecil nilai breakpoint, semakin cepat dashboard berubah menjadi 2 kolom. Sebaliknya, semakin besar nilai breakpoint, layar membutuhkan ukuran yang lebih lebar untuk menampilkan 2 kolom.

2. Ubah themeMode menjadi ThemeMode.dark, lalu kembalikan ke ThemeMode.system.

Ketika menggunakan ThemeMode.dark, aplikasi selalu menggunakan tema gelap. Sedangkan ThemeMode.system membuat tampilan mengikuti pengaturan tema pada perangkat.

3. Uji aplikasi dengan ukuran layar emulator yang berbeda.

Ketika layar berukuran kecil, dashboard menampilkan 1 kolom, sedangkan pada layar yang lebih lebar menampilkan 2 kolom. Perubahan ini terjadi secara otomatis karena penggunaan LayoutBuilder dan breakpoint.

4. Tambahkan Semantics atau label yang bermakna pada elemen yang penting bagi screen reader.

Semantics digunakan untuk meningkatkan aksesibilitas aplikasi, terutama bagi pengguna yang menggunakan screen reader. Dengan memberikan label seperti “Dark mode” pada CupertinoSwitch, screen reader dapat mengetahui dan menjelaskan fungsi switch tersebut kepada pengguna.

