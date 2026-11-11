import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../scanner_controller.dart';
import '../viewfinder_painter.dart';
import 'scanner_scan_line.dart';

class ScannerCameraViewfinder extends StatelessWidget {
  final ScannerController controller;

  const ScannerCameraViewfinder({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF13151A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Subtle camera grid background
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.9,
                    colors: [
                      Color(0xFF222630),
                      Color(0xFF0F1117),
                    ],
                  ),
                ),
              ),
            ),

            // Center document hint watermark
            Center(
              child: Opacity(
                opacity: 0.28,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.document_scanner_rounded,
                      size: 64,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Align document within frame',
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Animated Scanner Beam
            const Positioned.fill(
              child: ScannerScanLine(),
            ),

            // Glowing Viewfinder Frame with Orange Corners & Anchor Handles
            const Positioned.fill(
              child: CustomPaint(
                painter: ViewfinderPainter(),
              ),
            ),

            // Top Pill: Auto / Manual Edge Detection
            Positioned(
              top: 14,
              left: 0,
              right: 0,
              child: Center(
                child: Obx(
                  () => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildDetectPill(
                          label: 'Auto Detect',
                          isSelected: controller.isAutoDetect.value,
                          onTap: () => controller.isAutoDetect.value = true,
                        ),
                        _buildDetectPill(
                          label: 'Manual',
                          isSelected: !controller.isAutoDetect.value,
                          onTap: () => controller.isAutoDetect.value = false,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Overlaid Zoom Selector Pills
            Positioned(
              bottom: 14,
              left: 0,
              right: 0,
              child: Center(
                child: Obx(
                  () => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.12),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildZoomPill('0.5x', 0.5),
                        const SizedBox(width: 4),
                        _buildZoomPill('1x', 1.0),
                        const SizedBox(width: 4),
                        _buildZoomPill('2x', 2.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetectPill({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              const Icon(Icons.check_rounded, color: Colors.white, size: 13),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZoomPill(String label, double value) {
    final isSelected = (controller.zoomLevel.value - value).abs() < 0.1;
    return GestureDetector(
      onTap: () => controller.setZoom(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}

