import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/note_repository.dart';
import '../data/sync.dart';
import 'settings_page.dart';

class NotesPage extends ConsumerStatefulWidget {
  const NotesPage({super.key});

  @override
  ConsumerState<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends ConsumerState<NotesPage> {
  final NoteRepository _repository = NoteRepository();

  List<dynamic> _notes = [];
  int _dirtyCount = 0;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await _repository.fetchNotes();
    final dirty = await _repository.countDirty();

    setState(() {
      _notes = notes;
      _dirtyCount = dirty;
    });
  }

  Future<void> _addNote() async {
    await _repository.addNote(
      title: 'Catatan ${_notes.length + 1}',
      body: 'Catatan dibuat secara offline.',
    );

    await _loadNotes();
  }

  Future<void> _syncNotes() async {
    final isOffline = ref.read(forceOfflineProvider);

    if (isOffline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sync gagal: Force Offline sedang aktif'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final count = await syncNotes(_repository);

    await _loadNotes();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$count catatan berhasil disinkronkan'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes - Dirty: $_dirtyCount'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.push('/settings');
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];

          return NoteTile(note: note);
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add',
            onPressed: _addNote,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'sync',
            onPressed: _syncNotes,
            child: const Icon(Icons.sync),
          ),
        ],
      ),
    );
  }
}

class NoteTile extends StatelessWidget {
  final dynamic note;

  const NoteTile({
    super.key,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(note.title),
      subtitle: Text(note.body),
      trailing: note.dirty
          ? const Badge(
              label: Text('belum tersinkron'),
              child: Icon(Icons.sync_problem),
            )
          : const Icon(Icons.cloud_done),
      onTap: () {
        context.push('/note/${note.id}');
      },
    );
  }
}