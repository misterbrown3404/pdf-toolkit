import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'split_pdf_controller.dart';
import 'widgets/split_file_header.dart';
import 'widgets/split_mode_selector.dart';
import 'widgets/split_range_input.dart';
import 'widgets/split_success_view.dart';
import 'widgets/split_summary_card.dart';

class SplitPdfView extends GetView<SplitPdfController> {
  const SplitPdfView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      // If split completed, display the polished Split Success screen
      if (controller.isSuccess.value) {
        return SplitSuccessView(
          createdFiles: controller.createdFiles,
          onSplitAnother: controller.resetForAnother,
          onOpenFile: controller.openCreatedDocument,
          onShareFile: controller.shareCreatedDocument,
        );
      }

      // Configuration Screen
      return Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
            ),
            onPressed: () => Get.back(),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Split PDF',
                style: AppTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Extract pages or divide document into parts',
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 12,
                  color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          actions: [
            Container(
              width: 38,
              height: 38,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
                ),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.help_outline_rounded,
                  size: 20,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                ),
                onPressed: () => _showHelpDialog(context),
                tooltip: 'Help',
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Selected Document Header Card
                      SplitFileHeader(
                        selectedPdf: controller.selectedPdf.value,
                        totalPages: controller.totalPages.value,
                        onPickFile: controller.pickPdf,
                        onSelectRecent: controller.selectDocument,
                        recentFiles: controller.recentFiles,
                      ),

                      if (controller.selectedPdf.value != null) ...[
                        const SizedBox(height: 4),

                        // Split Method Selection (Range / Extract All / Fixed Interval)
                        SplitModeSelector(
                          selectedIndex: controller.splitMethod.value,
                          onSelectMode: controller.setSplitMethod,
                        ),

                        // Range / Interval Settings Input
                        SplitRangeInput(
                          splitMethod: controller.splitMethod.value,
                          totalPages: controller.totalPages.value,
                          currentInput: controller.pageRangeInput.value,
                          onRangeChanged: controller.setPageRange,
                          intervalPages: controller.intervalPages.value,
                          onIntervalChanged: controller.setInterval,
                        ),

                        // Dynamic Summary / Estimated Output Card
                        SplitSummaryCard(
                          estimatedFiles: controller.estimatedFileCount,
                          summaryText: controller.summaryDescription,
                        ),

                        const SizedBox(height: 20),
                      ],
                    ],
                  ),
                ),
              ),

              // Fixed Bottom Action Bar
              if (controller.selectedPdf.value != null)
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    border: Border(
                      top: BorderSide(
                        color: isDark ? AppColors.borderDark : const Color(0xFFF1F5F9),
                        width: 1,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 3,
                        shadowColor: AppColors.primary.withValues(alpha: 0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                      ),
                      onPressed: controller.isProcessing.value ? null : controller.splitPdf,
                      child: controller.isProcessing.value
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.content_cut_rounded, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Split PDF',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward_rounded, size: 18),
                              ],
                            ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  void _showHelpDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Split PDF Help', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text(
          '• Page Range: Specify custom ranges like "1-5, 6-10" to divide a document into specific sections.\n\n'
          '• Extract All: Extracts each page as an individual PDF.\n\n'
          '• Fixed Interval: Splits your document automatically into equal parts (e.g. every 2 pages).',
          style: TextStyle(height: 1.45),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Got it', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
