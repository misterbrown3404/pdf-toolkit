import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../models/image_to_pdf_item_model.dart';

class ImageToPdfCardItem extends StatelessWidget {
  final ImageToPdfItemModel item;
  final int index;
  final VoidCallback onRotate;
  final VoidCallback onRemove;

  const ImageToPdfCardItem({
    super.key,
    required this.item,
    required this.index,
    required this.onRotate,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Drag handle
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(
              Icons.drag_indicator_rounded,
              size: 20,
              color: Color(0xFF94A3B8),
            ),
          ),

          // Thumbnail with active rotation
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 52,
              height: 52,
              color: const Color(0xFFF1F5F9),
              child: RotatedBox(
                quarterTurns: item.rotationQuarterTurns,
                child: Image.file(
                  item.file,
                  width: 52,
                  height: 52,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(
                      Icons.image_outlined,
                      size: 24,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Title & Size
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEDD5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Page ${index + 1}',
                        style: const TextStyle(
                          color: Color(0xFFC2410C),
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    if (item.rotationQuarterTurns % 4 != 0) ...[
                      const SizedBox(width: 6),
                      Text(
                        '${(item.rotationQuarterTurns % 4) * 90}°',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 10.5,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.formattedSize,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11.5,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),

          // Rotate Button
          IconButton(
            icon: const Icon(Icons.rotate_right_rounded, size: 20),
            color: const Color(0xFF64748B),
            tooltip: 'Rotate 90°',
            onPressed: onRotate,
          ),

          // Delete Button
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 20),
            color: Colors.redAccent.shade200,
            tooltip: 'Remove',
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}

