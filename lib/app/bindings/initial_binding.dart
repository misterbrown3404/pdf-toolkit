import 'package:get/get.dart';
import '../core/services/file_service.dart';
import '../core/services/pdf_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<FileService>()) {
      Get.put<FileService>(FileService(), permanent: true);
    }
    if (!Get.isRegistered<PdfService>()) {
      Get.put<PdfService>(PdfService(), permanent: true);
    }
  }
}
