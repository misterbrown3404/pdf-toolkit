import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class SplitRangeInput extends StatelessWidget {
  final int splitMethod;
  final int totalPages;
  final String currentInput;
  final Function(String) onRangeChanged;
  final int intervalPages;
  final Function(int) onIntervalChanged;

  const SplitRangeInput({
    super.key,
    required this.splitMethod,
    required this.totalPages,
    required this.currentInput,
    required this.onRangeChanged,
    required this.intervalPages,
    required this.onIntervalChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (splitMethod == 1) {
      // Extract All Mode
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Every page will be extracted into its own standalone PDF file ($totalPages total files).',
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.35,
                    color: isDark ? AppColors.textSecondaryDark : const Color(0xFF475569),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (splitMethod == 2) {
      // Fixed Interval Mode
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Split Interval',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [2, 3, 5].map((count) {
                final selected = intervalPages == count;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text('Every $count pages'),
                    selected: selected,
                    selectedColor: const Color(0xFFFFEDD5),
                    backgroundColor: isDark ? AppColors.cardDark : Colors.white,
                    labelStyle: TextStyle(
                      color: selected ? AppColors.primary : (isDark ? Colors.white : Colors.black87),
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 12.5,
                    ),
                    onSelected: (_) => onIntervalChanged(count),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );
    }

    // Custom Range Mode (Default)
    final presets = [
      if (totalPages >= 5) '1-5',
      if (totalPages >= 10) '6-10',
      'All Odd',
      'All Even',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Page Ranges',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),

          // Preset Chips
          Wrap(
            spacing: 8,
            children: presets.map((preset) {
              final isSelected = currentInput == preset ||
                  (preset == 'All Odd' && currentInput == 'odd') ||
                  (preset == 'All Even' && currentInput == 'even');

              return ActionChip(
                label: Text(preset),
                backgroundColor: isSelected
                    ? const Color(0xFFFFEDD5)
                    : (isDark ? AppColors.cardDark : Colors.white),
                side: BorderSide(
                  color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
                ),
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.primary : (isDark ? Colors.white : Colors.black87),
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 12,
                ),
                onPressed: () {
                  if (preset == 'All Odd') {
                    onRangeChanged('1, 3, 5, 7, 9');
                  } else if (preset == 'All Even') {
                    onRangeChanged('2, 4, 6, 8, 10');
                  } else {
                    onRangeChanged(preset);
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 10),

          // Custom Input Field
          TextFormField(
            initialValue: currentInput,
            decoration: InputDecoration(
              hintText: 'e.g. 1-5, 6-10 or 1-3, 5',
              hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
              filled: true,
              fillColor: isDark ? AppColors.cardDark : Colors.white,
              prefixIcon: const Icon(Icons.filter_list_rounded, color: AppColors.primary, size: 20),
              suffixIcon: currentInput.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () => onRangeChanged(''),
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
            onChanged: onRangeChanged,
          ),
          const SizedBox(height: 4),
          const Text(
            'Use hyphens for ranges (1-5) and commas for separate files',
            style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }
}

