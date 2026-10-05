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

# PRAKTIKUM 2
## Verifikasi Akses Langsung pada Presentation Layer
![screenshot](screenshot/Praktikum%203.1.png)<br>
Hasil pencarian tidak menemukan penggunaan Dio, openDatabase, getDatabasesPath, FlutterSecureStorage, SharedPreferences.getInstance, maupun jsonDecode. Dengan demikian, berdasarkan pola yang diperiksa, bagian presentation tidak melakukan akses langsung terhadap sumber data.<br>

## Verifikasi Dependency pada Domain Layer
![screenshot](screenshot/Praktikum%203.2.png)<br>
Pada pemeriksaan dependency, dilakukan pencarian import Flutter, Dio, Sqflite, dan Firebase pada bagian Domain dan Core. Hasil pencarian tidak menemukan import tersebut. Dengan demikian, berdasarkan pemeriksaan ini, Domain dan Core tidak memiliki dependency langsung terhadap teknologi tersebut<br>

## Flutter Analyze dan Flutter Test
![screenshot](screenshot/Praktikum%203.3.png)<br>

## Hasil Praktikum 3
![screenshot](screenshot/Praktikum%203.4.jpeg)<br>

# HASIL AI CHALLENGE

Berdasarkan hasil review AI, terdapat beberapa hal yang perlu diperhatikan pada struktur Clean Architecture project ini:<br>

**1. Pemindahan `db.dart`**<br>
File `db.dart` disarankan dipindahkan ke folder `core/`. Hal ini karena database merupakan bagian dari infrastruktur aplikasi dan tidak hanya digunakan oleh fitur `notes`. Dengan dipindahkan ke `core/`, database dapat digunakan oleh fitur lain jika aplikasi dikembangkan.<br>

**2. Pemecahan `notes_page.dart`**<br>
File `notes_page.dart` perlu dipecah karena di dalamnya terdapat empat class, yaitu `NotesPage`, `AddNoteDialog`, `ErrorView`, dan `NotesList`. Class tersebut sebaiknya dipisahkan ke file masing-masing agar setiap file memiliki tanggung jawab yang lebih jelas dan kode lebih mudah dikelola.<br>

**3. Penggunaan Use Case**<br>
`AddNote` dan `GetNotes` saat ini termasuk over-engineering untuk CRUD sederhana karena keduanya hanya meneruskan pemanggilan ke repository dan belum memiliki business logic.<br>

Namun, untuk tugas kuliah, kedua use case tersebut tetap dipertahankan sebagai contoh penerapan Clean Architecture. Jika digunakan untuk project production yang hanya memiliki CRUD sederhana, use case tersebut dapat dihilangkan dan provider dapat memanggil repository secara langsung.<br>

**4. Dependency Injection dengan Riverpod**<br>
Terdapat dua pilihan dalam wiring Dependency Injection menggunakan Riverpod.

   * **Opsi A (Academic):** tetap menggunakan use case. Alurnya menjadi UI → Provider → Use Case → Repository. Struktur ini lebih lengkap dan sesuai untuk menunjukkan pola Clean Architecture, tetapi memiliki lebih banyak lapisan.
   * **Opsi B (Pragmatic):** tidak menggunakan use case. Alurnya menjadi UI → Provider → Repository. Struktur ini lebih sederhana dan cocok untuk CRUD sederhana, tetapi kurang menunjukkan penerapan lengkap Clean Architecture.

Untuk tugas praktikum ini, **Opsi A dipilih** karena tujuan utamanya adalah mempelajari dan menunjukkan penerapan Clean Architecture.

# AI VERIFICATION 
**1. Apakah interface repository tinggal di domain dan implementasi di data? (tolak bila AI menaruh keduanya di satu folder).**<br>
Interface repository sudah berada di Domain Layer, yaitu abstract class NoteRepository pada domain/repositories/note_repository.dart. Implementasinya berada di Data Layer, yaitu NoteRepositoryImpl pada data/repositories/note_repository_impl.dart. Keduanya tidak berada dalam satu folder dan dependency mengarah dari Data ke Domain, sehingga pembagian repository sudah sesuai dengan prinsip Clean Architecture.<br>

**2. Apakah domain bebas import Flutter/Dio/SQLite/Firebase? Periksa dengan grep, bukan dengan membaca sekilas.**<br>
Domain sudah bebas dari dependency seperti Flutter, Dio, SQLite, Firebase, dan Path. Hasil pengecekan pada folder domain/ tidak menemukan import dari package tersebut. Domain hanya menggunakan file internal seperti entity Note dan Failure. Sementara itu, dependency seperti SQLite dan Path hanya digunakan pada bagian infrastruktur database, sehingga Domain tetap berupa kode Dart yang independen.<br>

**3. Apakah AI membuat use case untuk tiap CRUD satu-baris? (itu over-engineering: cukup repository langsung ke notifier, dengan alasan tertulis).**<br>
Use case AddNote dan GetNotes termasuk over-engineering untuk CRUD sederhana karena keduanya hanya meneruskan pemanggilan ke repository tanpa memiliki business logic. Meskipun demikian, kedua use case tetap dipertahankan karena project ini merupakan tugas kuliah Week 7 yang bertujuan menunjukkan penerapan layer Clean Architecture. Untuk project production dengan CRUD sederhana, use case dapat dihilangkan dan provider dapat memanggil repository secara langsung. Use case akan lebih diperlukan ketika sudah terdapat business logic seperti validasi atau orkestrasi beberapa repository.<br>

**4. Apakah entity bebas mapping (toMap/fromMap/toJson hanya di model)?**<br>
Entity Note sudah bebas dari proses mapping data. Hasil pengecekan tidak menemukan toMap, fromMap, toJson, atau fromJson pada Domain Layer. Proses mapping hanya dilakukan pada NoteModel di Data Layer melalui toMap(), fromMap(), dan toEntity(). Dengan demikian, entity tetap menjadi plain class dan tidak bergantung pada format penyimpanan database.<br>

**5. Apakah wiring DI terpusat di provider dan widget tidak new Repository() sendiri?**<br>
Dependency Injection sudah ditempatkan pada provider dan widget tidak membuat NoteRepositoryImpl secara langsung. NoteRepositoryImpl dibuat melalui noteRepositoryProvider di notes_providers.dart, kemudian widget mengakses dependency melalui ref.watch() atau ref.read(). Dengan cara ini, Presentation Layer tidak perlu mengetahui bagaimana repository dibuat dan implementasinya dapat diganti ketika melakukan testing<br>

**6. Kesimpulan Akhir**<br>
Berdasarkan hasil verifikasi, use case AddNote dan GetNotes tetap dipertahankan karena sesuai dengan tujuan pembelajaran Clean Architecture pada tugas Week 7. Datasource layer tidak ditambahkan karena repository saat ini hanya menggunakan satu sumber data, yaitu SQLite, sehingga penambahan abstraction tambahan dianggap belum diperlukan. Database ditempatkan pada core/ karena merupakan infrastruktur yang dapat digunakan oleh berbagai fitur. notes_page.dart juga dipecah menjadi beberapa file agar setiap widget memiliki tanggung jawab yang lebih jelas. Untuk Dependency Injection digunakan Riverpod tanpa GetIt atau Injectable karena Riverpod sudah dapat digunakan sebagai DI sekaligus state management.<br>
