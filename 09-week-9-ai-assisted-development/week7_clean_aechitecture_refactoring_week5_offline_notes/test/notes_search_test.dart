import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week7_clean_aechitecture_refactoring_week5_offline_notes/features/notes/domain/entities/note.dart';
import 'package:week7_clean_aechitecture_refactoring_week5_offline_notes/features/notes/presentation/pages/notes_page.dart';
import 'package:week7_clean_aechitecture_refactoring_week5_offline_notes/features/notes/presentation/providers/notes_providers.dart';
import 'package:week7_clean_aechitecture_refactoring_week5_offline_notes/features/notes/domain/usecases/search_notes.dart';

void main() {
  final notes = [
    Note(title: 'Belanja', updatedAt: DateTime(2026)),
    Note(title: 'Kuliah Flutter', updatedAt: DateTime(2026)),
  ];

  const searchNotes = SearchNotes();

  test('pencarian judul tidak peka huruf besar-kecil', () {
    expect(searchNotes(notes, 'FLUTter').single.title, 'Kuliah Flutter');
  });

  test('query kosong menampilkan semua notes', () {
    expect(searchNotes(notes, ' ').length, 2);
  });

  test('query tak cocok kembalikan kosong', () {
    expect(searchNotes(notes, 'zzz-tak-ada'), isEmpty);
  });

  testWidgets('empty state tampil saat belum ada notes', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [notesProvider.overrideWith((ref) async => const <Note>[])],
        child: const MaterialApp(home: NotesPage()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Belum ada catatan.'), findsOneWidget);
  });

  testWidgets('query tak cocok menampilkan empty state', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [notesProvider.overrideWith((ref) async => notes)],
        child: const MaterialApp(home: NotesPage()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('note-search-field')),
      'zzz-tak-ada',
    );
    await tester.pump();
    expect(find.text('Catatan tidak ditemukan.'), findsOneWidget);
  });
}
