import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';

import '../local/db.dart';
import '../models/post.dart';

class PostRepository {
  PostRepository(this._dio);

  final Dio _dio;

  // Mengambil data dari API JSONPlaceholder
  Future<List<Post>> fetchPosts() async {
    final response = await _dio.get<List>('/posts');

    final data = response.data ?? [];

    return data
        .whereType<Map<String, dynamic>>()
        .map(Post.fromJson)
        .toList();
  }

  // Cache first
  Future<List<Post>> loadPostsCacheFirst() async {
    final cached = await readCachedPosts();

    refreshPostsInBackground();

    return cached;
  }

  // Membaca cache dari SQLite
  Future<List<Post>> readCachedPosts() async {
    final db = await openNotesDb();

    final rows = await db.query(
      'cached_posts',
      orderBy: 'id ASC',
    );

    return rows.map((row) {
      final json = jsonDecode(
        row['payload'] as String,
      );

      return Post.fromJson(
        json as Map<String, dynamic>,
      );
    }).toList();
  }

  // Menyimpan data API ke SQLite
  Future<void> saveCachedPosts(
    List<Post> posts,
  ) async {
    final db = await openNotesDb();

    final batch = db.batch();

    for (final post in posts) {
      batch.insert(
        'cached_posts',
        {
          'id': post.id,
          'payload': jsonEncode(post.toJson()),
          'cached_at': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  // Refresh API di background
  Future<void> refreshPostsInBackground() async {
    try {
      final posts = await fetchPosts();

      await saveCachedPosts(posts);
    } catch (_) {
      // Jika internet gagal, cache lokal tetap digunakan.
    }
  }
}