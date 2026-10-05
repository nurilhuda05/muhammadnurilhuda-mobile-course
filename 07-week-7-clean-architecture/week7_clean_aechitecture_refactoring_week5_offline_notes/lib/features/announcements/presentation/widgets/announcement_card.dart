import 'package:flutter/material.dart';
import '../../../../core/format.dart';
import '../../domain/entities/announcement.dart';

class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard({super.key, required this.announcement});

  final Announcement announcement;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: const Icon(Icons.campaign),
        title: Text(announcement.title),
        subtitle: Text(announcement.content),
        trailing: Text(
          formatDateOnly(announcement.createdAt),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
