import 'package:flutter_test/flutter_test.dart';
import 'package:offline_notes/core/telemetry_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TelemetryService Test (Jobsheet 14)', () {
    test('instance adalah singleton', () {
      final instance1 = TelemetryService.instance;
      final instance2 = TelemetryService.instance;
      expect(identical(instance1, instance2), isTrue);
    });

    test(
      'logBetaFeedback menangani eksekusi tanpa unhandled exception',
      () async {
        await expectLater(
          TelemetryService.instance.logBetaFeedback(
            screenName: 'unit_test_screen',
          ),
          completes,
        );
      },
    );

    test(
      'recordNonFatalTestError menangani eksekusi tanpa unhandled exception',
      () async {
        await expectLater(
          TelemetryService.instance.recordNonFatalTestError(
            source: 'unit_test_runner',
          ),
          completes,
        );
      },
    );
  });
}
