import 'package:offline_notes/core/failures.dart';
import 'package:offline_notes/features/notes/domain/entities/note.dart';
import 'package:offline_notes/features/notes/domain/repositories/note_repository.dart';

/// Implementasi Fake Repository untuk mengisolasi pengujian dari SQLite / Jaringan
/// Sesuai Bagian 5 & 6 Jobsheet 12.
class FakeNoteRepository implements NoteRepository {
  FakeNoteRepository({
    List<Note>? initialNotes,
    this.failureToReturn,
  }) : _notes = initialNotes != null ? List<Note>.from(initialNotes) : [];

  final List<Note> _notes;
  Failure? failureToReturn;
  int fetchNotesCallCount = 0;
  int addNoteCallCount = 0;

  @override
  Future<({List<Note> notes, Failure? failure})> fetchNotes() async {
    fetchNotesCallCount++;
    if (failureToReturn != null) {
      return (notes: const <Note>[], failure: failureToReturn);
    }
    return (notes: List<Note>.unmodifiable(_notes), failure: null);
  }

  @override
  Future<({Note? note, Failure? failure})> addNote({
    required String title,
    String body = '',
  }) async {
    addNoteCallCount++;
    if (failureToReturn != null) {
      return (note: null, failure: failureToReturn);
    }
    final newNote = Note(
      id: _notes.length + 1,
      title: title,
      body: body,
      updatedAt: DateTime.now(),
      dirty: false,
    );
    _notes.add(newNote);
    return (note: newNote, failure: null);
  }
}
