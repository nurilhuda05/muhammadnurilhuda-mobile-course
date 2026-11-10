import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_notes/features/notes/domain/entities/note.dart';
import 'package:offline_notes/features/notes/domain/usecases/add_note.dart';
import 'package:offline_notes/features/notes/presentation/pages/notes_page.dart';
import 'package:offline_notes/features/notes/presentation/providers/notes_providers.dart';

import '../../fakes/fake_note_repository.dart';

void main() {
  group('Widget Test Fitur Utama Catatan (Jobsheet 12)', () {
    testWidgets('1. Menampilkan indikator loading saat data catatan sedang dimuat', (
      tester,
    ) async {
      final completer = Completer<List<Note>>();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            notesProvider.overrideWith((ref) => completer.future),
          ],
          child: const MaterialApp(home: NotesPage()),
        ),
      );

      // Assert loading indicator tampil saat asynchronous belum selesai
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete([]);
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('2. Menampilkan tampilan kosong (empty state) jika tidak ada catatan', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            notesProvider.overrideWith((ref) async => const <Note>[]),
          ],
          child: const MaterialApp(home: NotesPage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Belum ada catatan.'), findsOneWidget);
    });

    testWidgets('3. Menampilkan pesan error dan tombol Coba lagi saat terjadi kesalahan', (
      tester,
    ) async {
      var fail = true;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            notesProvider.overrideWith((ref) async {
              if (fail) throw Exception('Koneksi database bermasalah');
              return [
                Note(id: 1, title: 'Catatan Pulih', updatedAt: DateTime(2026, 11, 10)),
              ];
            }),
          ],
          child: const MaterialApp(home: NotesPage()),
        ),
      );
      await tester.pumpAndSettle();

      // Assert error view dan tombol Coba Lagi
      expect(find.textContaining('Koneksi database bermasalah'), findsOneWidget);
      expect(find.text('Coba Lagi'), findsOneWidget);

      // Klik Coba Lagi
      fail = false;
      await tester.tap(find.text('Coba Lagi'));
      await tester.pumpAndSettle();

      // Assert data pulih
      expect(find.text('Catatan Pulih'), findsOneWidget);
    });

    testWidgets('4. Membuka dialog tambah catatan dan menampilkan error jika judul kosong', (
      tester,
    ) async {
      final fakeRepo = FakeNoteRepository();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            notesProvider.overrideWith((ref) async => (await fakeRepo.fetchNotes()).notes),
            noteRepositoryProvider.overrideWithValue(fakeRepo),
            addNoteProvider.overrideWithValue(AddNote(fakeRepo)),
          ],
          child: const MaterialApp(home: NotesPage()),
        ),
      );
      await tester.pumpAndSettle();

      // Tap FAB untuk membuka dialog
      await tester.tap(find.byKey(const Key('add-note-fab')));
      await tester.pumpAndSettle();

      expect(find.text('Tambah Catatan'), findsOneWidget);

      // Klik tombol Simpan tanpa mengisi field judul
      await tester.tap(find.byKey(const Key('save-note-button')));
      await tester.pump();

      // Assert SnackBar validasi judul kosong muncul
      expect(find.text('Judul tidak boleh kosong'), findsOneWidget);
      expect(fakeRepo.addNoteCallCount, 0);
    });

    testWidgets('5. Berhasil menyimpan catatan baru dan menambahkannya ke tampilan list', (
      tester,
    ) async {
      final fakeRepo = FakeNoteRepository();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            notesProvider.overrideWith((ref) async => (await fakeRepo.fetchNotes()).notes),
            noteRepositoryProvider.overrideWithValue(fakeRepo),
            addNoteProvider.overrideWithValue(AddNote(fakeRepo)),
          ],
          child: const MaterialApp(home: NotesPage()),
        ),
      );
      await tester.pumpAndSettle();

      // Buka dialog tambah catatan
      await tester.tap(find.byKey(const Key('add-note-fab')));
      await tester.pumpAndSettle();

      // Ketik judul dan isi
      await tester.enterText(find.byKey(const Key('note-title-field')), 'Belajar QA Flutter');
      await tester.enterText(find.byKey(const Key('note-body-field')), 'Widget testing dan unit testing');
      await tester.pump();

      // Tekan tombol simpan
      await tester.tap(find.byKey(const Key('save-note-button')));
      await tester.pumpAndSettle();

      // Assert dialog tertutup dan catatan tampil di list utama
      expect(find.text('Tambah Catatan'), findsNothing);
      expect(find.text('Belajar QA Flutter'), findsOneWidget);
      expect(find.text('Widget testing dan unit testing'), findsOneWidget);
      expect(fakeRepo.addNoteCallCount, 1);
    });

    testWidgets('6. Menekan tombol Batal menutup dialog tanpa menyimpan catatan', (
      tester,
    ) async {
      final fakeRepo = FakeNoteRepository();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            notesProvider.overrideWith((ref) async => const <Note>[]),
            noteRepositoryProvider.overrideWithValue(fakeRepo),
          ],
          child: const MaterialApp(home: NotesPage()),
        ),
      );
      await tester.pumpAndSettle();

      // Buka dialog
      await tester.tap(find.byKey(const Key('add-note-fab')));
      await tester.pumpAndSettle();

      expect(find.text('Tambah Catatan'), findsOneWidget);

      // Tekan tombol Batal
      await tester.tap(find.text('Batal'));
      await tester.pumpAndSettle();

      // Assert dialog tertutup dan tidak ada pemanggilan addNote
      expect(find.text('Tambah Catatan'), findsNothing);
      expect(fakeRepo.addNoteCallCount, 0);
    });
  });
}
