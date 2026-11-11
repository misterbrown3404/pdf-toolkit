import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';

class CompressHeaderBanner extends StatelessWidget {
  const CompressHeaderBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // App Bar Controls
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                ),
                onPressed: () => Get.back(),
              ),
              IconButton(
                icon: Icon(
                  Icons.home_outlined,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                ),
                onPressed: () => Get.offAllNamed(AppRoutes.home),
                tooltip: 'Home',
              ),
            ],
          ),
        ),

        // Title, Subtitle & 3D Illustration
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 16, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Compress PDF',
                      style: AppTypography.headlineMedium.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 26,
                        letterSpacing: -0.5,
                        color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Reduce your PDF file size while keeping great quality.',
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 13,
                        height: 1.35,
                        color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Image.asset(
                'assets/images/compress_header_doc.png',
                height: 80,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEDD5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.compress_rounded,
                    color: AppColors.primary,
                    size: 32,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

