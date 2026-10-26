import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_notes/ai/ai_service.dart';
import 'package:offline_notes/features/chat_screen.dart';

class _FakeErrorAiService extends AiService {
  @override
  Future<String> ask(String question) async {
    throw Exception('Simulasi API gagal / belum ada API key');
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
  });
}