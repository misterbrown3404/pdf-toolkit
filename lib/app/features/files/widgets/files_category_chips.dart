import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../files_controller.dart';
import '../models/file_category_enum.dart';

class FilesCategoryChips extends StatelessWidget {
  const FilesCategoryChips({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FilesController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final categories = [
      (FileCategory.all, 'All Files', Icons.layers_rounded, AppColors.primary),
      (FileCategory.pdf, 'PDFs', Icons.picture_as_pdf_rounded, AppColors.pdfRed),
      (FileCategory.scanned, 'Scanned', Icons.document_scanner_rounded, AppColors.folderYellow),
      (FileCategory.compressed, 'Compressed', Icons.compress_rounded, Colors.purple),
      (FileCategory.protected, 'Protected', Icons.lock_rounded, Colors.teal),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(
        () => Row(
          children: categories.map((cat) {
            final isSelected = controller.selectedCategory.value == cat.$1;
            final count = controller.countForCategory(cat.$1);

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () => controller.setCategory(cat.$1),
                borderRadius: BorderRadius.circular(14),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDark ? const Color(0xFF332014) : const Color(0xFFFFEDD5))
                        : (isDark ? AppColors.cardDark : AppColors.cardLight),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : (isDark ? AppColors.borderDark : AppColors.borderLightMuted),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        cat.$3,
                        size: 16,
                        color: isSelected ? AppColors.primary : cat.$4,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        cat.$2,
                        style: AppTypography.titleSmall.copyWith(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                          color: isSelected
                              ? AppColors.primary
                              : (isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.15)
                              : (isDark
                                  ? Colors.white.withValues(alpha: 0.08)
                                  : Colors.black.withValues(alpha: 0.05)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$count',
                          style: AppTypography.labelSmall.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? AppColors.primary
                                : (isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textMutedLight),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
