import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';

class PremiumHeaderBanner extends StatelessWidget {
  const PremiumHeaderBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back navigation button
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: Icon(
            Icons.arrow_back_rounded,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            size: 26,
          ),
          onPressed: () => Get.back(),
        ),
        const SizedBox(height: 14),
        // Row with Title and 3D Crown Hero
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upgrade to\nPremium',
                    style: AppTypography.displaySmall.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 28,
                      height: 1.15,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Unlock full access to all PDF tools',
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // 3D Crown Hero Artwork
            Image.asset(
              'assets/images/premium_crown_hero.png',
              width: 120,
              height: 110,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 44),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

