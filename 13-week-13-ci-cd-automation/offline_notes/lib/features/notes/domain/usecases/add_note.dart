import '../../../../core/failures.dart';
import '../entities/note.dart';
import '../repositories/note_repository.dart';
import '../validators.dart';

class AddNote {
  const AddNote(this._repository);

  final NoteRepository _repository;

  Future<({Note? note, Failure? failure})> call({
    required String title,
    String body = '',
  }) async {
    if (!isValidNoteTitle(title)) {
      return (
        note: null,
        failure: const LocalFailure('Judul tidak boleh kosong'),
      );
    }
    return _repository.addNote(title: title, body: body);
  }
}
