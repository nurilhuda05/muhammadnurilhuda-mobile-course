import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AiService {
  final _storage = const FlutterSecureStorage();
  // Daftar URL model kandidat (mengatasi 404 jika model lama di-deprecate di endpoint v1beta)
  static const List<String> _candidateModelUrls = [
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent',
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent',
    'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent',
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent',
  ];

  // System prompt sesuai materi Prompt Design (Bagian 2.3)
  static const String systemPrompt =
      'Kamu asisten kampus dan pencatatan yang ramah, jawab dalam Bahasa Indonesia '
      'dengan ringkas dan jelas (maksimal 3 kalimat). Jangan pernah meminta atau '
      'menampilkan data sensitif seperti NIK, nomor telepon, atau alamat rumah.';

  Future<String> ask(String question) async {
    final apiKey = await _storage.read(key: 'ai_api_key');
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('API key tidak tersedia. Silakan atur di pengaturan.');
    }

    final requestBody = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': '$systemPrompt\n\nPertanyaan pengguna: $question'}
          ]
        }
      ]
    });

    String lastErrorMessage = 'Gagal menghubungi AI API.';

    for (final apiUrl in _candidateModelUrls) {
      final response = await http.post(
        Uri.parse('$apiUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final candidates = data['candidates'] as List?;
        if (candidates != null && candidates.isNotEmpty) {
          final content = candidates[0]['content'];
          final parts = content?['parts'] as List?;
          if (parts != null && parts.isNotEmpty) {
            return parts[0]['text'] ?? 'Tidak ada respons teks dari AI.';
          }
        }
        return 'AI tidak memberikan jawaban.';
      }

      String errorMessage = 'HTTP ${response.statusCode}';
      try {
        final errorData = jsonDecode(response.body);
        if (errorData['error']?['message'] != null) {
          errorMessage =
              'HTTP ${response.statusCode}: ${errorData['error']['message']}';
        }
      } catch (_) {
        errorMessage = 'HTTP ${response.statusCode}: ${response.body}';
      }
      lastErrorMessage = errorMessage;

      // Jika error bukan 404 (misal 400 Invalid key, 403, 429), langsung lempar error
      if (response.statusCode != 404) {
        throw Exception(errorMessage);
      }
    }

    throw Exception(lastErrorMessage);
  }

  Future<void> saveApiKey(String key) async {
    try {
      await _storage.write(key: 'ai_api_key', value: key);
    } catch (_) {
      try {
        await _storage.deleteAll();
        await _storage.write(key: 'ai_api_key', value: key);
      } catch (e) {
        throw Exception('Gagal menyimpan API key: $e');
      }
    }
  }

  Future<String?> getApiKey() async {
    try {
      return await _storage.read(key: 'ai_api_key');
    } catch (_) {
      return null;
    }
  }
}