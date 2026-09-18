import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/paged_posts.dart';
import '../data/network_errors.dart';

/// Halaman detail post yang menampilkan title dan body secara lengkap.
/// Data diambil dari [postDetailProvider] yang secara cerdas
/// mengecek cache terlebih dahulu sebelum fetch ke API.
class PostDetailPage extends ConsumerWidget {
  const PostDetailPage({super.key, required this.postId});

  /// ID post yang akan ditampilkan, diterima dari parameter rute
  final int postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mendengarkan state detail post berdasarkan ID
    final postAsync = ref.watch(postDetailProvider(postId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Post #$postId'),
      ),
      body: postAsync.when(
        // Tampilkan indikator loading saat data sedang dimuat
        loading: () => const Center(child: CircularProgressIndicator()),

        // Tampilkan pesan error yang ramah pengguna jika gagal
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  friendlyErrorMessage(err),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => ref.invalidate(postDetailProvider(postId)),
                  child: const Text('Coba lagi'),
                ),
              ],
            ),
          ),
        ),

        // Tampilkan data post jika berhasil dimuat
        data: (post) {
          if (post == null) {
            return const Center(
              child: Text('Post tidak ditemukan.'),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul post ditampilkan dengan ukuran besar
                Text(
                  post.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                // Divider pemisah antara judul dan isi
                const Divider(),
                const SizedBox(height: 8),
                // Body/isi post ditampilkan secara lengkap
                Text(
                  post.body,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
