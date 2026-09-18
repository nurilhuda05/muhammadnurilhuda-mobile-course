import 'package:flutter_test/flutter_test.dart';
import 'package:week4_api/data/models/comment.dart';

void main() {
  group('Comment Model', () {
    test('fromJson menangani field yang hilang (null-safe)', () {
      // JSON tanpa field sama sekali atau beberapa field hilang
      final Map<String, dynamic> emptyJson = {};
      
      // Mengubah JSON yang kosong menjadi object Comment
      final comment = Comment.fromJson(emptyJson);
      
      // Memeriksa bahwa nilai default digunakan ketika field tidak ada
      expect(comment.postId, 0, reason: 'postId harus 0 jika null/tidak ada');
      expect(comment.id, 0, reason: 'id harus 0 jika null/tidak ada');
      expect(comment.name, '', reason: 'name harus string kosong jika null/tidak ada');
      expect(comment.email, '', reason: 'email harus string kosong jika null/tidak ada');
      expect(comment.body, '', reason: 'body harus string kosong jika null/tidak ada');
    });

    test('fromJson bekerja dengan benar saat data lengkap', () {
      final Map<String, dynamic> completeJson = {
        'postId': 1,
        'id': 2,
        'name': 'John Doe',
        'email': 'john@example.com',
        'body': 'Komentar yang sangat bagus',
      };
      
      final comment = Comment.fromJson(completeJson);
      
      expect(comment.postId, 1);
      expect(comment.id, 2);
      expect(comment.name, 'John Doe');
      expect(comment.email, 'john@example.com');
      expect(comment.body, 'Komentar yang sangat bagus');
    });

    test('fromJson menangani tipe data yang salah (edge case)', () {
      // JSON dengan nilai tipe data yang salah atau eksplisit null
      final Map<String, dynamic> edgeCaseJson = {
        'postId': 'bukan angka', // Seharusnya angka
        'id': null, // Eksplisit null
        'name': 12345, // Seharusnya string
        'email': true, // Seharusnya string
        'body': ['array', 'bukan', 'string'], // Seharusnya string
      };
      
      final comment = Comment.fromJson(edgeCaseJson);
      
      // Memastikan tipe data yang salah tidak memicu crash 
      // dan ditangani dengan nilai fallback/default yang tepat.
      expect(comment.postId, 0, reason: 'Teks tidak bisa diparse jadi angka, kembalikan default 0');
      expect(comment.id, 0, reason: 'Explicit null harus menjadi 0');
      
      // Karena sekarang kita memakai .toString(), tipe apapun (angka, boolean, array) 
      // akan dikonversi menjadi string dengan aman tanpa TypeError crash.
      expect(comment.name, '12345'); 
      expect(comment.email, 'true'); 
      expect(comment.body, '[array, bukan, string]');
    });
  });
}
