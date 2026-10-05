# PRAKTIKUM 1
## Petakan file ke layer
1. - File: pages/notes_page.dart
   - Layer: Presentation
   - Masalah: Widget masih membuat NoteRepository secara langsung, memanggil repository langsung untuk mengambil/menambah data, dan memanggil fungsi syncNotes secara langsung.

2. - File: data/prefs.dart
   - Layer: Data + Presentation
   - Masalah: PrefsRepository menangani SharedPreferences, tetapi DarkModeNotifier juga berada di file yang sama sehingga tanggung jawab data dan state presentation tercampur.

3. - File: data/sync.dart
   - Layer: Data
   - Masalah: Mencampurkan logika sinkronisasi catatan, cache Post, akses SQLite langsung, dan pemrosesan JSON dalam satu file.

4. - File: data/local/db.dart
   - Layer: Data
   - Masalah: Menangani detail SQLite secara langsung, termasuk membuka database, menentukan versi database, dan membuat tabel notes serta cached_posts.

5. - File: data/local/note.dart
   - Layer: Data
   - Masalah: Class Note mencampurkan data catatan dengan mapping SQLite melalui toMap() dan fromMap(). Entity dan Model belum dipisahkan.

6. - File: data/models/post.dart
   - Layer: Data
   - Masalah: Model sudah berada di data layer dan menangani mapping JSON. Tidak terlihat pelanggaran layer yang signifikan dari file ini.

7. - File: data/repositories/note_repository.dart
   - Layer: Data + Presentation
   - Masalah: Repository langsung mengakses SQLite, tetapi file yang sama juga berisi provider Riverpod (noteRepositoryProvider dan notesProvider). Selain itu, kontrak/interface repository belum dipisahkan ke domain.

8. - File: data/repositories/post_repository.dart
   - Layer: Data
   - Masalah: Repository masih langsung bergantung pada Dio dan belum memiliki interface repository di domain.

9. - File: pages/note_detail_page.dart
   - Layer: DPresentation
   - Masalah: Widget membuat NoteRepository secara langsung dan memanggil repository langsung untuk mengambil data. Dependency masih bocor ke presentation.

10. - File: pages/settings_page.dart
   - Layer: Presentation
   - Masalah: Halaman masih mengakses PrefsRepository secara langsung, provider lastOpenedProvider berada di file halaman, dan terdapat logika pemformatan tanggal di dalam page.


## Tandai tiga pelanggaran klasik
1. Pemeriksaan Akses Jaringan dan Database pada Presentation
![screenshot](screenshot/Praktikum%201.1.png)<br>
Tidak ditemukan penggunaan langsung Dio, http, openDatabase, SharedPreferences.getInstance, atau FlutterSecureStorage di dalam folder lib/pages.<br>

2. Memeriksa Logika Bisnis di dalam build()
![screenshot](screenshot/Praktikum%201.2.png)<br>
Tidak ditemukan penggunaan ketiga pola tersebut di dalam halaman/presentation. Jadi, berdasarkan pemeriksaan ini, tidak ada logika pemformatan tanggal, parsing JSON, atau konversi tanggal ISO yang terdeteksi di lib/pages.<br>

3. Memeriksa Instansiasi Manual (DI Bocor)
![screenshot](screenshot/Praktikum%201.3.png)<br>
Hasil pencarian menemukan dua penggunaan NoteRepository() secara langsung, yaitu pada note_detail_page.dart dan notes_page.dart. Hal ini menunjukkan bahwa terdapat dependency yang dibuat langsung oleh UI sehingga terjadi kebocoran dependency injection.<br>

## Gambar struktur target
![screenshot](screenshot/Praktikum%201.4.png)<br>

