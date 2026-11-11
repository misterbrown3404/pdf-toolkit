import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'settings_controller.dart';
import 'widgets/settings_header_banner.dart';
import 'widgets/settings_plan_card.dart';
import 'widgets/settings_pro_banner.dart';
import 'widgets/settings_section_card.dart';
import 'widgets/settings_tile.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            // Top Header Banner
            const SettingsHeaderBanner(),

            // Plan Card & Pro Upgrade Banner
            const SettingsPlanCard(),
            const SettingsProBanner(),
            const SizedBox(height: 20),

            // Section 1: App Settings
            SettingsSectionCard(
              title: 'App Settings',
              children: [
                Obx(
                  () => SettingsTile(
                    icon: Icons.palette_outlined,
                    iconColor: AppColors.primary,
                    title: 'Appearance',
                    subtitle: 'Light, Dark, or System',
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          controller.themeModeName,
                          style: AppTypography.labelMedium.copyWith(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_right_rounded, size: 20, color: Colors.grey),
                      ],
                    ),
                    onTap: () => controller.showThemeDialog(context),
                  ),
                ),
                Obx(
                  () => SettingsTile(
                    icon: Icons.notifications_none_rounded,
                    iconColor: const Color(0xFFF59E0B),
                    title: 'Notifications',
                    subtitle: 'Get task and file alerts',
                    trailing: Switch.adaptive(
                      value: controller.notificationsEnabled.value,
                      activeTrackColor: AppColors.primary,
                      onChanged: controller.toggleNotifications,
                    ),
                  ),
                ),
                SettingsTile(
                  icon: Icons.translate_rounded,
                  iconColor: const Color(0xFF0284C7),
                  title: 'Language',
                  subtitle: 'English (United States)',
                  trailing: const Icon(Icons.chevron_right_rounded, size: 20, color: Colors.grey),
                  showDivider: false,
                  onTap: () {
                    Get.snackbar(
                      'Language',
                      'English (US) is currently active.',
                      snackPosition: SnackPosition.BOTTOM,
                      margin: const EdgeInsets.all(16),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Section 2: PDF Options
            SettingsSectionCard(
              title: 'PDF Options',
              children: [
                Obx(
                  () => SettingsTile(
                    icon: Icons.compress_rounded,
                    iconColor: const Color(0xFF10B981),
                    title: 'Default Compression',
                    subtitle: 'Use compression when creating PDFs',
                    trailing: Switch.adaptive(
                      value: controller.defaultCompression.value,
                      activeTrackColor: AppColors.primary,
                      onChanged: controller.toggleDefaultCompression,
                    ),
                  ),
                ),
                Obx(
                  () => SettingsTile(
                    icon: Icons.lock_outline_rounded,
                    iconColor: const Color(0xFFEF4444),
                    title: 'Password Reminder',
                    subtitle: 'Prompt to secure sensitive files',
                    trailing: Switch.adaptive(
                      value: controller.passwordReminder.value,
                      activeTrackColor: AppColors.primary,
                      onChanged: controller.togglePasswordReminder,
                    ),
                  ),
                ),
                Obx(
                  () => SettingsTile(
                    icon: Icons.branding_watermark_outlined,
                    iconColor: const Color(0xFF8B5CF6),
                    title: 'Default Watermark',
                    subtitle: 'Stamp watermark automatically',
                    trailing: Switch.adaptive(
                      value: controller.defaultWatermark.value,
                      activeTrackColor: AppColors.primary,
                      onChanged: controller.toggleDefaultWatermark,
                    ),
                  ),
                ),
                Obx(
                  () => SettingsTile(
                    icon: Icons.description_outlined,
                    iconColor: const Color(0xFFEA580C),
                    title: 'Default Page Format',
                    subtitle: 'Standard page dimensions',
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          controller.defaultPageFormat.value,
                          style: AppTypography.labelMedium.copyWith(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_right_rounded, size: 20, color: Colors.grey),
                      ],
                    ),
                    showDivider: false,
                    onTap: () {
                      final next = controller.defaultPageFormat.value == 'A4' ? 'US Letter' : 'A4';
                      controller.setPageFormat(next);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Section 3: Storage & Files
            SettingsSectionCard(
              title: 'Storage & Files',
              children: [
                Obx(
                  () => SettingsTile(
                    icon: Icons.storage_rounded,
                    iconColor: AppColors.primary,
                    title: 'App Documents Storage',
                    subtitle: 'Saved PDFs (${controller.formattedAppStorage})',
                    trailing: const Icon(Icons.chevron_right_rounded, size: 20, color: Colors.grey),
                    onTap: () {
                      // Navigate to Files tab
                      final homeController = Get.find<dynamic>();
                      if (homeController != null && homeController.changeTab != null) {
                        homeController.changeTab(2);
                      }
                    },
                  ),
                ),
                Obx(
                  () => SettingsTile(
                    icon: Icons.cleaning_services_rounded,
                    iconColor: const Color(0xFFDC2626),
                    title: 'Clear Temporary Cache',
                    subtitle: 'Cache: ${controller.formattedCacheSize}',
                    trailing: controller.isClearingCache.value
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                          )
                        : const Icon(Icons.chevron_right_rounded, size: 20, color: Colors.grey),
                    showDivider: false,
                    onTap: () => controller.showClearCacheDialog(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Section 4: Support & About
            SettingsSectionCard(
              title: 'Support & Legal',
              children: [
                SettingsTile(
                  icon: Icons.support_agent_rounded,
                  iconColor: const Color(0xFF0284C7),
                  title: 'Help & Feedback',
                  subtitle: 'Contact support & FAQ assistance',
                  onTap: () {
                    controller.showLegalDialog(
                      context,
                      'Help & Support',
                      'Welcome to PDF Toolkit Help.\n\nAll tools process files completely on your device.\nFor support requests or bug reports, please visit our GitHub repository or contact support@pdftoolkit.app.',
                    );
                  },
                ),
                SettingsTile(
                  icon: Icons.star_border_rounded,
                  iconColor: const Color(0xFFF59E0B),
                  title: 'Rate the App',
                  subtitle: 'Leave a review on the store',
                  onTap: () {
                    Get.snackbar(
                      'Thank You!',
                      'Thank you for using and rating PDF Toolkit!',
                      backgroundColor: AppColors.primary,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                      margin: const EdgeInsets.all(16),
                    );
                  },
                ),
                SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  iconColor: const Color(0xFF059669),
                  title: 'Privacy Policy & Terms',
                  subtitle: 'Zero data retention commitment',
                  onTap: () {
                    controller.showLegalDialog(
                      context,
                      'Privacy & Terms',
                      'PDF Toolkit is built with a zero-data-collection philosophy.\n\n• None of your documents are uploaded to any external server.\n• All PDF operations (merging, splitting, encryption, watermarking) are completed offline on device.\n• No analytics or user trackers are stored.',
                    );
                  },
                ),
                SettingsTile(
                  icon: Icons.info_outline_rounded,
                  iconColor: const Color(0xFF6366F1),
                  title: 'About PDF Toolkit',
                  subtitle: 'Version 2.0.3 (Build 7)',
                  showDivider: false,
                  onTap: () => controller.showAboutDialog(context),
                ),
              ],
            ),

            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }
}
