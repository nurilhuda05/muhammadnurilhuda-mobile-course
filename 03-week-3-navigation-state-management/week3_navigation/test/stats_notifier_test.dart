import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week3_navigation/providers/stats_provider.dart';

/// Unit test untuk StatsNotifier.
///
/// Menggunakan ProviderContainer dari Riverpod untuk menguji notifier
/// tanpa perlu widget tree. Semua test menggunakan overrideWith agar
/// fetchOverride di-set SEBELUM build() dipanggil, sehingga tidak
/// ada delay 2 detik dari _defaultFetch().
///
/// CATATAN: Di Riverpod 3.x, container.read(provider.future) HANG
/// jika build() melempar exception. Oleh karena itu, error case
/// diuji melalui retry() setelah build awal berhasil.
void main() {
  group('StatsNotifier Unit Tests', () {
    /// Helper function untuk membuat ProviderContainer dengan
    /// fetchOverride yang sudah di-inject sebelum build() berjalan.
    ///
    /// Menggunakan statsProvider.overrideWith() agar factory function
    /// membuat notifier dengan fetchOverride sudah ter-set.
    /// Ini mencegah _defaultFetch() (delay 2 detik) berjalan di test.
    ProviderContainer createContainer(FetchStats fetchFn) {
      return ProviderContainer(
        overrides: [
          statsProvider.overrideWith(() {
            final notifier = StatsNotifier();
            // Set fetchOverride SEBELUM build() dipanggil oleh Riverpod
            notifier.fetchOverride = fetchFn;
            return notifier;
          }),
        ],
      );
    }

    /// Test 1: Memastikan state awal adalah AsyncLoading.
    ///
    /// Saat provider pertama kali dibaca, build() dipanggil dan
    /// state dimulai dari AsyncLoading sebelum Future selesai.
    test('Memastikan state awal adalah AsyncLoading', () {
      // Buat container dengan fetch yang mengembalikan data instan
      final container = createContainer(() async {
        return const [StatItem(label: 'A', value: '1')];
      });
      // addTearDown memastikan container di-dispose setelah test selesai
      addTearDown(container.dispose);

      // Baca state langsung — seharusnya masih loading
      // karena Future belum selesai (belum di-await)
      final state = container.read(statsProvider);
      expect(state, isA<AsyncLoading<List<StatItem>>>());
    });

    /// Test 2: Memastikan data berhasil dimuat setelah fetch selesai.
    ///
    /// fetchOverride mengembalikan 3 item tanpa delay.
    /// Setelah Future selesai, state harus berisi AsyncData
    /// dengan list berisi 3 StatItem.
    test('Memastikan data berhasil dimuat (AsyncData)', () async {
      // Data dummy yang akan dikembalikan oleh fetch
      const dummyStats = [
        StatItem(label: 'Pengguna', value: '100'),
        StatItem(label: 'Pesanan', value: '50'),
        StatItem(label: 'Revenue', value: 'Rp 1.000.000'),
      ];

      // Buat container dengan fetch yang mengembalikan dummy data
      final container = createContainer(() async => dummyStats);
      addTearDown(container.dispose);

      // Tunggu hingga Future selesai (aman karena build() berhasil)
      await container.read(statsProvider.future);

      // Baca state — sekarang seharusnya AsyncData
      final state = container.read(statsProvider);
      // Verifikasi bahwa state adalah AsyncData
      expect(state, isA<AsyncData<List<StatItem>>>());
      // Verifikasi jumlah item yang dikembalikan adalah 3
      expect(state.value!.length, 3);
      // Verifikasi isi item pertama
      expect(state.value![0].label, 'Pengguna');
      expect(state.value![0].value, '100');
    });

    /// Test 3: Memastikan StatsNotifier melempar Exception saat fetch gagal.
    ///
    /// Strategi: build awal dibuat SUKSES terlebih dahulu, lalu
    /// fetchOverride diganti agar melempar Exception, kemudian
    /// retry() dipanggil. Ini menghindari bug Riverpod 3.x dimana
    /// provider.future hang saat build() throw.
    ///
    /// retry() memanggil _fetchData() → fetchOverride() → throw,
    /// dan AsyncValue.guard mengkonversinya ke AsyncError.
    test('Memastikan StatsNotifier melempar Exception saat terjadi kegagalan',
        () async {
      // Build awal berhasil agar provider.future tidak hang
      final container = createContainer(() async {
        return const [StatItem(label: 'Init', value: '0')];
      });
      addTearDown(container.dispose);

      // Tunggu build awal selesai
      await container.read(statsProvider.future);

      // Ganti fetchOverride agar melempar Exception
      container.read(statsProvider.notifier).fetchOverride = () async {
        throw Exception('Simulated error');
      };

      // Panggil retry() — AsyncValue.guard menangkap error
      // dan mengubahnya menjadi AsyncError tanpa throw
      await container.read(statsProvider.notifier).retry();

      // Baca state — seharusnya AsyncError sekarang
      final state = container.read(statsProvider);
      expect(state, isA<AsyncError<List<StatItem>>>());
      // Verifikasi bahwa error message mengandung teks yang benar
      expect(state.error.toString(), contains('Simulated error'));
    });

    /// Test 4: Memastikan retry() berhasil memuat ulang data setelah error.
    ///
    /// Skenario lengkap: sukses → error (via retry) → sukses (via retry lagi).
    /// Membuktikan bahwa retry() bisa memulihkan state dari error
    /// kembali ke data yang valid.
    test('Memastikan retry() memuat ulang data setelah error', () async {
      // Build awal berhasil
      final container = createContainer(() async {
        return const [StatItem(label: 'Init', value: '0')];
      });
      addTearDown(container.dispose);

      // Tunggu build awal selesai
      await container.read(statsProvider.future);

      // === Fase 1: Buat error ===
      container.read(statsProvider.notifier).fetchOverride = () async {
        throw Exception('Network error');
      };
      await container.read(statsProvider.notifier).retry();

      // Verifikasi state adalah error
      expect(container.read(statsProvider), isA<AsyncError<List<StatItem>>>());

      // === Fase 2: Recovery dengan data baru ===
      container.read(statsProvider.notifier).fetchOverride = () async {
        return const [
          StatItem(label: 'Recovered', value: '999'),
        ];
      };

      // Panggil retry() untuk memuat ulang data
      await container.read(statsProvider.notifier).retry();

      // Baca state — seharusnya AsyncData sekarang
      final state = container.read(statsProvider);
      expect(state, isA<AsyncData<List<StatItem>>>());
      expect(state.value!.length, 1);
      expect(state.value![0].label, 'Recovered');
    });
  });
}
