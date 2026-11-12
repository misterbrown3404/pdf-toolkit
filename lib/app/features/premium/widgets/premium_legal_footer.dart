import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../premium_controller.dart';

class PremiumLegalFooter extends StatelessWidget {
  final PremiumController controller;

  const PremiumLegalFooter({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor = isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight;

    return Column(
      children: [
        Text(
          'Auto-renewable subscription. Cancel anytime in Google Play Store or App Store settings.',
          textAlign: TextAlign.center,
          style: AppTypography.bodySmall.copyWith(
            color: mutedColor,
            fontSize: 11,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => controller.showTermsOfUse(context),
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Text(
                  'Terms of Use (EULA)',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            Text(' • ', style: TextStyle(color: mutedColor, fontSize: 11)),
            InkWell(
              onTap: () => controller.showPrivacyPolicy(context),
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Text(
                  'Privacy Policy',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

