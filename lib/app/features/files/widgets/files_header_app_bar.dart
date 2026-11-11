import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../files_controller.dart';

class FilesHeaderAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FilesHeaderAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FilesController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      toolbarHeight: 72,
      titleSpacing: 16,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Files',
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'All your files in one place',
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
            ),
          ),
        ],
      ),
      actions: [
        // Search toggle icon
        Obx(() => Container(
              width: 38,
              height: 38,
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                color: controller.isSearchVisible.value
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : (isDark ? AppColors.surfaceDark : Colors.white),
                shape: BoxShape.circle,
                border: Border.all(
                  color: controller.isSearchVisible.value
                      ? AppColors.primary
                      : (isDark ? AppColors.borderDark : AppColors.borderLightMuted),
                ),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.search_rounded,
                  size: 19,
                  color: controller.isSearchVisible.value
                      ? AppColors.primary
                      : (isDark ? Colors.white : AppColors.textPrimaryLight),
                ),
                onPressed: controller.toggleSearch,
              ),
            )),
        // Sort icon
        Container(
          width: 38,
          height: 38,
          margin: const EdgeInsets.only(right: 6),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLightMuted,
            ),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.swap_vert_rounded,
              size: 19,
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
            ),
            onPressed: () => controller.showSortSheet(context),
          ),
        ),
        // Grid / List toggle icon
        Obx(() => Container(
              width: 38,
              height: 38,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLightMuted,
                ),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  controller.isGridView.value
                      ? Icons.format_list_bulleted_rounded
                      : Icons.grid_view_rounded,
                  size: 19,
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                ),
                onPressed: controller.toggleViewMode,
              ),
            )),
      ],
    );
  }
}
