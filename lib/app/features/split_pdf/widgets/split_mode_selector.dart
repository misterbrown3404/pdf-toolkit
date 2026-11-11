import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class SplitModeSelector extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onSelectMode;

  const SplitModeSelector({
    super.key,
    required this.selectedIndex,
    required this.onSelectMode,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final modes = [
      {
        'title': 'Page Range',
        'sub': 'e.g. 1–5, 6–10',
        'icon': Icons.tune_rounded,
      },
      {
        'title': 'Extract All',
        'sub': 'Every single page',
        'icon': Icons.file_copy_outlined,
      },
      {
        'title': 'Fixed Interval',
        'sub': 'Every 2 pages',
        'icon': Icons.view_column_outlined,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Split Method',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (int i = 0; i < modes.length; i++) ...[
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => onSelectMode(i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                        color: selectedIndex == i
                            ? (isDark ? const Color(0xFF381F10) : const Color(0xFFFFF7ED))
                            : (isDark ? AppColors.cardDark : Colors.white),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selectedIndex == i
                              ? AppColors.primary
                              : (isDark ? AppColors.borderDark : const Color(0xFFF1F5F9)),
                          width: selectedIndex == i ? 1.5 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            modes[i]['icon'] as IconData,
                            size: 22,
                            color: selectedIndex == i
                                ? AppColors.primary
                                : (isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B)),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            modes[i]['title'] as String,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: selectedIndex == i
                                  ? AppColors.primary
                                  : (isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A)),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            modes[i]['sub'] as String,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              color: isDark ? AppColors.textSecondaryDark : const Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (i < modes.length - 1) const SizedBox(width: 8),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

