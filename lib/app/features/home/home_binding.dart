import 'package:get/get.dart';
import '../files/files_controller.dart';
import '../settings/settings_controller.dart';
import '../tools/tools_controller.dart';
import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<FilesController>(() => FilesController());
    Get.lazyPut<ToolsController>(() => ToolsController());
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}

