import 'package:dio/dio.dart';
import '../models/comment.dart';

class CommentRepository {
  /// Menerima instance [Dio] yang disuntikkan dari provider
  CommentRepository(this._dio);
  
  final Dio _dio;

  /// Mengambil daftar komentar berdasarkan [postId]
  /// Menggunakan batas waktu (timeout) 10 detik.
  Future<List<Comment>> fetchComments(int postId) async {
    // Meminta endpoint /comments?postId={id}
    final response = await _dio.get<List>(
      '/comments',
      queryParameters: {'postId': postId},
    );
    
    // Ambil datanya, defaultnya list kosong jika null
    final data = response.data ?? [];
    
    // Mapping list dinamis menjadi list objek Comment yang tipenya aman (type-safe)
    return data
        .whereType<Map<String, dynamic>>()
        .map(Comment.fromJson)
        .toList();
  }
}
