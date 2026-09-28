import 'dart:io' show Platform;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();

const _kChannelId   = 'pengumuman_kampus';
const _kChannelName = 'Pengumuman Kampus';
const _kChannelDesc = 'Notifikasi pengumuman resmi dari kampus';

// Route string yang belum diproses router
String? pendingDeepLink;

// Ekstrak route dari data payload FCM.
// Fungsi murni (pure function) — tidak bergantung pada Firebase, mudah di-unit-test.
String routeFromMessage(Map<String, dynamic> data) =>
    data['route'] is String ? data['route'] as String : '/';

// Handler untuk background message FCM
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('[FCM Background] messageId  : ${message.messageId}');
  debugPrint('[FCM Background] data       : ${message.data}');
  debugPrint('[FCM Background] notification: ${message.notification?.title}');
}

// Daftarkan handler background (harus sebelum runApp)
void registerBackgroundHandler() {
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
}

// Inisialisasi flutter_local_notifications
Future<void> initLocalNotifications() async {
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

  const iosSettings = DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );

  await _local.initialize(
    const InitializationSettings(android: androidSettings, iOS: iosSettings),
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      pendingDeepLink = response.payload;
      debugPrint('[LocalNotif] Tapped payload: ${response.payload}');
    },
    onDidReceiveBackgroundNotificationResponse: _onBackgroundNotifResponse,
  );

  await _createAndroidChannel();
}

@pragma('vm:entry-point')
void _onBackgroundNotifResponse(NotificationResponse response) {
  debugPrint('[LocalNotif BG] payload: ${response.payload}');
}

// Buat Notification Channel untuk Android (wajib untuk Android 8+)
Future<void> _createAndroidChannel() async {
  final androidPlugin = _local
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  if (androidPlugin == null) return;

  const channel = AndroidNotificationChannel(
    _kChannelId,
    _kChannelName,
    description: _kChannelDesc,
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
    showBadge: true,
  );

  await androidPlugin.createNotificationChannel(channel);
  debugPrint('[LocalNotif] Android channel "$_kChannelId" created/updated.');
}

// Minta izin notifikasi dari pengguna
Future<bool> requestNotificationPermission() async {
  final settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    announcement: false,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
  );

  final granted =
      settings.authorizationStatus == AuthorizationStatus.authorized ||
      settings.authorizationStatus == AuthorizationStatus.provisional;

  debugPrint(
    '[FCM] Permission: ${settings.authorizationStatus.name} | granted=$granted',
  );

  // Request tambahan untuk Android 13+ (POST_NOTIFICATIONS)
  if (Platform.isAndroid) {
    final androidPlugin = _local
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
  }

  return granted;
}

// Ambil token, daftarkan listener refresh, dan subscribe ke topik
Future<void> initFcmToken({
  required Future<void> Function(String token) onToken,
}) async {
  final token = await FirebaseMessaging.instance.getToken();
  if (token != null) {
    debugPrint('[FCM] Initial token: ${token.length > 12 ? '${token.substring(0, 8)}...${token.substring(token.length - 4)}' : token}');
    await onToken(token);
  } else {
    debugPrint('[FCM] Token null — pastikan permission diberikan.');
  }

  FirebaseMessaging.instance.onTokenRefresh.listen(
    (newToken) async {
      debugPrint('[FCM] Token refreshed: ${newToken.length > 12 ? '${newToken.substring(0, 8)}...${newToken.substring(newToken.length - 4)}' : newToken}');
      await onToken(newToken);
    },
    onError: (Object error) {
      debugPrint('[FCM] onTokenRefresh error: $error');
    },
  );

  await subscribeToTopic(kTopicKampus);
}

const kTopicKampus = 'pengumuman-kampus';

Future<void> subscribeToTopic(String topic) async {
  await FirebaseMessaging.instance.subscribeToTopic(topic);
  debugPrint('[FCM] Subscribed to topic: $topic');
}

Future<void> unsubscribeFromTopic(String topic) async {
  await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  debugPrint('[FCM] Unsubscribed from topic: $topic');
}

// Listen untuk pesan FCM saat aplikasi di foreground
void listenForeground(void Function(String route) go) {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    debugPrint('[FCM Foreground] ${message.notification?.title}');

    final route = routeFromMessage(message.data);
    final title = message.notification?.title ?? 'Pengumuman';
    final body  = message.notification?.body  ?? '';

    // Tampilkan local notification saat aplikasi di foreground
    await _showLocalNotification(
      id: message.hashCode,
      title: title,
      body: body,
      payload: route,
    );
  });

  // Saat user tap notifikasi saat aplikasi di background
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    final route = routeFromMessage(message.data);
    debugPrint('[FCM] onMessageOpenedApp → navigasi ke: $route');
    go(route);
  });
}

Future<void> _showLocalNotification({
  required int id,
  required String title,
  required String body,
  String? payload,
}) async {
  const androidDetails = AndroidNotificationDetails(
    _kChannelId,
    _kChannelName,
    channelDescription: _kChannelDesc,
    importance: Importance.high,
    priority: Priority.high,
    showWhen: true,
    icon: '@mipmap/ic_launcher',
  );

  const iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentSound: true,
    presentBadge: true,
  );

  await _local.show(
    id,
    title,
    body,
    const NotificationDetails(android: androidDetails, iOS: iosDetails),
    payload: payload,
  );
}

// Proses pesan yang membuka aplikasi dari state terminated
Future<void> handleTerminated(void Function(String route) go) async {
  final initial = await FirebaseMessaging.instance.getInitialMessage();
  if (initial != null) {
    final route = routeFromMessage(initial.data);
    debugPrint('[FCM] getInitialMessage → navigasi ke: $route');
    go(route);
    return;
  }

  // Handle payload dari local notification tap (foreground banner)
  if (pendingDeepLink != null) {
    debugPrint('[LocalNotif] pendingDeepLink → navigasi ke: $pendingDeepLink');
    go(pendingDeepLink!);
    pendingDeepLink = null;
  }
}

