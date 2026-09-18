// Widget test yang kompatibel dengan GoRouter + Riverpod.
// Menggunakan mock repository agar tidak ada HTTP request sungguhan.

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

  @override
  Future<Post?> fetchPost(int id) async => null;
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

    // Verifikasi bahwa aplikasi berhasil dirender.
    // MaterialApp.router masih merupakan MaterialApp, jadi finder ini tetap valid.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
