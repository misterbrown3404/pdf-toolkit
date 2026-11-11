import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'splash_controller.dart';
import 'widgets/splash_bottom_wave_painter.dart';
import 'widgets/splash_feature_pill.dart';
import 'widgets/splash_top_wave_painter.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Stack(
        children: [
          // 1. Top-Left Organic Curved Wave (Generated Entirely with Code)
          Positioned(
            top: 0,
            left: 0,
            child: SizedBox(
              width: size.width * 0.65,
              height: size.height * 0.24,
              child: const CustomPaint(
                painter: SplashTopWavePainter(),
              ),
            ),
          ),

          // 2. Bottom Fluid Layered Waves (Generated Entirely with Code)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              width: size.width,
              height: size.height * 0.32,
              child: const CustomPaint(
                painter: SplashBottomWavePainter(),
              ),
            ),
          ),

          // 3. Central Content & Code-Designed UI
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 3),

                // Extracted 3D PDF App Logo Illustration
                Image.asset(
                  'assets/images/splash_logo.png',
                  width: 140,
                  height: 140,
                  fit: BoxFit.contain,
                )
                    .animate()
                    .scale(duration: 650.ms, curve: Curves.easeOutBack)
                    .fadeIn(duration: 400.ms),

                const SizedBox(height: 24),

                // Title: PDF Toolkit
                RichText(
                  text: TextSpan(
                    style: AppTypography.displayMedium.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                    children: const [
                      TextSpan(
                        text: 'PDF ',
                        style: TextStyle(color: AppColors.primary),
                      ),
                      TextSpan(
                        text: 'Toolkit',
                        style: TextStyle(color: AppColors.textPrimaryLight),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),

                const SizedBox(height: 8),

                // Subtitle: All-in-one PDF tools
                Text(
                  'All-in-one PDF tools',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ).animate().fadeIn(delay: 350.ms),

                const SizedBox(height: 28),

                // 4 Capability Pills (Designed in Code)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SplashFeaturePill(
                      icon: Icons.content_cut_rounded,
                      label: 'Edit',
                      iconColor: AppColors.primary,
                      backgroundColor: Color(0xFFFFEDD5),
                    ),
                    SizedBox(width: 8),
                    SplashFeaturePill(
                      icon: Icons.note_add_rounded,
                      label: 'Merge',
                      iconColor: AppColors.splitPurple,
                      backgroundColor: Color(0xFFF3E8FF),
                    ),
                    SizedBox(width: 8),
                    SplashFeaturePill(
                      icon: Icons.sync_rounded,
                      label: 'Convert',
                      iconColor: AppColors.docxBlue,
                      backgroundColor: Color(0xFFDBEAFE),
                    ),
                    SizedBox(width: 8),
                    SplashFeaturePill(
                      icon: Icons.layers_rounded,
                      label: 'Organize',
                      iconColor: AppColors.compressGreen,
                      backgroundColor: Color(0xFFDCFCE7),
                    ),
                  ],
                ).animate().fadeIn(delay: 450.ms).slideY(begin: 0.1, end: 0),

                const SizedBox(height: 20),

                // Center rounded orange divider pill
                Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ).animate().fadeIn(delay: 500.ms),

                const Spacer(flex: 3),

                // Loading Spinner (Designed in Code, positioned over bottom wave)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ).animate().fadeIn(delay: 600.ms),

                const SizedBox(height: 10),

                const Text(
                  'Loading...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ).animate().fadeIn(delay: 650.ms),

                const SizedBox(height: 38),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
