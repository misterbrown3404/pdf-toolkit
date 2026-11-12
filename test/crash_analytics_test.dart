import 'package:flutter_test/flutter_test.dart';
import 'package:pdf_toolkit/app/core/services/crash_analytics_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CrashAnalyticsService Unit Tests', () {
    test('CrashAnalyticsService starts uninitialized', () {
      final service = CrashAnalyticsService();
      expect(service.isInitialized, isFalse);
    });

    test('CrashAnalyticsService methods do not throw when uninitialized', () async {
      final service = CrashAnalyticsService();

      expect(
        () async => await service.recordError(Exception('test'), null),
        returnsNormally,
      );

      expect(
        () async => await service.log('test log'),
        returnsNormally,
      );

      expect(
        () async => await service.setCustomKey('test_key', 'test_value'),
        returnsNormally,
      );

      expect(
        () async => await service.setUserId('user_123'),
        returnsNormally,
      );
    });
  });
}

