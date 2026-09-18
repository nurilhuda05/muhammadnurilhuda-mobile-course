// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:week4_api/main.dart';
import 'package:week4_api/data/providers.dart';
import 'package:week4_api/data/repositories/post_repository.dart';
import 'package:week4_api/data/models/post.dart';
import 'package:dio/dio.dart';

class MockPostRepository extends PostRepository {
  MockPostRepository() : super(Dio());

  @override
  Future<List<Post>> fetchPosts() async => [];

  @override
  Future<List<Post>> fetchPostsPage({required int page, int limit = 10}) async => [];
}

void main() {
  testWidgets('App starts smoke test', (WidgetTester tester) async {
    // Karena aplikasi menggunakan Riverpod dan memicu request HTTP saat 
    // pertama kali dibuka (yang memicu pending timers di Dio),
    // kita akan mem-mock repository-nya agar mengembalikan list kosong.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          postRepositoryProvider.overrideWithValue(MockPostRepository()),
        ],
        child: const MyApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verifikasi bahwa aplikasi berhasil dirender dengan memeriksa
    // apakah MaterialApp ada (menandakan root widget berhasil dibuild).
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
