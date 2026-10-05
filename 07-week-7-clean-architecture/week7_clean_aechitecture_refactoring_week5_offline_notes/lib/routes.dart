import 'package:go_router/go_router.dart';

import 'features/notes/presentation/pages/notes_page.dart';
import 'features/announcements/presentation/pages/announcements_page.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const NotesPage(),
    ),
    GoRoute(
      path: '/announcements',
      builder: (context, state) => const AnnouncementsPage(),
    ),
  ],
);