import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class PdfToImageSettingsCard extends StatelessWidget {
  final String format; // 'jpg' or 'png'
  final ValueChanged<String> onFormatChanged;
  final String quality; // 'low', 'medium', 'high'
  final ValueChanged<String> onQualityChanged;
  final bool isCustomRange;
  final ValueChanged<bool> onRangeTypeChanged;
  final int totalPages;
  final String customRange;
  final ValueChanged<String> onCustomRangeChanged;

  const PdfToImageSettingsCard({
    super.key,
    required this.format,
    required this.onFormatChanged,
    required this.quality,
    required this.onQualityChanged,
    required this.isCustomRange,
    required this.onRangeTypeChanged,
    required this.totalPages,
    required this.customRange,
    required this.onCustomRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Conversion Settings',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),

          // Setting 1: Output Format (JPG / PNG)
          _buildCard(
            isDark: isDark,
            child: Row(
              children: [
                _buildIconContainer(Icons.image_outlined),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Output Format',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildPillOption(
                        label: 'JPG',
                        isSelected: format.toLowerCase() == 'jpg',
                        onTap: () => onFormatChanged('jpg'),
                      ),
                      _buildPillOption(
                        label: 'PNG',
                        isSelected: format.toLowerCase() == 'png',
                        onTap: () => onFormatChanged('png'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Setting 2: Image Quality (Low / Medium / High)
          _buildCard(
            isDark: isDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildIconContainer(Icons.layers_outlined),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Image Quality',
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Higher quality gives larger file size',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildSegmentButton(
                        label: 'Low',
                        isSelected: quality == 'low',
                        onTap: () => onQualityChanged('low'),
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildSegmentButton(
                        label: 'Medium',
                        isSelected: quality == 'medium',
                        onTap: () => onQualityChanged('medium'),
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildSegmentButton(
                        label: 'High',
                        isSelected: quality == 'high',
                        onTap: () => onQualityChanged('high'),
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Setting 3: Page Range
          _buildCard(
            isDark: isDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildIconContainer(Icons.description_outlined),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Page Range',
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Choose which pages to convert',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => onRangeTypeChanged(false),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: !isCustomRange
                                ? (isDark ? const Color(0xFF332014) : const Color(0xFFFFF7ED))
                                : (isDark ? AppColors.surfaceDark : Colors.white),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: !isCustomRange
                                  ? AppColors.primary
                                  : (isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
                              width: !isCustomRange ? 1.5 : 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'All Pages ($totalPages)',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: !isCustomRange
                                    ? AppColors.primary
                                    : (isDark ? Colors.white : const Color(0xFF0F172A)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () => onRangeTypeChanged(true),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isCustomRange
                                ? (isDark ? const Color(0xFF332014) : const Color(0xFFFFF7ED))
                                : (isDark ? AppColors.surfaceDark : Colors.white),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isCustomRange
                                  ? AppColors.primary
                                  : (isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
                              width: isCustomRange ? 1.5 : 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Custom Range',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isCustomRange
                                    ? AppColors.primary
                                    : (isDark ? Colors.white : const Color(0xFF0F172A)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Custom Range Input if enabled
                if (isCustomRange) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    children: [
                      if (totalPages >= 5) '1-5',
                      if (totalPages >= 10) '6-10',
                      'All Odd',
                      'All Even',
                    ].map((preset) {
                      return ActionChip(
                        label: Text(preset, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                        backgroundColor: customRange == preset
                            ? const Color(0xFFFFEDD5)
                            : (isDark ? AppColors.cardDark : Colors.white),
                        side: BorderSide(
                          color: customRange == preset ? AppColors.primary : const Color(0xFFE2E8F0),
                        ),
                        onPressed: () {
                          if (preset == 'All Odd') {
                            onCustomRangeChanged('1, 3, 5, 7, 9');
                          } else if (preset == 'All Even') {
                            onCustomRangeChanged('2, 4, 6, 8, 10');
                          } else {
                            onCustomRangeChanged(preset);
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: customRange,
                    onChanged: onCustomRangeChanged,
                    decoration: InputDecoration(
                      hintText: 'e.g. 1-3, 5',
                      prefixIcon: const Icon(Icons.filter_list_rounded, size: 20, color: AppColors.primary),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child, required bool isDark}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFF1F5F9),
          width: 1.2,
        ),
      ),
      child: child,
    );
  }

  Widget _buildIconContainer(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFFFEDD5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: AppColors.primary, size: 22),
    );
  }

  Widget _buildPillOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
            color: isSelected ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : (isDark ? AppColors.surfaceDark : const Color(0xFFF8FAFC)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : (isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF475569)),
            ),
          ),
        ),
      ),
    );
  }
}

