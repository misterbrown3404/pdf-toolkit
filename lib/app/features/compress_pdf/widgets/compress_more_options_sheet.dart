import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';

class CompressMoreOptionsSheet extends StatelessWidget {
  final bool removeMetadata;
  final ValueChanged<bool> onToggleMetadata;
  final bool downsampleImages;
  final ValueChanged<bool> onToggleDownsample;
  final double imageQuality;
  final ValueChanged<double> onQualityChanged;

  const CompressMoreOptionsSheet({
    super.key,
    required this.removeMetadata,
    required this.onToggleMetadata,
    required this.downsampleImages,
    required this.onToggleDownsample,
    required this.imageQuality,
    required this.onQualityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Advanced Options',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Get.back(),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Option 1: Remove Metadata
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            activeTrackColor: AppColors.primary,
            title: const Text('Strip Metadata', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            subtitle: const Text('Removes author, creation dates, and tool tags to shave extra bytes.', style: TextStyle(fontSize: 12)),
            value: removeMetadata,
            onChanged: onToggleMetadata,
          ),
          const Divider(height: 1),

          // Option 2: Downsample Images
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            activeTrackColor: AppColors.primary,
            title: const Text('Downsample High-Res Images', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            subtitle: const Text('Reduces photo resolution to 150 DPI for compact file size.', style: TextStyle(fontSize: 12)),
            value: downsampleImages,
            onChanged: onToggleDownsample,
          ),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // Option 3: Image Quality Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Target Image Quality', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              Text('${(imageQuality * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary)),
            ],
          ),
          Slider(
            value: imageQuality,
            min: 0.3,
            max: 0.95,
            divisions: 13,
            activeColor: AppColors.primary,
            onChanged: onQualityChanged,
          ),

          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
            onPressed: () => Get.back(),
            child: const Text('Apply Settings', style: TextStyle(fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}
