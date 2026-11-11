import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../settings_controller.dart';

class SettingsThemeDialog extends StatelessWidget {
  const SettingsThemeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final options = [
      (ThemeMode.system, 'System Default', Icons.brightness_auto_rounded, 'Matches device system settings'),
      (ThemeMode.light, 'Light Mode', Icons.light_mode_rounded, 'Clean orange & warm cream theme'),
      (ThemeMode.dark, 'Dark Mode', Icons.dark_mode_rounded, 'Battery saving night aesthetic'),
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
                  const Icon(Icons.palette_rounded, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Text(
                    'App Appearance',
                    style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            Obx(
              () => Column(
                children: options.map((opt) {
                  final isSelected = controller.currentThemeMode.value == opt.$1;
                  return ListTile(
                    leading: Icon(
                      opt.$3,
                      color: isSelected ? AppColors.primary : Colors.grey,
                      size: 22,
                    ),
                    title: Text(
                      opt.$2,
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primary
                            : (isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight),
                      ),
                    ),
                    subtitle: Text(
                      opt.$4,
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                        : const Icon(Icons.radio_button_unchecked_rounded, color: Colors.grey),
                    onTap: () {
                      controller.setThemeMode(opt.$1);
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

