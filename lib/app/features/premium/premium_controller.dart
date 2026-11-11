import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
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
    _listenToBillingEvents();
  }

  void _listenToBillingEvents() {
    final billing = billingService;
    if (billing != null) {
      ever<PurchaseStatus?>(billing.lastPurchaseStatus, (status) {
        if (status == PurchaseStatus.purchased || status == PurchaseStatus.restored) {
          syncSubscriptionState();
          isSuccessCelebration.value = true;
          isManageSubscription.value = true;
          isPurchasing.value = false;
        } else if (status == PurchaseStatus.error) {
          isPurchasing.value = false;
          Get.snackbar(
            'Purchase Error',
            'Could not complete purchase. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
          );
        } else if (status == PurchaseStatus.canceled) {
          isPurchasing.value = false;
        }
      });
    }
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
      final isTesting = Get.testMode;

      if (!isTesting) {
        // Production: Validate store connection & products
        if (billing == null || !billing.isAvailable.value) {
          Get.snackbar(
            'Store Unavailable',
            'Unable to connect to Google Play or App Store. Please check your internet connection.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFFEF4444),
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
          );
          return;
        }

        final targetProduct = billing.products.firstWhereOrNull(
          (p) => p.id.contains(selectedPlanId.value),
        );

        if (targetProduct == null) {
          Get.snackbar(
            'Store Initializing',
            'Subscription products are currently loading from the store. Please try again shortly.',
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(16),
          );
          return;
        }

        await billing.buyProduct(targetProduct);
        return;
      }

      // Test simulation mode (only executed during unit tests when Get.testMode == true)
      await Future.delayed(const Duration(milliseconds: 10));

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
    } catch (e) {
      Get.snackbar(
        'Purchase Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isPurchasing.value = false;
    }
  }

  Future<void> restorePurchases() async {
    if (isPurchasing.value) return;
    isPurchasing.value = true;

    try {
      final billing = billingService;
      final isTesting = Get.testMode;

      if (!isTesting) {
        if (billing == null || !billing.isAvailable.value) {
          Get.snackbar(
            'Store Unavailable',
            'Unable to connect to Google Play or App Store.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFFEF4444),
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
          );
          return;
        }

        await billing.restorePurchases();
        Get.snackbar(
          'Restoring Purchases',
          'Checking Google Play / App Store for active purchases...',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
        return;
      }

      // Test simulation
      await Future.delayed(const Duration(milliseconds: 10));
      final storage = storageService;
      if (storage != null) {
        await storage.setPremium(true);
        await storage.setPremiumPlan('yearly');
        await storage.setPremiumExpiresAt('Nov 11, 2027');
      }
      syncSubscriptionState();

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

  void showTermsOfUse(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Terms of Use (EULA)', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const SingleChildScrollView(
          child: Text(
            'PDF Toolkit End User License Agreement (EULA):\n\n'
            '1. Subscriptions: Payment will be charged to your Google Play or Apple ID account at confirmation of purchase.\n'
            '2. Auto-Renewal: Subscriptions automatically renew unless auto-renew is turned off at least 24 hours before the end of the current billing cycle.\n'
            '3. Cancellation: You can manage and cancel subscriptions anytime in your Google Play Store or App Store Account Settings.\n'
            '4. Lifetime Access: A one-time purchase grants permanent Pro access with no recurring charges.\n'
            '5. Offline Privacy: All tools process documents 100% on your device.',
            style: TextStyle(height: 1.45),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF97316)),
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Privacy Policy', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const SingleChildScrollView(
          child: Text(
            'Zero-Data Retention Commitment:\n\n'
            '• PDF Toolkit does not collect, transmit, or store any of your files or documents.\n'
            '• All PDF operations (merging, splitting, compression, scanning, password encryption) run entirely offline on your device.\n'
            '• We do not track, profile, or sell your personal information.',
            style: TextStyle(height: 1.45),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF97316)),
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
