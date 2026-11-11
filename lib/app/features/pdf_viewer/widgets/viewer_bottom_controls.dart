import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class ViewerBottomControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onPageJump;
  final VoidCallback onPrevPage;
  final VoidCallback onNextPage;
  final VoidCallback onOpenTools;

  const ViewerBottomControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onPageJump,
    required this.onPrevPage,
    required this.onNextPage,
    required this.onOpenTools,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Zoom Out
            IconButton(
              icon: const Icon(Icons.remove_circle_outline_rounded, size: 20),
              tooltip: 'Zoom Out',
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
              onPressed: onZoomOut,
            ),

            // Previous Page Arrow
            IconButton(
              icon: const Icon(Icons.chevron_left_rounded, size: 22),
              tooltip: 'Previous Page',
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
              onPressed: currentPage > 1 ? onPrevPage : null,
            ),

            // Interactive Page Jump Pill
            GestureDetector(
              onTap: onPageJump,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEDD5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFDBA74)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.layers_outlined,
                      size: 13,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Page $currentPage of $totalPages',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFC2410C),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Next Page Arrow
            IconButton(
              icon: const Icon(Icons.chevron_right_rounded, size: 22),
              tooltip: 'Next Page',
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
              onPressed: currentPage < totalPages ? onNextPage : null,
            ),

            // Zoom In
            IconButton(
              icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
              tooltip: 'Zoom In',
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
              onPressed: onZoomIn,
            ),

            // Tools Action
            Container(
              height: 20,
              width: 1,
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              margin: const EdgeInsets.symmetric(horizontal: 4),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert_rounded, size: 20),
              tooltip: 'PDF Tools',
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
              color: AppColors.primary,
              onPressed: onOpenTools,
            ),
          ],
        ),
      ),
    );
  }
}
