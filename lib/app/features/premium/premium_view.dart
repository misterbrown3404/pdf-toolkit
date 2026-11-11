import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'premium_controller.dart';
import 'widgets/premium_action_button.dart';
import 'widgets/premium_active_view.dart';
import 'widgets/premium_features_card.dart';
import 'widgets/premium_header_banner.dart';
import 'widgets/premium_legal_footer.dart';
import 'widgets/premium_plans_selector.dart';
import 'widgets/premium_success_view.dart';

class PremiumView extends GetView<PremiumController> {
  const PremiumView({super.key});

  @override
  Widget build(BuildContext context) {
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

              // Legal footer with clickable EULA and Privacy Policy
              PremiumLegalFooter(controller: controller),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    });
  }
}
