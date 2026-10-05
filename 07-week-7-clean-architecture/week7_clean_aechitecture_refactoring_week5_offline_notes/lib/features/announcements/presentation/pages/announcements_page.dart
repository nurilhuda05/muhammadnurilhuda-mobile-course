import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/announcements_providers.dart';
import '../widgets/announcement_card.dart';

class AnnouncementsPage extends ConsumerWidget {
  const AnnouncementsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(announcementsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengumuman'),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$e'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.invalidate(announcementsProvider),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
        data: (items) => items.isEmpty
            ? const Center(child: Text('Belum ada pengumuman.'))
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) =>
                    AnnouncementCard(announcement: items[index]),
              ),
      ),
    );
  }
}
