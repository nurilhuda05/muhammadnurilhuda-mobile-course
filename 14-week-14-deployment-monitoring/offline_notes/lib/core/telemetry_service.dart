import 'dart:developer' as developer;

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class TelemetryService {
  TelemetryService._();
  static final TelemetryService instance = TelemetryService._();

  /// Mencatat event analitik non-sensitif ke Firebase Analytics
  /// Sesuai Jobsheet 14: Tidak mencatat isi form, email, token, atau data pribadi
  Future<void> logBetaFeedback({String screenName = 'home'}) async {
    try {
      await FirebaseAnalytics.instance.logEvent(
        name: 'beta_feedback_sent',
        parameters: {'screen_name': screenName},
      );
      developer.log(
        'Telemetry: Event "beta_feedback_sent" berhasil dicatat untuk screen: $screenName',
        name: 'TelemetryService',
      );
    } catch (e) {
      developer.log(
        'Telemetry Notice: Gagal mencatat event ke Firebase Analytics: $e',
        name: 'TelemetryService',
      );
    }
  }

  /// Mengirim error non-fatal buatan untuk menguji pelaporan Firebase Crashlytics
  Future<void> recordNonFatalTestError({
    String source = 'beta_test_menu',
  }) async {
    try {
      final testError = StateError(
        'Uji Telemetry Non-Fatal: Verifikasi koneksi Crashlytics dari $source',
      );
      await FirebaseCrashlytics.instance.recordError(
        testError,
        StackTrace.current,
        reason: 'Pengujian Telemetry Non-Fatal Terkontrol (Jobsheet 14)',
        fatal: false,
      );
      developer.log(
        'Telemetry: Error non-fatal berhasil dikirim ke Crashlytics dari $source',
        name: 'TelemetryService',
      );
    } catch (e) {
      developer.log(
        'Telemetry Notice: Gagal mengirim error non-fatal ke Crashlytics: $e',
        name: 'TelemetryService',
      );
    }
  }

  /// Memicu crash terkontrol untuk verifikasi error fatal Crashlytics pada perangkat uji
  void triggerFatalTestCrash() {
    try {
      developer.log(
        'Telemetry: Memicu uji crash fatal Crashlytics...',
        name: 'TelemetryService',
      );
      FirebaseCrashlytics.instance.crash();
    } catch (e) {
      developer.log(
        'Telemetry Notice: Crashlytics crash trigger notice: $e',
        name: 'TelemetryService',
      );
      // Fallback untuk memicu unhandled exception yang ditangkap oleh PlatformDispatcher
      throw StateError(
        'Simulasi Fatal Crash Terkontrol untuk Pengujian Beta (Jobsheet 14)',
      );
    }
  }
}
