import 'package:get/get.dart';
import 'watermark_controller.dart';

class WatermarkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WatermarkController>(() => WatermarkController());
  }
}

