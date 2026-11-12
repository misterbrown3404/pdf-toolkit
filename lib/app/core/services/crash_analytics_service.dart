import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class CrashAnalyticsService {
  bool _initialized = false;

  bool get isInitialized => _initialized;

  Future<CrashAnalyticsService> init() async {
    try {
      await Firebase.initializeApp();

      // Pass all uncaught fatal errors from the Flutter framework to Crashlytics
      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };

      // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      // In debug mode, crash collection can stay disabled or enabled for testing
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);

      _initialized = true;
      debugPrint('[CrashAnalyticsService] Firebase Crashlytics initialized successfully');
    } catch (e, stack) {
      debugPrint('[CrashAnalyticsService] Failed to initialize Firebase Crashlytics: $e');
      debugPrint(stack.toString());
    }
    return this;
  }

  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    String? reason,
    Iterable<Object> information = const [],
    bool fatal = false,
  }) async {
    if (!_initialized) return;
    try {
      await FirebaseCrashlytics.instance.recordError(
        exception,
        stack,
        reason: reason,
        information: information,
        fatal: fatal,
      );
    } catch (e) {
      debugPrint('[CrashAnalyticsService] recordError failed: $e');
    }
  }

  Future<void> log(String message) async {
    if (!_initialized) return;
    try {
      await FirebaseCrashlytics.instance.log(message);
    } catch (e) {
      debugPrint('[CrashAnalyticsService] log failed: $e');
    }
  }

  Future<void> setCustomKey(String key, Object value) async {
    if (!_initialized) return;
    try {
      await FirebaseCrashlytics.instance.setCustomKey(key, value);
    } catch (e) {
      debugPrint('[CrashAnalyticsService] setCustomKey failed: $e');
    }
  }

  Future<void> setUserId(String identifier) async {
    if (!_initialized) return;
    try {
      await FirebaseCrashlytics.instance.setUserIdentifier(identifier);
    } catch (e) {
      debugPrint('[CrashAnalyticsService] setUserId failed: $e');
    }
  }
}
