import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'merge_pdf_controller.dart';
import 'widgets/merge_bottom_action_bar.dart';
import 'widgets/merge_file_card.dart';
import 'widgets/merge_hero_card.dart';
import 'widgets/merge_stepper_header.dart';

class MergePdfView extends GetView<MergePdfController> {
  const MergePdfView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
              'Merge PDF',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Combine multiple PDFs into one document',
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
      body: Obx(() {
        final files = controller.selectedFiles;

        return Column(
          children: [
            // 3-Step Progress Stepper
            MergeStepperHeader(
              fileCount: files.length,
              isMerging: controller.isProcessing.value,
            ),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),

            // Main Content Area
            Expanded(
              child: files.isEmpty
                  ? _buildEmptyState(context, isDark)
                  : CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      slivers: [
                        // Hero Header with 3D Document Stack & Title
                        const SliverToBoxAdapter(
                          child: MergeHeroCard(),
                        ),

                        const SliverToBoxAdapter(
                          child: SizedBox(height: 8),
                        ),

                        // Reorderable Document Cards List
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverReorderableList(
                            itemCount: files.length,
                            onReorderItem: controller.reorderFiles,
                            itemBuilder: (context, index) {
                              final item = files[index];
                              return ReorderableDelayedDragStartListener(
                                key: ValueKey(item.id + index.toString()),
                                index: index,
                                child: MergeFileCard(
                                  file: item,
                                  index: index,
                                  onRemove: () => controller.removeFile(index),
                                ),
                              );
                            },
                          ),
                        ),

                        // Add More Files Button
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 46),
                                foregroundColor: AppColors.primary,
                                side: const BorderSide(
                                  color: Color(0xFFFFEDD5),
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: controller.pickPdfs,
                              icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
                              label: const Text(
                                'Add More Files',
                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        );
      }),
      bottomNavigationBar: Obx(
        () => MergeBottomActionBar(
          fileCount: controller.selectedFiles.length,
          isProcessing: controller.isProcessing.value,
          onMerge: controller.mergePdfs,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEDD5),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.layers_rounded,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'No PDFs Selected',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select two or more PDF documents from your storage to combine them into one unified file.',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(180, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onPressed: controller.pickPdfs,
              icon: const Icon(Icons.add_rounded),
              label: const Text(
                'Select PDF Files',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Merging PDFs', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text(
          '1. Add two or more PDF files.\n'
          '2. Hold and drag any file by its handle to rearrange page order.\n'
          '3. Tap "Merge Files" to generate your unified document.',
          style: TextStyle(height: 1.5),
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
