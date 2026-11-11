import 'package:get/get.dart';
import 'protect_pdf_controller.dart';

class ProtectPdfBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProtectPdfController>(() => ProtectPdfController());
  }
}

