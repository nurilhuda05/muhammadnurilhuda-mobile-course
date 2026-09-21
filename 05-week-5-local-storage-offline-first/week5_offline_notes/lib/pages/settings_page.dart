import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/prefs.dart';

final prefsRepositoryProvider = Provider(
  (ref) => PrefsRepository(),
);

class ForceOfflineNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void setOffline(bool value) {
    state = value;
  }
}

final forceOfflineProvider =
    NotifierProvider<ForceOfflineNotifier, bool>(
  ForceOfflineNotifier.new,
);

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final forceOffline = ref.watch(forceOfflineProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SwitchListTile(
        title: const Text('Force Offline'),
        subtitle: const Text(
          'Simulasikan kondisi tanpa internet',
        ),
        value: forceOffline,
        onChanged: (value) {
          ref
              .read(forceOfflineProvider.notifier)
              .setOffline(value);
        },
      ),
    );
  }
}