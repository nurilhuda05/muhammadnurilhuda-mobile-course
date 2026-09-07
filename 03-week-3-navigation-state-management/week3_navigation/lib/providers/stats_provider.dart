import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Model sederhana untuk satu item statistik.
/// [label] = nama metrik, [value] = nilainya.
class StatItem {
  final String label;
  final String value;
  const StatItem({required this.label, required this.value});
}

/// Tipe fungsi untuk mengambil data statistik.
/// Bisa di-override saat testing agar tidak bergantung pada Random.
typedef FetchStats = Future<List<StatItem>> Function();

/// AsyncNotifier yang mensimulasikan pengambilan data statistik dari server.
///
/// - Delay 2 detik untuk meniru latensi jaringan.
/// - 30% kemungkinan gagal (throw Exception) untuk meniru error jaringan.
/// - Menyediakan method [retry] untuk memuat ulang data saat terjadi error.
class StatsNotifier extends AsyncNotifier<List<StatItem>> {
  /// Fungsi fetch yang bisa di-inject untuk keperluan testing.
  /// Jika null, akan menggunakan [_defaultFetch].
  FetchStats? fetchOverride;

  /// Dipanggil otomatis oleh Riverpod saat provider pertama kali dibaca.
  /// Mengembalikan Future yang menghasilkan list statistik.
  @override
  Future<List<StatItem>> build() => _fetchData();

  /// Method untuk memuat ulang data (retry).
  /// Mengeset state ke loading terlebih dahulu, lalu mengambil data baru.
  /// [AsyncValue.guard] menangkap exception dan mengubahnya menjadi AsyncError.
  Future<void> retry() async {
    // Set state ke loading agar UI menampilkan spinner
    state = const AsyncLoading();
    // Guard menangkap error dan mengkonversinya ke AsyncError secara otomatis
    state = await AsyncValue.guard(() => _fetchData());
  }

  /// Memanggil fetchOverride jika ada (untuk testing), atau _defaultFetch.
  Future<List<StatItem>> _fetchData() {
    if (fetchOverride != null) return fetchOverride!();
    return _defaultFetch();
  }

  /// Simulasi fetch data dari server.
  /// - Menunggu 2 detik (simulasi latensi jaringan).
  /// - Peluang gagal 30% menggunakan Random.
  /// - Jika berhasil, mengembalikan 3 item statistik dummy.
  Future<List<StatItem>> _defaultFetch() async {
    // Simulasi latensi jaringan selama 2 detik
    await Future.delayed(const Duration(seconds: 2));

    // Simulasi kegagalan jaringan dengan probabilitas 30%
    if (Random().nextDouble() < 0.3) {
      throw Exception('Gagal memuat data statistik');
    }

    // Data statistik dummy yang dikembalikan saat sukses
    return const [
      StatItem(label: 'Pengguna Aktif', value: '1.234'),
      StatItem(label: 'Pesanan Hari Ini', value: '567'),
      StatItem(label: 'Pendapatan', value: 'Rp 12.345.678'),
    ];
  }
}

/// Provider global untuk StatsNotifier.
/// Digunakan oleh widget ConsumerWidget untuk membaca state statistik.
final statsProvider =
    AsyncNotifierProvider<StatsNotifier, List<StatItem>>(StatsNotifier.new);
