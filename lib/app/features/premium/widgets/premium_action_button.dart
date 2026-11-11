import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../premium_controller.dart';

class PremiumActionButton extends StatelessWidget {
  const PremiumActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PremiumController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final isLoading = controller.isPurchasing.value;

      return Column(
        children: [
          Container(
            width: double.infinity,
            height: 54,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(27),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(27),
              child: InkWell(
                borderRadius: BorderRadius.circular(27),
                onTap: isLoading ? null : controller.purchasePlan,
                child: Center(
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.workspace_premium_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Upgrade Now',
                              style: AppTypography.labelLarge.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Restore Purchase button
          TextButton(
            onPressed: isLoading ? null : controller.restorePurchases,
            child: Text(
              'Restore Purchase',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      );
    });
  }
}

