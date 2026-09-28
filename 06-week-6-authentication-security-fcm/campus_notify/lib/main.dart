import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'data/api_client.dart';
import 'data/auth_repository.dart';
import 'data/device_repository.dart';
import 'data/token_store.dart';
import 'messaging/push_service.dart';
import 'pages/announcement_page.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'providers/auth_provider.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp();

  // Background handler WAJIB didaftarkan sebelum runApp
  registerBackgroundHandler();

  // Inisialisasi Local Notifications
  await initLocalNotifications();

  // Minta izin notifikasi (POST_NOTIFICATIONS untuk Android 13+)
  await requestNotificationPermission();

  // Setup DeviceRepository tanpa Riverpod untuk call onToken
  final store       = TokenStore();
  final authRepo    = AuthRepository();
  final dio         = buildApiClient(store, authRepo);
  final deviceRepo  = DeviceRepository(dio: dio);

  // Ambil token FCM dan kirim ke backend
  await initFcmToken(
    onToken: (token) async {
      try {
        await deviceRepo.registerToken(token);
        debugPrint('[main] FCM token dikirim ke /devices');
      } catch (e) {
        debugPrint('[main] Gagal mengirim token ke backend: $e');
      }
    },
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final container = ProviderScope.containerOf(context);

    final router = GoRouter(
      redirect: (context, state) {
        final loggedIn = container.read(authStateProvider).value ?? false;
        final goingLogin = state.matchedLocation == AppRoutes.login;

        if (!loggedIn && !goingLogin) return AppRoutes.login;
        if (loggedIn && goingLogin) return AppRoutes.home;
        return null;
      },
      routes: [
        GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginPage()),
        GoRoute(path: AppRoutes.home, builder: (_, _) => const HomePage()),
        GoRoute(
          path: '${AppRoutes.pengumuman}/:id',
          builder: (_, state) =>
              AnnouncementPage(id: state.pathParameters['id'] ?? ''),
        ),
      ],
    );

    // Listen untuk notifikasi saat aplikasi berjalan
    listenForeground((route) => router.go(route));

    // Listen saat aplikasi dibuka dari state terminated
    handleTerminated((route) => router.go(route));

    return MaterialApp.router(
      title: 'Campus Notify',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}

