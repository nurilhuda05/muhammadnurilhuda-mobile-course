import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ai/ai_service.dart';

final aiServiceProvider = Provider<AiService>((ref) => AiService());

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String _streamingText = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final question = _controller.text.trim();
    if (question.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(ChatMessage(text: question, isUser: true));
      _isLoading = true;
      _streamingText = '';
    });
    _controller.clear();

    final aiService = ref.read(aiServiceProvider);

    try {
      final response = await aiService.ask(question);
      await _simulateStreaming(response);
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(text: response, isUser: false));
        _streamingText = '';
      });
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Layanan AI Sibuk'),
          content: Text(
            'Coba lagi nanti atau gunakan mode offline.\n\nDetail: $e',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showApiKeyDialog();
              },
              child: const Text('Atur API Key'),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _simulateStreaming(String fullText) async {
    final words = fullText.split(' ');
    final buffer = StringBuffer();
    for (final word in words) {
      if (!mounted) break;
      buffer.write('$word ');
      setState(() {
        _streamingText = buffer.toString();
      });
      await Future.delayed(const Duration(milliseconds: 35));
    }
  }

  Future<void> _showApiKeyDialog() async {
    final aiService = ref.read(aiServiceProvider);
    final currentKey = await aiService.getApiKey() ?? '';
    final keyController = TextEditingController(text: currentKey);

    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Atur Gemini API Key'),
        content: TextField(
          controller: keyController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'API Key',
            hintText: 'Masukkan API Key Gemini Anda',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              await aiService.saveApiKey(keyController.text.trim());
              if (dialogContext.mounted) {
                Navigator.pop(dialogContext);
              }
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('API Key berhasil disimpan dengan aman.'),
                  ),
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    keyController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asisten AI Catatan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.vpn_key),
            tooltip: 'Atur API Key',
            onPressed: _showApiKeyDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.amber.shade100,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: const Text(
              'Keamanan Privasi: Jangan pernah mengirim NIK, nomor telepon, atau alamat pribadi ke AI.',
              style: TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length + (_streamingText.isNotEmpty ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _streamingText.isNotEmpty) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Card(
                      color: Colors.grey.shade200,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(_streamingText),
                      ),
                    ),
                  );
                }
                final msg = _messages[index];
                return Align(
                  alignment:
                      msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Card(
                    color: msg.isUser
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Colors.grey.shade200,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(msg.text),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Tanyakan sesuatu tentang catatan/kampus...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _isLoading ? null : _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}