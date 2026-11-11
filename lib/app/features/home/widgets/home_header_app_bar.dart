import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../home_controller.dart';

class HomeHeaderAppBar extends StatelessWidget {
  final HomeController controller;

  const HomeHeaderAppBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SliverAppBar(
      floating: true,
      pinned: false,
      toolbarHeight: 68,
      titleSpacing: 16,
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
      elevation: 0,
      title: Row(
        children: [
          // 3D App Squircle Icon
          Image.asset(
            'assets/images/splash_logo.png',
            width: 44,
            height: 44,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.picture_as_pdf_rounded, color: Colors.white, size: 24),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'PDF Toolkit',
                style: AppTypography.headlineSmall.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 19,
                  letterSpacing: -0.3,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Your documents, simplified',
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 12.5,
                  color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        // Circular Search Button
        Container(
          width: 40,
          height: 40,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
              width: 1,
            ),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.search_rounded,
              size: 21,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
            ),
            onPressed: controller.openPdfPicker,
            tooltip: 'Search documents',
          ),
        ),

        // Circular Notification Bell Button with Orange Unread Dot
        Container(
          width: 40,
          height: 40,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
              width: 1,
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.notifications_none_rounded,
                    size: 21,
                    color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                  ),
                  onPressed: () => Get.toNamed(AppRoutes.premium),
                  tooltip: 'Notifications & Premium',
                ),
              ),
              Positioned(
                top: 8,
                right: 9,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
