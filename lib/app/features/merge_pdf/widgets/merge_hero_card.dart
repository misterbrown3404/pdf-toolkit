import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';

class MergeHeroCard extends StatelessWidget {
  const MergeHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Column(
        children: [
          // 3D Merged Documents Illustration with Swap Arrows
          Image.asset(
            'assets/images/merge_hero_docs.png',
            height: 120,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => const Icon(
              Icons.layers_rounded,
              size: 64,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),

          // Title: Reorder Files
          Text(
            'Reorder Files',
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 20,
              letterSpacing: -0.3,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),

          // Subtitle
          Text(
            'Drag and drop to arrange the documents in the\norder you want them to appear.',
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
              fontSize: 12.5,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

