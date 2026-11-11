import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:pdf_toolkit/app/core/services/ads_service.dart';
import 'package:pdf_toolkit/app/shared/components/ad_banner_card.dart';
import 'package:pdf_toolkit/app/shared/controllers/ad_banner_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AdMob & AdsService Tests', () {
    late AdsService adsService;

    setUp(() {
      Get.reset();
      adsService = AdsService();
      Get.put<AdsService>(adsService);
    });

    tearDown(() {
      Get.reset();
    });

    test('AdsService unit IDs return valid Google test ad unit IDs', () {
      expect(AdsService.bannerAdUnitId, isNotEmpty);
      expect(AdsService.interstitialAdUnitId, isNotEmpty);
      expect(AdsService.interstitialFrequency, equals(3));
    });

    test('AdsService increments action counter when action is triggered', () {
      expect(adsService.actionCounter, equals(0));

      adsService.showInterstitialIfReady();
      expect(adsService.actionCounter, equals(1));

      adsService.showInterstitialIfReady();
      expect(adsService.actionCounter, equals(2));

      adsService.showInterstitialIfReady();
      expect(adsService.actionCounter, equals(3));
    });

    test('AdsService resets action counter properly', () {
      adsService.showInterstitialIfReady();
      adsService.showInterstitialIfReady();
      expect(adsService.actionCounter, equals(2));

      adsService.resetActionCounter();
      expect(adsService.actionCounter, equals(0));
    });

    test('AdsService showInterstitialIfReady immediately calls onDismissed when ad is not ready', () {
      var callbackCalled = false;
      adsService.showInterstitialIfReady(onDismissed: () {
        callbackCalled = true;
      });

      expect(callbackCalled, isTrue);
    });
  });

  group('AdBannerController & AdBannerCard Tests', () {
    setUp(() {
      Get.reset();
    });

    tearDown(() {
      Get.reset();
    });

    test('AdBannerController initializes with isAdLoaded as false', () {
      final controller = AdBannerController();
      expect(controller.isAdLoaded.value, isFalse);
      expect(controller.bannerAd, isNull);
    });

    testWidgets('AdBannerCard renders SizedBox.shrink when ad is not loaded', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdBannerCard(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Since isAdLoaded is false, AdBannerCard renders SizedBox.shrink
      expect(find.text('AD'), findsNothing);
      expect(find.byType(AdBannerCard), findsOneWidget);
    });
  });
}
