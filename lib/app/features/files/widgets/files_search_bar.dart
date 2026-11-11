import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../files_controller.dart';

class FilesSearchBar extends StatelessWidget {
  const FilesSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FilesController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLightMuted,
        ),
      ),
      child: TextField(
        controller: controller.searchInputController,
        onChanged: controller.setSearchQuery,
        style: AppTypography.bodyMedium.copyWith(
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        ),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          hintText: 'Search files...',
          hintStyle: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            size: 20,
            color: Colors.grey,
          ),
          suffixIcon: Obx(() {
            if (controller.searchQuery.value.isNotEmpty) {
              return IconButton(
                icon: const Icon(Icons.close_rounded, size: 18),
                onPressed: () {
                  controller.searchInputController.clear();
                  controller.setSearchQuery('');
                },
              );
            }
            return const SizedBox.shrink();
          }),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
