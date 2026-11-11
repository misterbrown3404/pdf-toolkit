import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../models/image_to_pdf_item_model.dart';
import 'image_to_pdf_card_item.dart';

class ImageToPdfCardList extends StatelessWidget {
  final List<ImageToPdfItemModel> items;
  final Function(int oldIndex, int newIndex) onReorder;
  final Function(int index) onRotate;
  final Function(int index) onRemove;
  final VoidCallback onAddMoreGallery;
  final VoidCallback onAddMoreCamera;
  final VoidCallback onClearAll;

  const ImageToPdfCardList({
    super.key,
    required this.items,
    required this.onReorder,
    required this.onRotate,
    required this.onRemove,
    required this.onAddMoreGallery,
    required this.onAddMoreCamera,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header: Count, Drag hint, Clear All
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Selected Images (${items.length})',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '• Hold to reorder',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
              InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: onClearAll,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.redAccent.shade200,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Reorderable Card List
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          itemCount: items.length,
          onReorderItem: onReorder,
          itemBuilder: (context, index) {
            final item = items[index];
            return ImageToPdfCardItem(
              key: ValueKey(item.id),
              item: item,
              index: index,
              onRotate: () => onRotate(index),
              onRemove: () => onRemove(index),
            );
          },
        ),

        // Add More Photos row
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onAddMoreGallery,
                  icon: const Icon(Icons.add_photo_alternate_outlined, size: 16),
                  label: const Text(
                    'Add Photos',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: Color(0xFFFED7AA)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onAddMoreCamera,
                  icon: const Icon(Icons.camera_alt_outlined, size: 16),
                  label: const Text(
                    'Take Photo',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark ? Colors.white : const Color(0xFF334155),
                    side: BorderSide(
                      color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
