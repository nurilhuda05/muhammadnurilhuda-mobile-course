import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/note.dart';
import '../providers/notes_providers.dart';
import '../widgets/add_note_dialog.dart';
import '../widgets/error_view.dart';
import '../widgets/notes_list.dart';

List<Note> filterNotesByTitle(List<Note> notes, String query) {
  final normalizedQuery = query.trim().toLowerCase();
  return notes
      .where((note) => note.title.toLowerCase().contains(normalizedQuery))
      .toList();
}

class NotesPage extends ConsumerStatefulWidget {
  const NotesPage({super.key});

  @override
  ConsumerState<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends ConsumerState<NotesPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Catatan')),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(
          message: '$e',
          onRetry: () => ref.invalidate(notesProvider),
        ),
        data: (notes) {
          final filtered = filterNotesByTitle(notes, _query);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  key: const Key('note-search-field'),
                  onChanged: (value) => setState(() => _query = value),
                  decoration: const InputDecoration(
                    labelText: 'Cari judul catatan',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Text(
                          _query.trim().isEmpty
                              ? 'Belum ada catatan.'
                              : 'Catatan tidak ditemukan.',
                        ),
                      )
                    : NotesList(filtered),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddNoteDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
