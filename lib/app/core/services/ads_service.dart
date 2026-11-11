import 'dart:io';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'storage_service.dart';

class AdsService extends GetxService {
  final StorageService? _injectedStorageService;

  AdsService({StorageService? storageService}) : _injectedStorageService = storageService;

  StorageService? get _storageService =>
      _injectedStorageService ?? (Get.isRegistered<StorageService>() ? Get.find<StorageService>() : null);

  InterstitialAd? _interstitialAd;
  bool _isInterstitialLoading = false;
  int _actionCounter = 0;
  int get actionCounter => _actionCounter;
  static const int interstitialFrequency = 3; // Show ad every 3 actions

  // Standard Google AdMob test IDs
  static String get bannerAdUnitId {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716'; // iOS test banner
    }
    return 'ca-app-pub-3940256099942544/6300978111'; // Android test banner
  }

  static String get interstitialAdUnitId {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910'; // iOS test interstitial
    }
    return 'ca-app-pub-3940256099942544/1033173712'; // Android test interstitial
  }

  Future<AdsService> init() async {
    try {
      await MobileAds.instance.initialize();
      loadInterstitialAd();
    } catch (e) {
      // Graceful fallback if ad network fails to initialize offline
    }
    return this;
  }

  void loadInterstitialAd() {
    if (_storageService?.isPremium == true || _isInterstitialLoading) return;

    _isInterstitialLoading = true;
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialLoading = false;
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
          _isInterstitialLoading = false;
        },
      ),
    );
  }

  /// Trigger after a completed PDF action (e.g. merge, split, convert)
  void showInterstitialIfReady({void Function()? onDismissed}) {
    if (_storageService?.isPremium == true) {
      onDismissed?.call();
      return;
    }

    _actionCounter++;
    if (_actionCounter >= interstitialFrequency && _interstitialAd != null) {
      _actionCounter = 0;
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _interstitialAd = null;
          loadInterstitialAd();
          onDismissed?.call();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _interstitialAd = null;
          loadInterstitialAd();
          onDismissed?.call();
        },
      );
      _interstitialAd!.show();
    } else {
      onDismissed?.call();
    }
  }

  void resetActionCounter() {
    _actionCounter = 0;
  }

  @override
  void onClose() {
    _interstitialAd?.dispose();
    super.onClose();
  }
}

