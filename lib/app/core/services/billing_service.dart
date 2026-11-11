import 'dart:async';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'storage_service.dart';

class BillingService extends GetxService {
  final StorageService _storageService = Get.find<StorageService>();
  final InAppPurchase _iap = InAppPurchase.instance;

  StreamSubscription<List<PurchaseDetails>>? _subscription;
  final RxBool isAvailable = false.obs;
  final RxList<ProductDetails> products = <ProductDetails>[].obs;
  final RxBool isPurchasing = false.obs;

  static const String subscriptionMonthlyId = 'pdf_toolkit_premium_monthly';
  static const String subscriptionYearlyId = 'pdf_toolkit_premium_yearly';
  static const String lifetimeId = 'pdf_toolkit_premium_lifetime';

  Future<BillingService> init() async {
    isAvailable.value = await _iap.isAvailable();
    if (isAvailable.value) {
      _subscription = _iap.purchaseStream.listen(
        _onPurchaseUpdated,
        onDone: () => _subscription?.cancel(),
        onError: (error) {},
      );
      await loadProducts();
    }
    return this;
  }

  Future<void> loadProducts() async {
    if (!isAvailable.value) return;

    final ids = {subscriptionMonthlyId, subscriptionYearlyId, lifetimeId};
    final response = await _iap.queryProductDetails(ids);
    if (response.error == null) {
      products.assignAll(response.productDetails);
    }
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
    } finally {
      isPurchasing.value = false;
    }
  }

  Future<void> restorePurchases() async {
    isPurchasing.value = true;
    try {
      await _iap.restorePurchases();
    } finally {
      isPurchasing.value = false;
    }
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (final purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        _storageService.setPremium(true);
        if (purchase.pendingCompletePurchase) {
          _iap.completePurchase(purchase);
        }
      } else if (purchase.status == PurchaseStatus.error) {
        // Handle purchase error
      }
    }
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}

