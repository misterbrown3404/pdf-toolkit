import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/storage_service.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../home/home_controller.dart';

class SettingsView extends GetView<HomeController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final storageService = Get.find<StorageService>();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: AppTypography.headlineSmall.copyWith(
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            Text(
              'Manage your app and preferences',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // App Plan Profile Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLightMuted,
              ),
            ),
            child: Row(
              children: [
                // App Logo Squircle
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'PDF',
                        style: TextStyle(
                          color: AppColors.pdfRed,
                          fontWeight: FontWeight.w900,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'PDF Toolkit',
                            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFEDD5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Free Plan',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'All-in-one PDF tools',
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Colors.grey),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Upgrade to Premium Hero Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: isDark
                  ? const LinearGradient(
                      colors: [Color(0xFF332014), Color(0xFF26180E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : const LinearGradient(
                      colors: [Color(0xFFFFF1E6), Color(0xFFFFEDD5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.workspace_premium_rounded,
                  size: 32,
                  color: AppColors.premiumGold,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Upgrade to Premium',
                        style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Unlock all tools, remove limits and ads.',
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(88, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () => Get.toNamed(AppRoutes.premium),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('Upgrade', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_rounded, size: 14),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // App Settings Group
          _buildGroupHeader(context, 'App Settings'),
          _buildGroupContainer(
            context,
            isDark: isDark,
            children: [
              _buildSettingTile(
                icon: Icons.notifications_none_rounded,
                title: 'Notifications',
                subtitle: 'Get file and task updates',
                trailing: Switch.adaptive(
                  value: true,
                  activeThumbColor: AppColors.primary,
                  onChanged: (val) {},
                ),
              ),
              const Divider(height: 1),
              _buildSettingTile(
                icon: Icons.palette_outlined,
                title: 'Appearance',
                subtitle: Get.isDarkMode ? 'Dark Mode' : 'Light Mode',
                onTap: () {
                  final newMode = Get.isDarkMode ? ThemeMode.light : ThemeMode.dark;
                  storageService.saveThemeMode(newMode);
                  Get.changeThemeMode(newMode);
                },
              ),
              const Divider(height: 1),
              _buildSettingTile(
                icon: Icons.translate_rounded,
                title: 'Language',
                subtitle: 'English (United States)',
                onTap: () {},
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Storage & Files Group
          _buildGroupHeader(context, 'Storage & Files'),
          _buildGroupContainer(
            context,
            isDark: isDark,
            children: [
              _buildSettingTile(
                icon: Icons.storage_rounded,
                title: 'Storage',
                subtitle: '24.8 GB used of 128 GB',
                onTap: () {},
              ),
              const Divider(height: 1),
              _buildSettingTile(
                icon: Icons.delete_outline_rounded,
                title: 'Recycle Bin',
                subtitle: 'Deleted files (30 days)',
                onTap: () {},
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Support Group
          _buildGroupHeader(context, 'Support'),
          _buildGroupContainer(
            context,
            isDark: isDark,
            children: [
              _buildSettingTile(
                icon: Icons.help_outline_rounded,
                title: 'Help & Feedback',
                subtitle: 'Get help or send us a message',
                onTap: () {},
              ),
              const Divider(height: 1),
              _buildSettingTile(
                icon: Icons.star_outline_rounded,
                title: 'Rate the App',
                subtitle: 'Share your experience on the Play Store',
                onTap: () {},
              ),
              const Divider(height: 1),
              _buildSettingTile(
                icon: Icons.info_outline_rounded,
                title: 'About',
                subtitle: 'App version 2.0.3 (7)',
                onTap: () {},
              ),
            ],
          ),

          const SizedBox(height: 36),
        ],
      ),
    );
  }

  Widget _buildGroupHeader(BuildContext context, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: AppTypography.titleSmall.copyWith(
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
        ),
      ),
    );
  }

  Widget _buildGroupContainer(
    BuildContext context, {
    required bool isDark,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLightMuted,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(children: children),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFFFFEDD5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(
        title,
        style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondaryLight),
            )
          : null,
      trailing: trailing ?? const Icon(Icons.chevron_right_rounded, color: Colors.grey),
      onTap: onTap,
    );
  }
}
