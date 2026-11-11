import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';

class ViewerPageJumpDialog extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onJump;

  const ViewerPageJumpDialog({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onJump,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedPageNotifier = ValueNotifier<double>(currentPage.toDouble());

    return AlertDialog(
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      title: Row(
        children: [
          const Icon(Icons.layers_rounded, color: AppColors.primary, size: 22),
          const SizedBox(width: 10),
          Text(
            'Jump to Page',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
      content: ValueListenableBuilder<double>(
        valueListenable: selectedPageNotifier,
        builder: (context, selectedPage, _) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Page ${selectedPage.round()} of $totalPages',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              Slider.adaptive(
                value: selectedPage.clamp(1.0, totalPages.toDouble()),
                min: 1.0,
                max: totalPages.toDouble(),
                divisions: totalPages > 1 ? totalPages - 1 : 1,
                activeColor: AppColors.primary,
                onChanged: (val) => selectedPageNotifier.value = val,
              ),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
        ),
        ElevatedButton(
          onPressed: () {
            final page = selectedPageNotifier.value.round();
            Navigator.of(context).pop();
            onJump(page);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Go to Page'),
        ),
      ],
    );
  }
}
