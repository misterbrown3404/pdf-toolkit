import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/services/ads_service.dart';
import '../../core/services/storage_service.dart';

class AdBannerController extends GetxController {
  final StorageService? storageService =
      Get.isRegistered<StorageService>() ? Get.find<StorageService>() : null;

  BannerAd? bannerAd;
  final RxBool isAdLoaded = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadBanner();
  }

  void loadBanner() {
    if (storageService?.isPremium == true) return;

    try {
      bannerAd = BannerAd(
        adUnitId: AdsService.bannerAdUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            isAdLoaded.value = true;
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            bannerAd = null;
            isAdLoaded.value = false;
          },
        ),
      );
      bannerAd?.load();
    } catch (_) {
      isAdLoaded.value = false;
    }
  }

  @override
  void onClose() {
    bannerAd?.dispose();
    super.onClose();
  }
}
