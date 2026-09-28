import 'package:flutter/material.dart';

class AnnouncementPage extends StatelessWidget {
  final String id;

  const AnnouncementPage({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcement'),
      ),
      body: Center(
        child: Text('Announcement ID: $id'),
      ),
    );
  }
}