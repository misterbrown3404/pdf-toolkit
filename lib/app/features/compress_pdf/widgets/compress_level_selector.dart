import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class CompressLevelSelector extends StatelessWidget {
  final String selectedLevel;
  final Function(String) onLevelSelected;

  const CompressLevelSelector({
    super.key,
    required this.selectedLevel,
    required this.onLevelSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final levels = [
      {
        'key': 'low',
        'title': 'Low',
        'sub': 'Bigger size\n(Highest quality)',
        'icon': Icons.eco_outlined,
      },
      {
        'key': 'balanced',
        'title': 'Balanced',
        'sub': 'Medium size\n(Great quality)',
        'icon': Icons.balance_rounded,
      },
      {
        'key': 'high',
        'title': 'High',
        'sub': 'Smallest size\n(Good quality)',
        'icon': Icons.bolt_rounded,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Compression Level',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: levels.map((lvl) {
              final key = lvl['key'] as String;
              final title = lvl['title'] as String;
              final sub = lvl['sub'] as String;
              final icon = lvl['icon'] as IconData;
              final isSelected = selectedLevel == key;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => onLevelSelected(key),
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isDark ? const Color(0xFF332014) : const Color(0xFFFFF7ED))
                                : (isDark ? AppColors.cardDark : Colors.white),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : (isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
                              width: isSelected ? 1.8 : 1.2,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(alpha: 0.12),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Column(
                            children: [
                              Icon(
                                icon,
                                size: 26,
                                color: isSelected ? AppColors.primary : const Color(0xFF94A3B8),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                title,
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w800,
                                  color: isSelected
                                      ? (isDark ? Colors.white : const Color(0xFFC2410C))
                                      : (isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A)),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                sub,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10.5,
                                  height: 1.25,
                                  color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Active checkmark badge
                        if (isSelected)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(Icons.check, size: 12, color: Colors.white),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

