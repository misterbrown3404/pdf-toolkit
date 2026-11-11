import 'dart:io';
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../models/watermark_config_model.dart';

class WatermarkPreviewCard extends StatelessWidget {
  final WatermarkConfigModel config;

  const WatermarkPreviewCard({
    super.key,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Alignment alignment;
    switch (config.position) {
      case 'top':
        alignment = const Alignment(0, -0.6);
        break;
      case 'bottom':
        alignment = const Alignment(0, 0.6);
        break;
      case 'center':
      default:
        alignment = Alignment.center;
        break;
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Live Page Preview',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                ),
              ),
              const Text(
                'Page 1 of Document',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Center(
          child: Container(
            width: 190,
            height: 250,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Stack(
                children: [
                  // Document Skeleton lines
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 10,
                            width: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2E8F0),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 6,
                            width: 150,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            height: 6,
                            width: 130,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            height: 38,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            height: 6,
                            width: 145,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            height: 6,
                            width: 120,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            height: 6,
                            width: 90,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Overlaid Live Watermark Stamp
                  Positioned.fill(
                    child: Align(
                      alignment: alignment,
                      child: Transform.rotate(
                        angle: config.rotationAngle * (3.141592653589793 / 180),
                        child: config.watermarkType == 'image' && config.imageLogoPath != null
                            ? Opacity(
                                opacity: config.opacity.clamp(0.05, 0.95),
                                child: Image.file(
                                  File(config.imageLogoPath!),
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) => const Icon(
                                    Icons.branding_watermark_rounded,
                                    size: 40,
                                    color: AppColors.primary,
                                  ),
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: config.color.withValues(alpha: config.opacity),
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  config.text.isEmpty ? 'WATERMARK' : config.text,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: (config.fontSize * 0.42).clamp(10.0, 26.0),
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.5,
                                    color: config.color.withValues(alpha: config.opacity),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
