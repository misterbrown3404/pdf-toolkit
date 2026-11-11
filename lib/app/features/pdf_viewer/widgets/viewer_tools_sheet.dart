import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';

class ViewerToolsSheet extends StatelessWidget {
  final VoidCallback onSplit;
  final VoidCallback onMerge;
  final VoidCallback onCompress;
  final VoidCallback onPdfToImage;
  final VoidCallback onWatermark;
  final VoidCallback onProtect;

  const ViewerToolsSheet({
    super.key,
    required this.onSplit,
    required this.onMerge,
    required this.onCompress,
    required this.onPdfToImage,
    required this.onWatermark,
    required this.onProtect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Row(
            children: [
              const Icon(Icons.build_circle_outlined, color: AppColors.primary, size: 22),
              const SizedBox(width: 8),
              Text(
                'Tools for this PDF',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Tools Grid
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.15,
            children: [
              _buildToolItem(
                title: 'Split PDF',
                icon: Icons.call_split_rounded,
                color: const Color(0xFFF97316),
                onTap: () {
                  Navigator.of(context).pop();
                  onSplit();
                },
                isDark: isDark,
              ),
              _buildToolItem(
                title: 'Merge PDF',
                icon: Icons.merge_type_rounded,
                color: const Color(0xFF3B82F6),
                onTap: () {
                  Navigator.of(context).pop();
                  onMerge();
                },
                isDark: isDark,
              ),
              _buildToolItem(
                title: 'Compress',
                icon: Icons.compress_rounded,
                color: const Color(0xFF10B981),
                onTap: () {
                  Navigator.of(context).pop();
                  onCompress();
                },
                isDark: isDark,
              ),
              _buildToolItem(
                title: 'PDF to Image',
                icon: Icons.image_outlined,
                color: const Color(0xFF8B5CF6),
                onTap: () {
                  Navigator.of(context).pop();
                  onPdfToImage();
                },
                isDark: isDark,
              ),
              _buildToolItem(
                title: 'Watermark',
                icon: Icons.branding_watermark_rounded,
                color: const Color(0xFFEC4899),
                onTap: () {
                  Navigator.of(context).pop();
                  onWatermark();
                },
                isDark: isDark,
              ),
              _buildToolItem(
                title: 'Protect PDF',
                icon: Icons.lock_outline_rounded,
                color: const Color(0xFFEF4444),
                onTap: () {
                  Navigator.of(context).pop();
                  onProtect();
                },
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolItem({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
