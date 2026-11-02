import 'package:sqflite/sqflite.dart';

import '../../../../core/failures.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';
import '../models/note_model.dart';

class NoteRepositoryImpl implements NoteRepository {
  NoteRepositoryImpl({required this._openDb});

  final Future<Database> Function() _openDb;

  // In-memory cache layer untuk optimasi performa dan mengurangi query berulang
  List<Note>? _cachedNotes;

  @override
  Future<({List<Note> notes, Failure? failure})> fetchNotes() async {
    // Kembalikan dari in-memory cache jika tersedia
    if (_cachedNotes != null) {
      return (notes: _cachedNotes!, failure: null);
    }
    return fetchNotesPaginated();
  }

  Future<({List<Note> notes, Failure? failure})> fetchNotesPaginated({
    int? limit,
    int? offset,
  }) async {
    try {
      final db = await _openDb();
      final rows = await db.query(
        'notes',
        orderBy: 'updated_at DESC',
        limit: limit,
        offset: offset,
      );
      final notes = rows.map((r) => NoteModel.fromMap(r).toEntity()).toList();

      // Perbarui cache jika pembacaan data penuh
      if (limit == null && offset == null) {
        _cachedNotes = notes;
      }

      return (notes: notes, failure: null);
    } catch (e) {
      // Fallback ke cache jika terjadi kendala pembacaan
      if (_cachedNotes != null) {
        return (notes: _cachedNotes!, failure: null);
      }
      return (
        notes: const <Note>[],
        failure: LocalFailure('Gagal membaca catatan: $e'),
      );
    }
  }

  @override
  Future<({Note? note, Failure? failure})> addNote({
    required String title,
    String body = '',
  }) async {
    try {
      final db = await _openDb();
      final now = DateTime.now();
      final id = await db.insert(
        'notes',
        NoteModel(
          title: title,
          body: body,
          updatedAt: now,
          dirty: true,
        ).toMap(),
      );
      final createdNote = Note(
        id: id,
        title: title,
        body: body,
        updatedAt: now,
        dirty: true,
      );

      // Mutasi cache lokal secara langsung (optimistic/write-through cache)
      if (_cachedNotes != null) {
        _cachedNotes = [createdNote, ..._cachedNotes!];
      }

      return (note: createdNote, failure: null);
    } catch (e) {
      return (note: null, failure: LocalFailure('Gagal menyimpan catatan: $e'));
    }
  }
}

