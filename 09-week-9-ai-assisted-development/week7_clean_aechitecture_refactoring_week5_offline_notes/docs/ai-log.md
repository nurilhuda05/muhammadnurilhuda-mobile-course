# PRAKTIKUM 2

## Promt

PERAN:
Kamu adalah senior Flutter developer.

KONTEKS:
Proyek memakai feature-first, Riverpod, SQLite + Dio.
Arsitektur: presentation -> domain <- data.

[Struktur folder (lib)]
lib/
  main.dart
  routes.dart
  core/
    failures.dart
    format.dart
    database/database_helper.dart
  features/
    announcements/ (data, domain, presentation)
    notes/
      data/
        models/note_model.dart
        repositories/note_repository_impl.dart
      domain/
        entities/note.dart
        repositories/note_repository.dart
        usecases/add_note.dart
        usecases/get_notes.dart
      presentation/
        pages/notes_page.dart
        providers/notes_providers.dart
        widgets/add_note_dialog.dart
        widgets/error_view.dart
        widgets/notes_list.dart

[File kontrak repository: note_repository.dart]
import '../../domain/entities/note.dart';
import '../../../../core/failures.dart';

abstract class NoteRepository {
  Future<({List<Note> notes, Failure? failure})> fetchNotes();

  Future<({Note? note, Failure? failure})> addNote({
    required String title,
    String body = '',
  });
}

[Versi package dari pubspec.yaml]
dependencies:
  flutter_riverpod: ^3.4.3
  shared_preferences: ^2.5.5
  sqflite: ^2.4.4
  path: ^1.9.1
  dio: ^5.11.1
  go_router: ^18.0.1
dev_dependencies:
  flutter_lints: ^6.0.0
  sqflite_common_ffi: ^2.4.3

TUGAS:
Tambah search judul notes + empty state.
Jangan panggil SQLite dari widget.

BATAS:
- Jangan ubah arsitektur yang sudah ada.
- Maksimal 80 baris kode.
- Hal yang TIDAK boleh diubah: kontrak NoteRepository (note_repository.dart) yang sudah ada.

OUTPUT:
- Kode fitur search judul notes + empty state.
- 3 test case (termasuk 1 widget test untuk empty state).
- Cara menguji fitur.


## Hasil AI

Fitur pencarian judul selesai. Pencarian berjalan di memori pada daftar notes yang sudah dimuat; widget tidak mengakses SQLite dan kontrak NoteRepository tidak berubah.

Implementasi dan empty state ada di notes_page.dart.
Tiga test—pencarian tanpa membedakan kapitalisasi, query kosong, dan widget test empty state—ada di notes_search_test.dart.
Validasi: flutter test lulus (10 test); flutter analyze tidak menemukan masalah.


## Verifikasi Hasil AI
#### 1. Uji Manual: Query Kosong
![screenshot](../screenshot/praktikum2/1.jpeg)<br>
Saat kolom pencarian kosong, semua catatan tampil.

#### 2. Uji Manual: Query Cocok
![screenshot](../screenshot/praktikum2/2.jpeg)<br>
Hanya catatan yang judulnya mengandung kata kunci yang tampil.

#### 3. Uji Manual: Query Tak Cocok
![screenshot](../screenshot/praktikum2/3.jpeg)<br>
Muncul empty state "Catatan tidak ditemukan.".

#### 4. Hasil flutter analyze dan flutter test
![screenshot](../screenshot/praktikum2/4.png)<br>
`flutter analyze` menunjukkan No issues found, dan `flutter test` menunjukkan semua test lulus.

#### 5. Bukti 1 dan 2: Celah Arsitektur dan Celah Test
![screenshot](../screenshot/praktikum2/5.png)<br>
Pencarian `filterNotesByTitle` menunjukkan fungsi berada di `notes_page.dart` (lapisan presentation), padahal seharusnya di use case domain. Pencarian `tidak ditemukan` di folder `test` hasilnya kosong, artinya teks "Catatan tidak ditemukan." belum punya widget test.


# PRAKTIKUM 3
## Debug dengan Test Merah
#### 1. Reproduksi
Saya melakukan reproduksi dengan membuka halaman Catatan, kemudian mengetikkan `zzz-tak-ada` pada kolom pencarian. Hasil yang saya harapkan adalah tampilnya teks "Catatan tidak ditemukan.", dan hasil yang saya amati pada layar sesuai dengan harapan tersebut.

#### 2. Isolasi
Bagian yang saya isolasi adalah fungsi `filterNotesByTitle` pada `notes_page.dart` baris 10. Fungsi ini bersifat murni sehingga dapat saya uji langsung tanpa UI melalui unit test. Adapun pemilihan teks empty state di dalam `build` belum teruji dan memerlukan widget test.

#### 3. Test Widget Empty State
![screenshot](../screenshot/praktikum3/1.png)<br>
Saya menambahkan widget test `query tak cocok menampilkan empty state` pada `test/notes_search_test.dart`. Hasil pengujian menunjukkan seluruh test pada file tersebut lulus (5 test). Test tidak berstatus merah karena saya tidak menemukan bug logika pada kode.

#### 4. Hasil Mesin: flutter test dan flutter analyze
![screenshot](../screenshot/praktikum3/2.png)<br>
Saya menjalankan `flutter test` untuk seluruh proyek dan hasilnya 12 test lulus. Saya juga menjalankan `flutter analyze` dan tidak ditemukan masalah (No issues found).

#### 5. Akar Masalah
Akar masalah yang saya temukan adalah celah pengujian, yaitu cabang "Catatan tidak ditemukan." sudah berfungsi benar tetapi belum memiliki test otomatis. Temuan ini bukan bug logika sehingga saya tidak mengubah kode. Saya menutup celah tersebut dengan menambahkan widget test.
