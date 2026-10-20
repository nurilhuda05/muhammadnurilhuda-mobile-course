import 'package:flutter/material.dart';

class NotesSearchField extends StatelessWidget {
  const NotesSearchField({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        key: const Key('note-search-field'),
        onChanged: onChanged,
        decoration: const InputDecoration(
          labelText: 'Cari judul catatan',
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}