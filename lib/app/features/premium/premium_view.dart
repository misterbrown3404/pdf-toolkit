import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'premium_controller.dart';

class PremiumView extends GetView<PremiumController> {
  const PremiumView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
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
                        height: 1.15,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Unlock full access to all PDF tools',
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: AppColors.premiumGoldGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.premiumGold.withValues(alpha: 0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(Icons.workspace_premium_rounded, size: 40, color: Colors.white),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLightMuted,
              ),
            ),
            child: Column(
              children: [
                _buildFeatureRow(
                  icon: Icons.all_inclusive_rounded,
                  title: 'Unlimited PDF tools',
                  subtitle: 'Merge, split, compress, convert and more',
                  isDark: isDark,
                ),
                const Divider(height: 16),
                _buildFeatureRow(
                  icon: Icons.block_rounded,
                  title: 'Ad-free experience',
                  subtitle: 'Work without interruptions',
                  isDark: isDark,
                ),
                const Divider(height: 16),
                _buildFeatureRow(
                  icon: Icons.layers_rounded,
                  title: 'Higher file limits',
                  subtitle: 'Handle larger and more files',
                  isDark: isDark,
                ),
                const Divider(height: 16),
                _buildFeatureRow(
                  icon: Icons.flash_on_rounded,
                  title: 'Priority support',
                  subtitle: 'Get faster help when you need it',
                  isDark: isDark,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Obx(() {
            final isMonthly = controller.selectedPlan.value == 'monthly';
            return InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => controller.selectedPlan.value = 'monthly',
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isMonthly
                      ? (isDark ? const Color(0xFF332014) : const Color(0xFFFFF7ED))
                      : (isDark ? AppColors.cardDark : AppColors.cardLight),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isMonthly
                        ? AppColors.primary
                        : (isDark ? AppColors.borderDark : AppColors.borderLightMuted),
                    width: isMonthly ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEDD5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.calendar_month_rounded, color: AppColors.primary, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Monthly', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w800)),
                          const SizedBox(height: 2),
                          Text('₦2,500 / month', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondaryLight)),
                        ],
                      ),
                    ),
                    Icon(
                      isMonthly ? Icons.radio_button_checked : Icons.radio_button_off,
                      color: isMonthly ? AppColors.primary : Colors.grey,
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 12),

          Obx(() {
            final isYearly = controller.selectedPlan.value == 'yearly';
            return InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => controller.selectedPlan.value = 'yearly',
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isYearly
                      ? (isDark ? const Color(0xFF332014) : const Color(0xFFFFF7ED))
                      : (isDark ? AppColors.cardDark : AppColors.cardLight),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isYearly
                        ? AppColors.primary
                        : (isDark ? AppColors.borderDark : AppColors.borderLightMuted),
                    width: isYearly ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEDD5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.date_range_rounded, color: AppColors.primary, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Yearly', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w800)),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'Save 40%',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text('₦18,000 / year', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondaryLight)),
                        ],
                      ),
                    ),
                    Icon(
                      isYearly ? Icons.radio_button_checked : Icons.radio_button_off,
                      color: isYearly ? AppColors.primary : Colors.grey,
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 24),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(27),
              ),
            ),
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.workspace_premium_rounded, size: 20),
                SizedBox(width: 8),
                Text(
                  'Upgrade Now',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Center(
            child: TextButton(
              onPressed: () => controller.billingService.restorePurchases(),
              child: const Text(
                'Restore Purchase',
                style: TextStyle(
                  color: AppColors.textSecondaryLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildFeatureRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: Color(0xFFFFEDD5),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTypography.bodySmall.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
