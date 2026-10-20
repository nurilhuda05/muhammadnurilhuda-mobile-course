import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week7_clean_aechitecture_refactoring_week5_offline_notes/features/notes/domain/entities/note.dart';
import 'package:week7_clean_aechitecture_refactoring_week5_offline_notes/features/notes/presentation/pages/notes_page.dart';
import 'package:week7_clean_aechitecture_refactoring_week5_offline_notes/features/notes/presentation/providers/notes_providers.dart';

void main() {
  final notes = [
    Note(title: 'Belanja', updatedAt: DateTime(2026)),
    Note(title: 'Kuliah Flutter', updatedAt: DateTime(2026)),
  ];

  test('pencarian judul tidak peka huruf besar-kecil', () {
    expect(filterNotesByTitle(notes, 'FLUTter').single.title, 'Kuliah Flutter');
  });

  test('query kosong menampilkan semua notes', () {
    expect(filterNotesByTitle(notes, ' ').length, 2);
  });

  test('query tak cocok kembalikan kosong', () {
    expect(filterNotesByTitle(notes, 'zzz-tak-ada'), isEmpty);
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
}
