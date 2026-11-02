import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/notes_providers.dart';
import '../widgets/add_note_dialog.dart';
import '../widgets/error_view.dart';
import '../widgets/notes_empty_state.dart';
import '../widgets/notes_list.dart';
import '../widgets/notes_search_field.dart';

class NotesPage extends ConsumerStatefulWidget {
  const NotesPage({super.key});

  @override
  ConsumerState<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends ConsumerState<NotesPage> {
  final _queryNotifier = ValueNotifier<String>('');
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    _queryNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.smart_toy_outlined),
            tooltip: 'Asisten AI',
            onPressed: () => context.push('/ai-chat'),
          ),
        ],
      ),
      body: Column(
        children: [
          NotesSearchField(
            controller: _searchController,
            onChanged: (value) => _queryNotifier.value = value,
          ),
          Expanded(
            child: Consumer(
              builder: (context, ref, _) {
                final state = ref.watch(notesProvider);
                return state.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => ErrorView(
                    message: '$e',
                    onRetry: () => ref.invalidate(notesProvider),
                  ),
                  data: (notes) {
                    return ValueListenableBuilder<String>(
                      valueListenable: _queryNotifier,
                      builder: (context, query, _) {
                        final filtered = ref.read(searchNotesProvider)(notes, query);
                        if (filtered.isEmpty) {
                          return NotesEmptyState(isSearching: query.trim().isNotEmpty);
                        }
                        return NotesList(filtered);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
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