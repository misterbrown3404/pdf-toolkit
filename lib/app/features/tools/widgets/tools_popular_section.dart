import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../models/tools_filter_category_enum.dart';
import '../tools_controller.dart';

class ToolsPopularSection extends StatelessWidget {
  const ToolsPopularSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ToolsController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final popular = [
      (
        'Compress\nPDF',
        Icons.compress_rounded,
        AppColors.primary,
        AppRoutes.compressPdf,
        true, // highlighted
      ),
      (
        'Merge\nPDF',
        Icons.layers_rounded,
        const Color(0xFFEA580C),
        AppRoutes.mergePdf,
        false,
      ),
      (
        'Split\nPDF',
        Icons.content_cut_rounded,
        const Color(0xFFDC2626),
        AppRoutes.splitPdf,
        false,
      ),
      (
        'PDF to\nImage',
        Icons.image_rounded,
        const Color(0xFFD97706),
        AppRoutes.pdfToImage,
        false,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Popular Tools',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            InkWell(
              onTap: () {
                controller.setCategory(ToolsFilterCategory.all);
                controller.clearSearch();
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Row(
                  children: [
                    Text(
                      'View All',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 4 Horizontal Popular Cards
        Row(
          children: popular.map((item) {
            final isHighlighted = item.$5;
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 98,
                decoration: BoxDecoration(
                  color: isHighlighted
                      ? (isDark ? const Color(0xFF332014) : const Color(0xFFFFF7ED))
                      : (isDark ? AppColors.cardDark : AppColors.cardLight),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isHighlighted
                        ? AppColors.primary
                        : (isDark ? AppColors.borderDark : AppColors.borderLightMuted),
                    width: isHighlighted ? 1.5 : 1,
                  ),
                  boxShadow: isDark
                      ? null
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => Get.toNamed(item.$4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            item.$2,
                            size: 26,
                            color: item.$3,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.$1,
                            textAlign: TextAlign.center,
                            style: AppTypography.labelSmall.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              height: 1.15,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

