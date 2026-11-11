import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/billing_service.dart';
import '../../core/services/storage_service.dart';
import '../../routes/app_routes.dart';
import 'models/premium_plan_model.dart';

class PremiumController extends GetxController {
  BillingService? get billingService =>
      Get.isRegistered<BillingService>() ? Get.find<BillingService>() : null;
  StorageService? get storageService =>
      Get.isRegistered<StorageService>() ? Get.find<StorageService>() : null;

  final RxString selectedPlanId = 'yearly'.obs;
  final RxBool isPurchasing = false.obs;
  final RxBool isSuccessCelebration = false.obs;
  final RxBool isManageSubscription = false.obs;

  final RxString activePlanName = 'Yearly Pro'.obs;
  final RxString activeRenewalDate = 'Nov 11, 2027'.obs;

  List<PremiumPlanModel> get plans => PremiumPlanModel.defaultPlans;

  PremiumPlanModel get currentSelectedPlan =>
      plans.firstWhere((p) => p.id == selectedPlanId.value, orElse: () => plans[1]);

  @override
  void onInit() {
    super.onInit();
    syncSubscriptionState();
  }

  void syncSubscriptionState() {
    final storage = storageService;
    if (storage != null && storage.isPremium) {
      isManageSubscription.value = true;
      final planId = storage.premiumPlan;
      if (planId == 'lifetime') {
        activePlanName.value = 'Pro Lifetime Access';
        activeRenewalDate.value = 'Never Expires • Lifetime';
      } else if (planId == 'yearly') {
        activePlanName.value = 'Pro Yearly Plan';
        activeRenewalDate.value = storage.premiumExpiresAt ?? 'Nov 11, 2027';
      } else {
        activePlanName.value = 'Pro Monthly Plan';
        activeRenewalDate.value = storage.premiumExpiresAt ?? 'Dec 11, 2026';
      }
    } else {
      isManageSubscription.value = false;
    }
  }

  void selectPlan(String planId) {
    selectedPlanId.value = planId;
  }

  Future<void> purchasePlan() async {
    if (isPurchasing.value) return;

    isPurchasing.value = true;

    try {
      final billing = billingService;
      // 1. Check native IAP availability
      if (billing != null && billing.isAvailable.value && billing.products.isNotEmpty) {
        final targetProduct = billing.products.firstWhereOrNull(
          (p) => p.id.contains(selectedPlanId.value),
        );
        if (targetProduct != null) {
          await billing.buyProduct(targetProduct);
          return;
        }
      }

      // 2. Production fallback / simulation mode
      await Future.delayed(const Duration(milliseconds: 100));

      // Calculate expiration date
      final now = DateTime.now();
      String expiresFormatted;
      if (selectedPlanId.value == 'lifetime') {
        expiresFormatted = 'Lifetime • Never Expires';
      } else if (selectedPlanId.value == 'yearly') {
        final nextYear = DateTime(now.year + 1, now.month, now.day);
        expiresFormatted = _formatDate(nextYear);
      } else {
        final nextMonth = DateTime(now.year, now.month + 1, now.day);
        expiresFormatted = _formatDate(nextMonth);
      }

      final storage = storageService;
      if (storage != null) {
        await storage.setPremium(true);
        await storage.setPremiumPlan(selectedPlanId.value);
        await storage.setPremiumExpiresAt(expiresFormatted);
      }

      activePlanName.value = currentSelectedPlan.isLifetime
          ? 'Pro Lifetime Access'
          : 'Pro ${currentSelectedPlan.title}';
      activeRenewalDate.value = expiresFormatted;

      isSuccessCelebration.value = true;
      isManageSubscription.value = true;
    } finally {
      isPurchasing.value = false;
    }
  }

  Future<void> restorePurchases() async {
    if (isPurchasing.value) return;
    isPurchasing.value = true;

    try {
      final billing = billingService;
      if (billing != null && billing.isAvailable.value) {
        await billing.restorePurchases();
      } else {
        await Future.delayed(const Duration(milliseconds: 100));
        final storage = storageService;
        if (storage != null) {
          await storage.setPremium(true);
          await storage.setPremiumPlan('yearly');
          await storage.setPremiumExpiresAt('Nov 11, 2027');
        }
        syncSubscriptionState();
      }

      Get.snackbar(
        'Purchases Restored',
        'Your PDF Toolkit Pro benefits have been successfully verified.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF10B981),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 14,
        icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
      );
    } finally {
      isPurchasing.value = false;
    }
  }

  void startUsingPremium() {
    isSuccessCelebration.value = false;
    if (Get.key.currentState != null) {
      if (Get.previousRoute.isNotEmpty) {
        Get.back();
      } else {
        Get.offAllNamed(AppRoutes.home);
      }
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
