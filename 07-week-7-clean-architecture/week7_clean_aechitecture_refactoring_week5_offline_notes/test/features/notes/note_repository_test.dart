import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';


import 'package:week7_clean_aechitecture_refactoring_week5_offline_notes/core/failures.dart';
import 'package:week7_clean_aechitecture_refactoring_week5_offline_notes/features/notes/data/repositories/note_repository_impl.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;  

  late Database db;
  late NoteRepositoryImpl repository;

  setUp(() async {
    db = await openDatabase(
      inMemoryDatabasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            body TEXT NOT NULL DEFAULT '',
            updated_at TEXT NOT NULL,
            dirty INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
    );

    repository = NoteRepositoryImpl(
      openDb: () async => db,
    );
  });

  tearDown(() async {
    await db.close();
  });

  test('addNote menyimpan catatan ke database', () async {
    final result = await repository.addNote(
      title: 'Catatan Test',
      body: 'Isi test',
    );

    expect(result.failure, isNull);
    expect(result.note, isNotNull);
    expect(result.note!.title, 'Catatan Test');
    expect(result.note!.body, 'Isi test');
    expect(result.note!.dirty, true);
  });

  test('fetchNotes mengambil catatan dari database', () async {
    await repository.addNote(
      title: 'Catatan Test',
      body: 'Isi test',
    );

    final result = await repository.fetchNotes();

    expect(result.failure, isNull);
    expect(result.notes.length, 1);
    expect(result.notes.first.title, 'Catatan Test');
  });

  test('repository mengembalikan LocalFailure ketika database gagal', () async {
    final failingRepository = NoteRepositoryImpl(
      openDb: () async {
        throw Exception('Database error');
      },
    );

    final result = await failingRepository.fetchNotes();

    expect(result.notes, isEmpty);
    expect(result.failure, isA<LocalFailure>());
  });
}