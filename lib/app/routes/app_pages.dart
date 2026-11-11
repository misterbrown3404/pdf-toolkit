import 'package:get/get.dart';
import '../features/compress_pdf/compress_pdf_binding.dart';
import '../features/compress_pdf/compress_pdf_view.dart';
import '../features/files/files_binding.dart';
import '../features/files/files_view.dart';
import '../features/home/home_binding.dart';
import '../features/home/home_view.dart';
import '../features/image_to_pdf/image_to_pdf_binding.dart';
import '../features/image_to_pdf/image_to_pdf_view.dart';
import '../features/merge_pdf/merge_pdf_binding.dart';
import '../features/merge_pdf/merge_pdf_view.dart';
import '../features/pdf_to_image/pdf_to_image_binding.dart';
import '../features/pdf_to_image/pdf_to_image_view.dart';
import '../features/pdf_viewer/pdf_viewer_binding.dart';
import '../features/pdf_viewer/pdf_viewer_view.dart';
import '../features/premium/premium_binding.dart';
import '../features/premium/premium_view.dart';
import '../features/protect_pdf/protect_pdf_binding.dart';
import '../features/protect_pdf/protect_pdf_view.dart';
import '../features/scanner/scanner_binding.dart';
import '../features/scanner/scanner_view.dart';
import '../features/settings/settings_binding.dart';
import '../features/settings/settings_view.dart';
import '../features/splash/splash_binding.dart';
import '../features/splash/splash_view.dart';
import '../features/split_pdf/split_pdf_binding.dart';
import '../features/split_pdf/split_pdf_view.dart';
import '../features/tools/tools_binding.dart';
import '../features/tools/tools_view.dart';
import '../features/watermark/watermark_binding.dart';
import '../features/watermark/watermark_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.files,
      page: () => const FilesView(),
      binding: FilesBinding(),
    ),
    GetPage(
      name: AppRoutes.tools,
      page: () => const ToolsView(),
      binding: ToolsBinding(),
    ),
    GetPage(
      name: AppRoutes.pdfViewer,
      page: () => const PdfViewerView(),
      binding: PdfViewerBinding(),
    ),
    GetPage(
      name: AppRoutes.mergePdf,
      page: () => const MergePdfView(),
      binding: MergePdfBinding(),
    ),
    GetPage(
      name: AppRoutes.splitPdf,
      page: () => const SplitPdfView(),
      binding: SplitPdfBinding(),
    ),
    GetPage(
      name: AppRoutes.imageToPdf,
      page: () => const ImageToPdfView(),
      binding: ImageToPdfBinding(),
    ),
    GetPage(
      name: AppRoutes.pdfToImage,
      page: () => const PdfToImageView(),
      binding: PdfToImageBinding(),
    ),
    GetPage(
      name: AppRoutes.compressPdf,
      page: () => const CompressPdfView(),
      binding: CompressPdfBinding(),
    ),
    GetPage(
      name: AppRoutes.watermark,
      page: () => const WatermarkView(),
      binding: WatermarkBinding(),
    ),
    GetPage(
      name: AppRoutes.protectPdf,
      page: () => const ProtectPdfView(),
      binding: ProtectPdfBinding(),
    ),
    GetPage(
      name: AppRoutes.scanner,
      page: () => const ScannerView(),
      binding: ScannerBinding(),
    ),
    GetPage(
      name: AppRoutes.premium,
      page: () => const PremiumView(),
      binding: PremiumBinding(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
  ];
}
