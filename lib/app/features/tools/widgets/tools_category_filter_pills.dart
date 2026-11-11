import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../models/tools_filter_category_enum.dart';
import '../tools_controller.dart';

class ToolsCategoryFilterPills extends StatelessWidget {
  const ToolsCategoryFilterPills({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ToolsController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final categories = [
      (ToolsFilterCategory.all, 'All Tools', Icons.apps_rounded),
      (ToolsFilterCategory.organize, 'Organize', Icons.dashboard_customize_rounded),
      (ToolsFilterCategory.convert, 'Convert', Icons.transform_rounded),
      (ToolsFilterCategory.security, 'Security', Icons.shield_rounded),
      (ToolsFilterCategory.optimize, 'Optimize', Icons.speed_rounded),
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
                        color: isSelected ? AppColors.primary : Colors.grey,
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

