import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../theme/app_colors.dart';
import '../controllers/ad_banner_controller.dart';

class AdBannerCard extends StatelessWidget {
  const AdBannerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdBannerController(), tag: 'global_banner');
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      if (controller.storageService?.isPremium == true ||
          !controller.isAdLoaded.value ||
          controller.bannerAd == null) {
        return const SizedBox.shrink();
      }

      final ad = controller.bannerAd!;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLightMuted,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 8, top: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'AD',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: ad.size.width.toDouble(),
              height: ad.size.height.toDouble(),
              child: AdWidget(ad: ad),
            ),
          ],
        ),
      );
    });
  }
}
