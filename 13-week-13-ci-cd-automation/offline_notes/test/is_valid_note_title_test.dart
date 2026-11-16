import 'package:flutter_test/flutter_test.dart';
import 'package:offline_notes/features/notes/domain/validators.dart';

void main() {
  group('isValidNoteTitle - Unit Testing Logika Validasi Judul (AAA Pattern)', () {
    test('menerima judul yang berisi teks normal', () {
      // 1. Arrange: siapkan data input
      const title = 'Belajar Testing Flutter';

      // 2. Act: jalankan fungsi yang diuji
      final result = isValidNoteTitle(title);

      // 3. Assert: periksa hasil
      expect(result, isTrue);
    });

    test('menerima judul yang diawali atau diakhiri spasi namun memiliki teks', () {
      // 1. Arrange
      const title = '   Catatan Praktikum Minggu 12   ';

      // 2. Act
      final result = isValidNoteTitle(title);

      // 3. Assert
      expect(result, isTrue);
    });

    test('menolak judul berupa string kosong (Edge Case)', () {
      // 1. Arrange
      const emptyTitle = '';

      // 2. Act
      final result = isValidNoteTitle(emptyTitle);

      // 3. Assert
      expect(result, isFalse);
    });

    test('menolak judul yang hanya berisi karakter spasi dan tab (Edge Case)', () {
      // 1. Arrange
      const whitespaceOnly = '     \t  \n ';

      // 2. Act
      final result = isValidNoteTitle(whitespaceOnly);

      // 3. Assert
      expect(result, isFalse);
    });
  });
}

