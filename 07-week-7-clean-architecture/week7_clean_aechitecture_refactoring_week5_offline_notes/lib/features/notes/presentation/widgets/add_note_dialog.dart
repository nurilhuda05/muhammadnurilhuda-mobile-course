import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/notes_providers.dart';

class AddNoteDialog extends ConsumerStatefulWidget {
  const AddNoteDialog({super.key});

  @override
  ConsumerState<AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends ConsumerState<AddNoteDialog> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tambah Catatan'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Judul',
            ),
          ),
          TextField(
            controller: bodyController,
            decoration: const InputDecoration(
              labelText: 'Isi',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () async {
            await ref.read(addNoteProvider).call(
                  title: titleController.text,
                  body: bodyController.text,
                );

            if (context.mounted) {
              Navigator.pop(context);
              ref.invalidate(notesProvider);
            }
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
