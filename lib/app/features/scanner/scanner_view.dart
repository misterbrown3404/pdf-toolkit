import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_colors.dart';
import 'scanner_controller.dart';
import 'widgets/scanner_bottom_controls.dart';
import 'widgets/scanner_camera_viewfinder.dart';
import 'widgets/scanner_header_banner.dart';
import 'widgets/scanner_mode_selector.dart';
import 'widgets/scanner_review_view.dart';
import 'widgets/scanner_success_view.dart';

class ScannerView extends GetView<ScannerController> {
  const ScannerView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      body: SafeArea(
        child: Obx(() {
          if (controller.isSuccess.value) {
            return ScannerSuccessView(controller: controller);
          }

          if (controller.isReviewing.value) {
            return ScannerReviewView(controller: controller);
          }

          return Column(
            children: [
              // Header Banner with Back & 3D Illustration
              ScannerHeaderBanner(onBack: () => Get.back()),

              // Camera Viewfinder Box with Laser Scan Beam & Orange Corners
              Expanded(child: ScannerCameraViewfinder(controller: controller)),

              // Mode Selector (Document, Batch, ID Card, Whiteboard)
              ScannerModeSelector(controller: controller),

              // Bottom Controls (Gallery, Large Shutter, Flash)
              ScannerBottomControls(controller: controller),
            ],
          );
        }),
      ),
    );
  }
}
