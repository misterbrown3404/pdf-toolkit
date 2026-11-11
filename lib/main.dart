import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/bindings/initial_binding.dart';
import 'app/core/services/ads_service.dart';
import 'app/core/services/billing_service.dart';
import 'app/core/services/storage_service.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Async core services
  final storageService = await StorageService().init();
  Get.put<StorageService>(storageService, permanent: true);

  final adsService = await AdsService().init();
  Get.put<AdsService>(adsService, permanent: true);

  final billingService = await BillingService().init();
  Get.put<BillingService>(billingService, permanent: true);

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
