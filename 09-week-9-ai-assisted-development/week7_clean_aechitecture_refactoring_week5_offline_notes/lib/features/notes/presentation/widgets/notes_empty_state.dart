import 'package:flutter/material.dart';

class NotesEmptyState extends StatelessWidget {
  const NotesEmptyState({super.key, required this.isSearching});

  final bool isSearching;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        isSearching ? 'Catatan tidak ditemukan.' : 'Belum ada catatan.',
      ),
    );
  }
}