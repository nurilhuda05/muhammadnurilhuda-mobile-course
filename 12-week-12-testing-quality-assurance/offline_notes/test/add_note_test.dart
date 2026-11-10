import 'package:flutter_test/flutter_test.dart';
import 'package:offline_notes/core/failures.dart';
import 'package:offline_notes/features/notes/domain/entities/note.dart';
import 'package:offline_notes/features/notes/domain/repositories/note_repository.dart';
import 'package:offline_notes/features/notes/domain/usecases/add_note.dart';

class FakeAddNoteRepository implements NoteRepository {
  int addCallCount = 0;

  @override
  Future<({Note? note, Failure? failure})> addNote({
    required String title,
    String body = '',
  }) async {
    addCallCount++;
    return (
      note: Note(title: title, body: body, updatedAt: DateTime.now()),
      failure: null,
    );
  }

  @override
  Future<({List<Note> notes, Failure? failure})> fetchNotes() async =>
      (notes: const <Note>[], failure: null);
}

void main() {
  test('AddNote mengembalikan LocalFailure jika judul kosong', () async {
    final repo = FakeAddNoteRepository();
    final result = await AddNote(repo).call(title: '   ');

    expect(result.failure, isA<LocalFailure>());
    expect(result.note, isNull);
    expect(repo.addCallCount, 0);
  });

  test('AddNote meneruskan ke repository jika judul valid', () async {
    final repo = FakeAddNoteRepository();
    final result = await AddNote(repo).call(title: 'Belanja');

    expect(result.failure, isNull);
    expect(result.note?.title, 'Belanja');
    expect(repo.addCallCount, 1);
  });
}
