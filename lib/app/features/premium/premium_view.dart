import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'premium_controller.dart';
import 'widgets/premium_action_button.dart';
import 'widgets/premium_active_view.dart';
import 'widgets/premium_features_card.dart';
import 'widgets/premium_header_banner.dart';
import 'widgets/premium_plans_selector.dart';
import 'widgets/premium_success_view.dart';

class PremiumView extends GetView<PremiumController> {
  const PremiumView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      if (controller.isSuccessCelebration.value) {
        return const PremiumSuccessView();
      }

      if (controller.isManageSubscription.value) {
        return const PremiumActiveView();
      }

      return Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            children: [
              // Top Header Banner with 3D Crown
              const PremiumHeaderBanner(),
              const SizedBox(height: 16),

              // Feature benefits card
              const PremiumFeaturesCard(),
              const SizedBox(height: 18),

              // Pricing plans selector
              const PremiumPlansSelector(),
              const SizedBox(height: 14),

              // CTA button & restore link
              const PremiumActionButton(),
              const SizedBox(height: 12),

              // Legal note
              Text(
                'Auto-renewable subscription. Cancel anytime in Google Play Store or App Store settings. By subscribing, you agree to our Terms of Use and Privacy Policy.',
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
                  fontSize: 11,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    });
  }
}
