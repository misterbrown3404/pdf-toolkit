import 'package:get/get.dart';
import 'image_to_pdf_controller.dart';

class ImageToPdfBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImageToPdfController>(() => ImageToPdfController());
  }
}

