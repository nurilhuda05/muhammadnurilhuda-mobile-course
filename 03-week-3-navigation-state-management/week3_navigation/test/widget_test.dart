// Widget test dasar untuk memastikan aplikasi dapat dirender
// tanpa error. MyApp menggunakan Riverpod, sehingga perlu
// dibungkus dengan ProviderScope saat testing.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:week3_navigation/main.dart';

void main() {
  testWidgets('App renders dengan ProviderScope', (WidgetTester tester) async {
    // Bungkus MyApp dengan ProviderScope agar ConsumerWidget berfungsi
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Verifikasi bahwa AppBar dengan judul 'Produk' muncul
    expect(find.text('Produk'), findsOneWidget);

    // Verifikasi bahwa loading indicator muncul saat data sedang dimuat
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Tunggu semua timer selesai (ProductsNotifier punya delay 2 detik)
    // agar tidak ada pending timer saat test berakhir
    await tester.pump(const Duration(seconds: 3));
  });
}
