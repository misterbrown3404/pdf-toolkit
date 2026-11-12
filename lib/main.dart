import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/bindings/initial_binding.dart';
import 'app/core/services/ads_service.dart';
import 'app/core/services/billing_service.dart';
import 'app/core/services/crash_analytics_service.dart';
import 'app/core/services/storage_service.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Crash Analytics first to capture startup errors
  final crashService = await CrashAnalyticsService().init();
  Get.put<CrashAnalyticsService>(crashService, permanent: true);

  // Async core services
  final storageService = await StorageService().init();
  Get.put<StorageService>(storageService, permanent: true);

  final adsService = AdsService();
  Get.put<AdsService>(adsService, permanent: true);
  unawaited(adsService.init());

  final billingService = BillingService();
  Get.put<BillingService>(billingService, permanent: true);
  unawaited(billingService.init());

  runApp(const PdfToolkitApp());
}

class PdfToolkitApp extends StatelessWidget {
  const PdfToolkitApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storageService = Get.find<StorageService>();

    return GetMaterialApp(
      title: 'PDF Toolkit',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: storageService.getThemeMode(),
      initialBinding: InitialBinding(),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
