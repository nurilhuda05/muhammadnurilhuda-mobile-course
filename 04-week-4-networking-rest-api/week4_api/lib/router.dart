import 'package:go_router/go_router.dart';
import 'pages/paged_post_page.dart';
import 'pages/post_detail_page.dart';

/// Konfigurasi GoRouter terpusat untuk seluruh aplikasi.
/// Rute utama:
///   '/'         → halaman daftar post (paged)
///   '/post/:id' → halaman detail post
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const PagedPostPage(),
    ),
    GoRoute(
      path: '/post/:id',
      builder: (context, state) {
        // Ambil parameter :id dari URL dan konversi ke int
        final id = int.parse(state.pathParameters['id']!);
        return PostDetailPage(postId: id);
      },
    ),
  ],
);
