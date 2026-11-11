import 'package:get/get.dart';
import 'merge_pdf_controller.dart';

class MergePdfBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MergePdfController>(() => MergePdfController());
  }
}

