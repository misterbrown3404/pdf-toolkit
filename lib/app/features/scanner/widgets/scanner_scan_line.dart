import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../theme/app_colors.dart';

class ScannerScanLine extends StatelessWidget {
  const ScannerScanLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 3.0,
        margin: const EdgeInsets.symmetric(horizontal: 28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.0),
              AppColors.primary,
              const Color(0xFFFDBA74),
              AppColors.primary,
              AppColors.primary.withValues(alpha: 0.0),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.55),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
      )
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .moveY(
            begin: -130,
            end: 130,
            duration: const Duration(milliseconds: 2200),
            curve: Curves.easeInOut,
          ),
    );
  }
}
