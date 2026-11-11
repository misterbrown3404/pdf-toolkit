import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import 'compress_pdf_controller.dart';
import 'widgets/compress_estimate_card.dart';
import 'widgets/compress_file_picker_card.dart';
import 'widgets/compress_header_banner.dart';
import 'widgets/compress_level_selector.dart';
import 'widgets/compress_more_options_sheet.dart';
import 'widgets/compress_success_view.dart';

class CompressPdfView extends GetView<CompressPdfController> {
  const CompressPdfView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      // 1. Success State View
      if (controller.isSuccess.value && controller.compressedDoc.value != null && controller.selectedPdf.value != null) {
        return CompressSuccessView(
          originalDoc: controller.selectedPdf.value!,
          compressedDoc: controller.compressedDoc.value!,
          onCompressAnother: controller.resetForAnother,
          onOpenDoc: controller.openCompressedFile,
          onShareDoc: controller.shareCompressedFile,
          onRenameDoc: controller.renameCompressedFile,
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
                      const CompressHeaderBanner(),

                      // File Picker / Selected Document Card
                      CompressFilePickerCard(
                        selectedPdf: controller.selectedPdf.value,
                        onPickFile: controller.pickPdf,
                        onClearFile: controller.clearPdf,
                        recentFiles: controller.recentFiles,
                        onSelectRecent: controller.selectRecent,
                      ),

                      // Compression Level Selector (Low, Balanced, High)
                      CompressLevelSelector(
                        selectedLevel: controller.compressionLevel.value,
                        onLevelSelected: controller.setLevel,
                      ),

                      // Real-time Estimated Result Card
                      if (controller.selectedPdf.value != null)
                        CompressEstimateCard(
                          originalSize: controller.selectedPdf.value!.formattedSize,
                          estimatedSize: controller.estimatedCompressedSizeFormatted,
                          percentReduction: controller.estimatedReductionPercent,
                        ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // Bottom Action Buttons
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Primary Gradient Compress Button
                    ElevatedButton(
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
                      onPressed: controller.isProcessing.value ? null : controller.compress,
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
                                Icon(Icons.compress_rounded, size: 22),
                                SizedBox(width: 8),
                                Text(
                                  'Compress PDF',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 10),

                    // Secondary Outlined "More Options" Button
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isDark ? Colors.white : const Color(0xFF0F172A),
                        side: BorderSide(
                          color: isDark ? AppColors.borderDark : const Color(0xFFFED7AA),
                          width: 1.4,
                        ),
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => CompressMoreOptionsSheet(
                            removeMetadata: controller.removeMetadata.value,
                            onToggleMetadata: (v) => controller.removeMetadata.value = v,
                            downsampleImages: controller.downsampleImages.value,
                            onToggleDownsample: (v) => controller.downsampleImages.value = v,
                            imageQuality: controller.imageQuality.value,
                            onQualityChanged: (v) => controller.imageQuality.value = v,
                          ),
                        );
                      },
                      icon: const Icon(Icons.tune_rounded, size: 18, color: AppColors.primary),
                      label: const Text(
                        'More Options',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
