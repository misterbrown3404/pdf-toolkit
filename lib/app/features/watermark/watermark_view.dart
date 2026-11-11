import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import 'watermark_controller.dart';
import 'widgets/watermark_bottom_bar.dart';
import 'widgets/watermark_file_card.dart';
import 'widgets/watermark_header_banner.dart';
import 'widgets/watermark_preview_card.dart';
import 'widgets/watermark_settings_card.dart';
import 'widgets/watermark_success_view.dart';

class WatermarkView extends GetView<WatermarkController> {
  const WatermarkView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Obx(() {
          if (controller.isSuccess.value) {
            return WatermarkSuccessView(controller: controller);
          }

          final hasPdf = controller.selectedPdf.value != null;

          return Column(
            children: [
              // Header Banner with 3D Illustration & Back Button
              WatermarkHeaderBanner(onBack: () => Get.back()),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    children: [
                      // Document Selection Card
                      WatermarkFileCard(
                        selectedPdf: controller.selectedPdf.value,
                        onPickPdf: controller.pickPdf,
                        onClearPdf: controller.clearPdf,
                        recentFiles: controller.recentFiles,
                        onSelectRecent: controller.selectRecentPdf,
                      ),

                      if (hasPdf) ...[
                        // Live Interactive Document Canvas Preview
                        WatermarkPreviewCard(config: controller.config.value),

                        // Settings: Text, Colors, Angles, Opacity, Position
                        WatermarkSettingsCard(
                          config: controller.config.value,
                          onConfigChanged: controller.updateConfig,
                          onPickLogo: controller.pickLogoImage,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Bottom Sticky Action Button
              WatermarkBottomBar(
                hasSelectedPdf: hasPdf,
                isProcessing: controller.isProcessing.value,
                onApply: controller.applyWatermark,
              ),
            ],
          );
        }),
      ),
    );
  }
}
