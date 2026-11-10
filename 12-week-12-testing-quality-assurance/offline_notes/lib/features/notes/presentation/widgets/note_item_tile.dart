import 'package:flutter/material.dart';

import '../../../../core/format.dart';
import '../../domain/entities/note.dart';

/// Widget item catatan yang diekstrak secara mandiri dengan [const] constructor
/// dan dibungkus oleh [RepaintBoundary] guna mengisolasi render layer
/// dan mencegah repaint menyeluruh saat scrolling.
class NoteItemTile extends StatelessWidget {
  const NoteItemTile({
    super.key,
    required this.note,
  });

  final Note note;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ListTile(
        title: Text(
          note.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          note.body,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          formatDateTime(note.updatedAt),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
