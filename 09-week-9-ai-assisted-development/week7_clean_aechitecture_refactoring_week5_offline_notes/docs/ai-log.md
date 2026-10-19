# PROMT

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


# HASIL AI

Fitur pencarian judul selesai. Pencarian berjalan di memori pada daftar notes yang sudah dimuat; widget tidak mengakses SQLite dan kontrak NoteRepository tidak berubah.

Implementasi dan empty state ada di notes_page.dart.
Tiga test—pencarian tanpa membedakan kapitalisasi, query kosong, dan widget test empty state—ada di notes_search_test.dart.
Validasi: flutter test lulus (10 test); flutter analyze tidak menemukan masalah.

