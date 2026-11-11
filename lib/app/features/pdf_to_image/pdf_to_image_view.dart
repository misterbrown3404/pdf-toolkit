import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import 'pdf_to_image_controller.dart';
import 'widgets/pdf_to_image_file_card.dart';
import 'widgets/pdf_to_image_header_banner.dart';
import 'widgets/pdf_to_image_settings_card.dart';
import 'widgets/pdf_to_image_success_view.dart';

class PdfToImageView extends GetView<PdfToImageController> {
  const PdfToImageView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      // 1. Success State View
      if (controller.isSuccess.value && controller.selectedPdf.value != null && controller.generatedImages.isNotEmpty) {
        return PdfToImageSuccessView(
          sourceDoc: controller.selectedPdf.value!,
          generatedImagePaths: controller.generatedImages,
          onConvertAnother: controller.resetForAnother,
          onViewAllImages: controller.viewAllImages,
          onShareImages: controller.shareImages,
        );
      }

      // 2. Configuration View
      return Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        body: SafeArea(
          child: Column(
            children: [
              // Scrollable Options Area
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with Title & 3D Illustration
                      const PdfToImageHeaderBanner(),

                      // File Picker / Selected Document Card
                      PdfToImageFileCard(
                        selectedPdf: controller.selectedPdf.value,
                        onPickFile: controller.pickPdf,
                        onClearFile: controller.clearPdf,
                        recentFiles: controller.recentFiles,
                        onSelectRecent: controller.selectRecent,
                      ),

                      // Settings Card (Format, Quality, Page Range)
                      PdfToImageSettingsCard(
                        format: controller.format.value,
                        onFormatChanged: controller.setFormat,
                        quality: controller.quality.value,
                        onQualityChanged: controller.setQuality,
                        isCustomRange: controller.isCustomRange.value,
                        onRangeTypeChanged: controller.setRangeType,
                        totalPages: controller.selectedPdf.value?.pageCount ?? 1,
                        customRange: controller.customRange.value,
                        onCustomRangeChanged: controller.setCustomRange,
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Bottom Action Button
              Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: isDark ? AppColors.borderDark : AppColors.borderLightMuted,
                    ),
                  ),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    elevation: 3,
                    shadowColor: AppColors.primary.withValues(alpha: 0.4),
                  ),
                  onPressed: controller.isProcessing.value ? null : controller.exportImages,
                  child: controller.isProcessing.value
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.image_outlined, size: 22),
                            SizedBox(width: 8),
                            Text(
                              'Convert to Images',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
