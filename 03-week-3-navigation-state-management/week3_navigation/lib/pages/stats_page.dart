import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/stats_provider.dart';

/// StatsPage — halaman yang menampilkan data statistik.
///
/// Menggunakan ConsumerWidget dari flutter_riverpod agar widget ini
/// bisa membaca (watch) provider secara reaktif. Setiap kali state
/// statsProvider berubah (loading → data / error), widget otomatis rebuild.
class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Membaca state terkini dari statsProvider.
    // ref.watch membuat widget rebuild otomatis saat state berubah.
    final statsAsync = ref.watch(statsProvider);

    return Scaffold(
      // AppBar dengan judul halaman
      appBar: AppBar(title: const Text('Statistik')),

      // Body menggunakan .when() dari AsyncValue untuk menangani 3 state:
      // loading, error, dan data (success).
      body: statsAsync.when(
        // === STATE: LOADING ===
        // Menampilkan spinner di tengah layar saat data sedang dimuat.
        loading: () => const Center(child: CircularProgressIndicator()),

        // === STATE: ERROR ===
        // Menampilkan pesan error dan tombol retry saat terjadi kegagalan.
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Ikon error berwarna merah untuk feedback visual
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                // Menampilkan pesan error dari exception
                Text(
                  'Gagal memuat: $err',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                // Tombol retry — memanggil method retry() di StatsNotifier
                // yang akan reset state ke loading dan fetch ulang data.
                FilledButton.icon(
                  onPressed: () =>
                      ref.read(statsProvider.notifier).retry(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        ),

        // === STATE: DATA (SUCCESS) ===
        // Menampilkan list statistik dalam ListView.
        data: (stats) => ListView.builder(
          // Jumlah item sesuai panjang list yang dikembalikan notifier
          itemCount: stats.length,
          itemBuilder: (context, index) {
            final item = stats[index];
            return ListTile(
              // Ikon chart di sebelah kiri setiap item
              leading: const Icon(Icons.bar_chart),
              // Label statistik sebagai judul
              title: Text(item.label),
              // Nilai statistik sebagai subtitle
              subtitle: Text(item.value),
            );
          },
        ),
      ),
    );
  }
}
