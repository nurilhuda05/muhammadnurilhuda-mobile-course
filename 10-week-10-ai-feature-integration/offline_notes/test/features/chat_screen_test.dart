import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_notes/ai/ai_service.dart';
import 'package:offline_notes/features/chat_screen.dart';

class _FakeErrorAiService extends AiService {
  String? _apiKey;

  @override
  Future<String> ask(String question) async {
    throw Exception('Simulasi API gagal / belum ada API key');
  }

  @override
  Future<String?> getApiKey() async => _apiKey;

  @override
  Future<void> saveApiKey(String key) async {
    _apiKey = key;
  }
}

void main() {
  test('AiService memiliki systemPrompt dengan batas bahasa dan privasi', () {
    expect(AiService.systemPrompt, contains('Bahasa Indonesia'));
    expect(AiService.systemPrompt, contains('NIK'));
  });

  testWidgets('ChatScreen menampilkan peringatan privasi dan komponen input',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ChatScreen(),
        ),
      ),
    );

    expect(find.text('Asisten AI Catatan'), findsOneWidget);
    expect(find.textContaining('Keamanan Privasi:'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byIcon(Icons.send), findsOneWidget);
  });

  testWidgets('ChatScreen menampilkan fallback dialog Layanan AI Sibuk saat error',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          aiServiceProvider.overrideWithValue(_FakeErrorAiService()),
        ],
        child: const MaterialApp(
          home: ChatScreen(),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Tes pertanyaan');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();

    expect(find.text('Layanan AI Sibuk'), findsOneWidget);
    expect(
      find.textContaining('Coba lagi nanti atau gunakan mode offline.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Atur API Key'));
    await tester.pumpAndSettle();

    expect(find.text('Atur Gemini API Key'), findsOneWidget);
  });

  testWidgets('Menekan tombol kunci di AppBar dan klik Simpan berhasil menyimpan API Key',
      (WidgetTester tester) async {
    final fakeAi = _FakeErrorAiService();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          aiServiceProvider.overrideWithValue(fakeAi),
        ],
        child: const MaterialApp(
          home: ChatScreen(),
        ),
      ),
    );

    // Klik tombol icon kunci di AppBar
    await tester.tap(find.byIcon(Icons.vpn_key));
    await tester.pumpAndSettle();

    expect(find.text('Atur Gemini API Key'), findsOneWidget);

    // Masukkan API Key pada TextField di dalam dialog
    final dialogTextField = find.descendant(
      of: find.byType(AlertDialog),
      matching: find.byType(TextField),
    );
    await tester.enterText(dialogTextField, 'AIzaSyTest12345');
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    // Dialog tertutup dan snackbar muncul
    expect(find.text('Atur Gemini API Key'), findsNothing);
    expect(find.text('API Key berhasil disimpan dengan aman.'), findsOneWidget);
    expect(await fakeAi.getApiKey(), 'AIzaSyTest12345');
  });
}