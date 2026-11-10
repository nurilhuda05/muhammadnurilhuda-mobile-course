import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:offline_notes/main.dart' as app;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi SQLite FFI untuk desktop runner (Windows/Linux/macOS)
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  testWidgets(
    'Alur utama: pengguna dapat membuka aplikasi, menambahkan catatan baru, dan melihatnya di daftar',
    (tester) async {
      // 1. Jalankan aplikasi
      app.main();
      await tester.pumpAndSettle();

      // 2. Pastikan halaman Catatan terbuka
      expect(find.text('Catatan'), findsOneWidget);

      // 3. Tekan Floating Action Button (+) untuk membuka dialog
      final fabFinder = find.byKey(const Key('add-note-fab'));
      expect(fabFinder, findsOneWidget);
      await tester.tap(fabFinder);
      await tester.pumpAndSettle();

      // 4. Pastikan dialog tambah catatan muncul
      expect(find.text('Tambah Catatan'), findsOneWidget);

      // 5. Masukkan judul dan isi catatan
      const testTitle = 'Catatan Integrasi QA';
      const testBody = 'Pengujian alur end-to-end aplikasi Flutter';

      await tester.enterText(find.byKey(const Key('note-title-field')), testTitle);
      await tester.enterText(find.byKey(const Key('note-body-field')), testBody);
      await tester.pumpAndSettle();

      // 6. Tekan tombol Simpan
      final saveButtonFinder = find.byKey(const Key('save-note-button'));
      expect(saveButtonFinder, findsOneWidget);
      await tester.tap(saveButtonFinder);
      await tester.pumpAndSettle();

      // 7. Verifikasi dialog telah tertutup dan catatan baru tampil pada daftar
      expect(find.text('Tambah Catatan'), findsNothing);
      expect(find.text(testTitle), findsOneWidget);
      expect(find.text(testBody), findsOneWidget);

      // 8. Uji interaksi pencarian terhadap catatan yang baru dibuat
      final searchFinder = find.byKey(const Key('note-search-field'));
      expect(searchFinder, findsOneWidget);

      await tester.enterText(searchFinder, 'Integrasi');
      await tester.pumpAndSettle();
      expect(find.text(testTitle), findsOneWidget);

      // Pencarian kata kunci yang tidak cocok
      await tester.enterText(searchFinder, 'KataKunciYangTidakCocok');
      await tester.pumpAndSettle();
      expect(find.text('Catatan tidak ditemukan.'), findsOneWidget);
      expect(find.text(testTitle), findsNothing);
    },
  );
}
