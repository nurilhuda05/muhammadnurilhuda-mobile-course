import 'package:flutter_test/flutter_test.dart';
import 'package:offline_notes/core/failures.dart';
import 'package:offline_notes/features/notes/domain/entities/note.dart';
import 'package:offline_notes/features/notes/domain/usecases/add_note.dart';
import 'package:offline_notes/features/notes/domain/usecases/get_notes.dart';

import '../../fakes/fake_note_repository.dart';

void main() {
  group('Pengujian Usecase dengan FakeNoteRepository (AAA Pattern)', () {
    test('GetNotes berhasil mengambil daftar catatan dari FakeNoteRepository', () async {
      // 1. Arrange
      final initialData = [
        Note(id: 1, title: 'Tugas Mobile', body: 'Jobsheet 12', updatedAt: DateTime(2026, 11, 10)),
        Note(id: 2, title: 'PBL', body: 'Progress Sprint', updatedAt: DateTime(2026, 11, 10)),
      ];
      final fakeRepo = FakeNoteRepository(initialNotes: initialData);
      final getNotes = GetNotes(fakeRepo);

      // 2. Act
      final result = await getNotes();

      // 3. Assert
      expect(result.failure, isNull);
      expect(result.notes.length, 2);
      expect(result.notes.first.title, 'Tugas Mobile');
      expect(fakeRepo.fetchNotesCallCount, 1);
    });

    test('GetNotes menangani kondisi kegagalan data tanpa melempar crash (Failure Condition)', () async {
      // 1. Arrange
      final fakeRepo = FakeNoteRepository(
        failureToReturn: const LocalFailure('Gagal mengakses penyimpanan lokal'),
      );
      final getNotes = GetNotes(fakeRepo);

      // 2. Act
      final result = await getNotes();

      // 3. Assert
      expect(result.failure, isA<LocalFailure>());
      expect(result.failure?.message, 'Gagal mengakses penyimpanan lokal');
      expect(result.notes, isEmpty);
      expect(fakeRepo.fetchNotesCallCount, 1);
    });

    test('AddNote berhasil menyimpan catatan baru ke FakeNoteRepository (Kondisi Berhasil)', () async {
      // 1. Arrange
      final fakeRepo = FakeNoteRepository();
      final addNote = AddNote(fakeRepo);

      // 2. Act
      final result = await addNote(title: 'Catatan Baru', body: 'Deskripsi pengujian');

      // 3. Assert
      expect(result.failure, isNull);
      expect(result.note, isNotNull);
      expect(result.note?.title, 'Catatan Baru');
      expect(result.note?.body, 'Deskripsi pengujian');
      expect(fakeRepo.addNoteCallCount, 1);

      // Pastikan catatan juga tersimpan di list repository
      final fetchResult = await fakeRepo.fetchNotes();
      expect(fetchResult.notes.length, 1);
      expect(fetchResult.notes.first.title, 'Catatan Baru');
    });

    test('AddNote menolak judul kosong tanpa memanggil repository (Edge Case / Validasi Input)', () async {
      // 1. Arrange
      final fakeRepo = FakeNoteRepository();
      final addNote = AddNote(fakeRepo);

      // 2. Act
      final result = await addNote(title: '   ');

      // 3. Assert
      expect(result.failure, isA<LocalFailure>());
      expect(result.failure?.message, 'Judul tidak boleh kosong');
      expect(result.note, isNull);
      expect(fakeRepo.addNoteCallCount, 0); // Repository tidak boleh dipanggil
    });

    test('AddNote meneruskan failure jika FakeNoteRepository mengalami error (Kondisi Kegagalan)', () async {
      // 1. Arrange
      final fakeRepo = FakeNoteRepository(
        failureToReturn: const LocalFailure('Disk penuh / gagal menulis'),
      );
      final addNote = AddNote(fakeRepo);

      // 2. Act
      final result = await addNote(title: 'Judul Valid');

      // 3. Assert
      expect(result.failure, isA<LocalFailure>());
      expect(result.failure?.message, 'Disk penuh / gagal menulis');
      expect(result.note, isNull);
      expect(fakeRepo.addNoteCallCount, 1);
    });
  });
}

