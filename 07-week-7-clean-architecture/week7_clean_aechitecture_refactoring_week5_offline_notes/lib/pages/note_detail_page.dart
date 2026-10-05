import 'package:flutter/material.dart';

import '../data/local/note.dart';
import '../data/repositories/note_repository.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteId;

  const NoteDetailPage({super.key, required this.noteId});

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  final NoteRepository _repository = NoteRepository();
  Note? _note;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNote();
  }

  Future<void> _loadNote() async {
    final note = await _repository.getNoteById(widget.noteId);
    setState(() {
      _note = note;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_note == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Not Found')),
        body: const Center(child: Text('Catatan tidak ditemukan.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(_note!.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          _note!.body,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
