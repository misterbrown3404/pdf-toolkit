import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';

class ImageToPdfSettingsCard extends StatelessWidget {
  final String orientation;
  final String pageSize;
  final String margin;
  final String fitMode;
  final Function(String) onOrientationChanged;
  final Function(String) onPageSizeChanged;
  final Function(String) onMarginChanged;
  final Function(String) onFitModeChanged;

  const ImageToPdfSettingsCard({
    super.key,
    required this.orientation,
    required this.pageSize,
    required this.margin,
    required this.fitMode,
    required this.onOrientationChanged,
    required this.onPageSizeChanged,
    required this.onMarginChanged,
    required this.onFitModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Settings Icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEDD5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'PDF Page & Layout Settings',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 1. Page Orientation (Portrait / Landscape)
          _buildSettingLabel('Page Orientation', isDark),
          const SizedBox(height: 6),
          Row(
            children: [
              _buildSegmentOption(
                label: 'Portrait',
                icon: Icons.stay_current_portrait_rounded,
                isSelected: orientation == 'portrait',
                onTap: () => onOrientationChanged('portrait'),
                isDark: isDark,
              ),
              const SizedBox(width: 8),
              _buildSegmentOption(
                label: 'Landscape',
                icon: Icons.stay_current_landscape_rounded,
                isSelected: orientation == 'landscape',
                onTap: () => onOrientationChanged('landscape'),
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 2. Page Format (A4 / Letter / Fit)
          _buildSettingLabel('Page Size', isDark),
          const SizedBox(height: 6),
          Row(
            children: [
              _buildSegmentOption(
                label: 'A4',
                isSelected: pageSize == 'a4',
                onTap: () => onPageSizeChanged('a4'),
                isDark: isDark,
              ),
              const SizedBox(width: 8),
              _buildSegmentOption(
                label: 'Letter',
                isSelected: pageSize == 'letter',
                onTap: () => onPageSizeChanged('letter'),
                isDark: isDark,
              ),
              const SizedBox(width: 8),
              _buildSegmentOption(
                label: 'Fit to Image',
                isSelected: pageSize == 'fit',
                onTap: () => onPageSizeChanged('fit'),
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 3. Margin & Image Fit
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSettingLabel('Page Margins', isDark),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _buildSegmentOption(
                          label: 'None',
                          isSelected: margin == 'none',
                          onTap: () => onMarginChanged('none'),
                          isDark: isDark,
                        ),
                        const SizedBox(width: 6),
                        _buildSegmentOption(
                          label: 'Normal',
                          isSelected: margin == 'normal',
                          onTap: () => onMarginChanged('normal'),
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSettingLabel('Image Fit', isDark),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _buildSegmentOption(
                          label: 'Fit',
                          isSelected: fitMode == 'contain',
                          onTap: () => onFitModeChanged('contain'),
                          isDark: isDark,
                        ),
                        const SizedBox(width: 6),
                        _buildSegmentOption(
                          label: 'Fill',
                          isSelected: fitMode == 'cover',
                          onTap: () => onFitModeChanged('cover'),
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingLabel(String label, bool isDark) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
      ),
    );
  }

  Widget _buildSegmentOption({
    required String label,
    IconData? icon,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? AppColors.primary.withValues(alpha: 0.25) : const Color(0xFFFFEDD5))
                : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC)),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 14,
                  color: isSelected ? AppColors.primary : const Color(0xFF64748B),
                ),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected
                      ? (isDark ? AppColors.primary : const Color(0xFFC2410C))
                      : (isDark ? AppColors.textPrimaryDark : const Color(0xFF334155)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

