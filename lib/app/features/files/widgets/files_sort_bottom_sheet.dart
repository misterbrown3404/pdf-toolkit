import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../files_controller.dart';
import '../models/file_sort_enum.dart';

class FilesSortBottomSheet extends StatelessWidget {
  const FilesSortBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FilesController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final sortOptions = [
      (FileSort.dateDesc, 'Date (Newest first)', Icons.calendar_today_rounded),
      (FileSort.dateAsc, 'Date (Oldest first)', Icons.history_rounded),
      (FileSort.nameAsc, 'Name (A to Z)', Icons.sort_by_alpha_rounded),
      (FileSort.nameDesc, 'Name (Z to A)', Icons.sort_by_alpha_rounded),
      (FileSort.sizeDesc, 'Size (Largest first)', Icons.arrow_downward_rounded),
      (FileSort.sizeAsc, 'Size (Smallest first)', Icons.arrow_upward_rounded),
    ];

    return Material(
      color: isDark ? AppColors.surfaceDark : Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.borderDark : AppColors.borderLightMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Icon(Icons.swap_vert_rounded, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Text(
                    'Sort Files By',
                    style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            Obx(
              () => Column(
                children: sortOptions.map((opt) {
                  final isSelected = controller.currentSort.value == opt.$1;
                  return ListTile(
                    leading: Icon(
                      opt.$3,
                      color: isSelected ? AppColors.primary : Colors.grey,
                      size: 20,
                    ),
                    title: Text(
                      opt.$2,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primary
                            : (isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight),
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                        : const Icon(Icons.radio_button_unchecked_rounded, color: Colors.grey),
                    onTap: () {
                      controller.setSort(opt.$1);
                      Navigator.of(context).pop();
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
