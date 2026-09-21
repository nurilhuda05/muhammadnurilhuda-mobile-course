import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/prefs.dart';

class ForceOfflineNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setOffline(bool value) => state = value;
}

final forceOfflineProvider =
    NotifierProvider<ForceOfflineNotifier, bool>(ForceOfflineNotifier.new);

// Provider untuk waktu terakhir dibuka
final lastOpenedProvider = FutureProvider<String?>((ref) async {
  final prefs = ref.read(prefsRepositoryProvider);
  return prefs.getLastOpened();
});

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forceOffline = ref.watch(forceOfflineProvider);
    final darkModeAsync = ref.watch(darkModeProvider);
    final lastOpenedAsync = ref.watch(lastOpenedProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // Toggle dark mode
          darkModeAsync.when(
            loading: () => const SwitchListTile(
              title: Text('Tema Gelap'),
              value: false,
              onChanged: null,
            ),
            error: (_, _) => const ListTile(title: Text('Gagal memuat tema')),
            data: (isDark) => SwitchListTile(
              title: const Text('Tema Gelap'),
              subtitle: const Text('Aktifkan tampilan gelap'),
              secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
              value: isDark,
              onChanged: (_) {
                ref.read(darkModeProvider.notifier).toggle();
              },
            ),
          ),
          const Divider(),
          // Toggle force offline
          SwitchListTile(
            title: const Text('Force Offline'),
            subtitle: const Text('Simulasikan kondisi tanpa internet'),
            secondary: const Icon(Icons.airplanemode_active),
            value: forceOffline,
            onChanged: (value) {
              ref.read(forceOfflineProvider.notifier).setOffline(value);
            },
          ),
          const Divider(),
          // Waktu terakhir dibuka
          lastOpenedAsync.when(
            loading: () => const ListTile(
              leading: Icon(Icons.access_time),
              title: Text('Terakhir dibuka'),
              subtitle: Text('Memuat...'),
            ),
            error: (_, _) => const ListTile(
              leading: Icon(Icons.access_time),
              title: Text('Terakhir dibuka'),
              subtitle: Text('Tidak tersedia'),
            ),
            data: (lastOpened) => ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Terakhir dibuka'),
              subtitle: Text(
                lastOpened != null
                    ? _formatDateTime(lastOpened)
                    : 'Belum pernah dicatat',
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return iso;
    }
  }
}