import 'package:get/get.dart';
import 'split_pdf_controller.dart';

class SplitPdfBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplitPdfController>(() => SplitPdfController());
  }
}

