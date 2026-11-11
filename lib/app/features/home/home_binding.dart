import 'package:get/get.dart';
import '../files/files_controller.dart';
import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<FilesController>(() => FilesController());
  }
}

