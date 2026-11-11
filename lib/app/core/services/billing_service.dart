import 'dart:async';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'storage_service.dart';

class BillingService extends GetxService {
  final StorageService? _injectedStorageService;

  BillingService({StorageService? storageService})
      : _injectedStorageService = storageService;

  StorageService? get _storageService =>
      _injectedStorageService ??
      (Get.isRegistered<StorageService>() ? Get.find<StorageService>() : null);

  final InAppPurchase _iap = InAppPurchase.instance;

  StreamSubscription<List<PurchaseDetails>>? _subscription;
  final RxBool isAvailable = false.obs;
  final RxList<ProductDetails> products = <ProductDetails>[].obs;
  final RxBool isPurchasing = false.obs;

  final Rx<PurchaseStatus?> lastPurchaseStatus = Rx<PurchaseStatus?>(null);
  final RxString lastPurchasedProductId = ''.obs;

  static const String subscriptionMonthlyId = 'pdf_toolkit_premium_monthly';
  static const String subscriptionYearlyId = 'pdf_toolkit_premium_yearly';
  static const String lifetimeId = 'pdf_toolkit_premium_lifetime';

  Future<BillingService> init() async {
    try {
      isAvailable.value = await _iap.isAvailable();
      if (isAvailable.value) {
        _subscription = _iap.purchaseStream.listen(
          _onPurchaseUpdated,
          onDone: () => _subscription?.cancel(),
          onError: (_) {
            isPurchasing.value = false;
          },
        );
        await loadProducts();
      }
    } catch (_) {
      isAvailable.value = false;
    }
    return this;
  }

  Future<void> loadProducts() async {
    if (!isAvailable.value) return;

    try {
      final ids = {subscriptionMonthlyId, subscriptionYearlyId, lifetimeId};
      final response = await _iap.queryProductDetails(ids);
      if (response.error == null) {
        products.assignAll(response.productDetails);
      }
    } catch (_) {}
  }

  Future<void> buyProduct(ProductDetails product) async {
    isPurchasing.value = true;
    final purchaseParam = PurchaseParam(productDetails: product);
    try {
      if (product.id == lifetimeId) {
        await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      } else {
        await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      }
    } catch (e) {
      isPurchasing.value = false;
      rethrow;
    }
  }

  Future<void> restorePurchases() async {
    isPurchasing.value = true;
    try {
      await _iap.restorePurchases();
    } catch (e) {
      isPurchasing.value = false;
      rethrow;
    }
  }

  Future<void> _onPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    for (final purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        final storage = _storageService;
        if (storage != null) {
          await storage.setPremium(true);
          final plan = purchase.productID.contains('lifetime')
              ? 'lifetime'
              : (purchase.productID.contains('yearly') ? 'yearly' : 'monthly');
          await storage.setPremiumPlan(plan);
        }
        if (purchase.pendingCompletePurchase) {
          await _iap.completePurchase(purchase);
        }
        lastPurchasedProductId.value = purchase.productID;
        lastPurchaseStatus.value = purchase.status;
        isPurchasing.value = false;
      } else if (purchase.status == PurchaseStatus.error) {
        lastPurchaseStatus.value = PurchaseStatus.error;
        isPurchasing.value = false;
      } else if (purchase.status == PurchaseStatus.canceled) {
        lastPurchaseStatus.value = PurchaseStatus.canceled;
        isPurchasing.value = false;
      }
    }
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
