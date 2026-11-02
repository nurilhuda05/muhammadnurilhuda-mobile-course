import 'package:flutter/material.dart';

import '../../domain/entities/note.dart';
import 'note_item_tile.dart';

class NotesList extends StatelessWidget {
  const NotesList(this.notes, {super.key});

  final List<Note> notes;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return NoteItemTile(
          key: ValueKey(note.id ?? index),
          note: note,
        );
      },
    );
  }
}

