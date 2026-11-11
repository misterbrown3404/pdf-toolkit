import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../models/watermark_config_model.dart';

class WatermarkSettingsCard extends StatelessWidget {
  final WatermarkConfigModel config;
  final Function(WatermarkConfigModel) onConfigChanged;
  final VoidCallback onPickLogo;

  const WatermarkSettingsCard({
    super.key,
    required this.config,
    required this.onConfigChanged,
    required this.onPickLogo,
  });

  static const List<String> textPresets = [
    'CONFIDENTIAL',
    'DRAFT',
    'SAMPLE',
    'DO NOT COPY',
    'ORIGINAL',
  ];

  static const List<Map<String, dynamic>> colorPresets = [
    {'label': 'Gray', 'color': Color(0xFF64748B)},
    {'label': 'Red', 'color': Color(0xFFEF4444)},
    {'label': 'Orange', 'color': Color(0xFFF97316)},
    {'label': 'Blue', 'color': Color(0xFF3B82F6)},
    {'label': 'Dark', 'color': Color(0xFF0F172A)},
  ];

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
          // Section Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEDD5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.branding_watermark_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Watermark Customization',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 1. Watermark Type Switcher: Text vs Image
          Row(
            children: [
              _buildTypePill(
                label: 'Text Watermark',
                icon: Icons.text_fields_rounded,
                isSelected: config.watermarkType == 'text',
                onTap: () => onConfigChanged(config.copyWith(watermarkType: 'text')),
                isDark: isDark,
              ),
              const SizedBox(width: 8),
              _buildTypePill(
                label: 'Logo Stamp',
                icon: Icons.image_rounded,
                isSelected: config.watermarkType == 'image',
                onTap: () {
                  onConfigChanged(config.copyWith(watermarkType: 'image'));
                  if (config.imageLogoPath == null) {
                    onPickLogo();
                  }
                },
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (config.watermarkType == 'text') ...[
            // Text Input
            _buildLabel('Watermark Text', isDark),
            const SizedBox(height: 6),
            TextFormField(
              initialValue: config.text,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: 'e.g. CONFIDENTIAL',
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
              onChanged: (val) => onConfigChanged(config.copyWith(text: val)),
            ),
            const SizedBox(height: 10),

            // Quick Preset Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: textPresets.map((preset) {
                  final isSelected = config.text == preset;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => onConfigChanged(config.copyWith(text: preset)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark ? AppColors.primary : const Color(0xFFFFEDD5))
                              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                          ),
                        ),
                        child: Text(
                          preset,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                            color: isSelected
                                ? (isDark ? Colors.white : const Color(0xFFC2410C))
                                : (isDark ? AppColors.textPrimaryDark : const Color(0xFF475569)),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 14),

            // Color Swatches
            _buildLabel('Stamp Color', isDark),
            const SizedBox(height: 6),
            Row(
              children: colorPresets.map((c) {
                final color = c['color'] as Color;
                final isSelected =
                    config.color.toARGB32() == color.toARGB32();

                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () => onConfigChanged(config.copyWith(color: color)),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.transparent,
                          width: 2.5,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.4),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: isSelected
                          ? const Center(
                              child: Icon(Icons.check, color: Colors.white, size: 16),
                            )
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),

            // Rotation Chips
            _buildLabel('Stamp Angle', isDark),
            const SizedBox(height: 6),
            Row(
              children: [
                _buildSegmentChip(
                  label: 'Diagonal (-45°)',
                  isSelected: (config.rotationAngle - (-45)).abs() < 1,
                  onTap: () => onConfigChanged(config.copyWith(rotationAngle: -45.0)),
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _buildSegmentChip(
                  label: 'Horizontal (0°)',
                  isSelected: config.rotationAngle.abs() < 1,
                  onTap: () => onConfigChanged(config.copyWith(rotationAngle: 0.0)),
                  isDark: isDark,
                ),
                const SizedBox(width: 8),
                _buildSegmentChip(
                  label: 'Vertical (90°)',
                  isSelected: (config.rotationAngle - 90).abs() < 1,
                  onTap: () => onConfigChanged(config.copyWith(rotationAngle: 90.0)),
                  isDark: isDark,
                ),
              ],
            ),
          ] else ...[
            // Logo Image Pick Section
            _buildLabel('Logo / Seal Image', isDark),
            const SizedBox(height: 6),
            OutlinedButton.icon(
              onPressed: onPickLogo,
              icon: const Icon(Icons.add_photo_alternate_outlined, size: 18),
              label: Text(
                config.imageLogoPath != null ? 'Change Logo Image' : 'Select Logo from Gallery',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: Color(0xFFFED7AA)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
          const SizedBox(height: 14),

          // Position Alignment
          _buildLabel('Placement Position', isDark),
          const SizedBox(height: 6),
          Row(
            children: [
              _buildSegmentChip(
                label: 'Top',
                isSelected: config.position == 'top',
                onTap: () => onConfigChanged(config.copyWith(position: 'top')),
                isDark: isDark,
              ),
              const SizedBox(width: 8),
              _buildSegmentChip(
                label: 'Center (Default)',
                isSelected: config.position == 'center',
                onTap: () => onConfigChanged(config.copyWith(position: 'center')),
                isDark: isDark,
              ),
              const SizedBox(width: 8),
              _buildSegmentChip(
                label: 'Bottom',
                isSelected: config.position == 'bottom',
                onTap: () => onConfigChanged(config.copyWith(position: 'bottom')),
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Opacity Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLabel('Watermark Opacity', isDark),
              Text(
                '${(config.opacity * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          Slider(
            value: config.opacity.clamp(0.1, 0.8),
            min: 0.1,
            max: 0.8,
            divisions: 7,
            activeColor: AppColors.primary,
            onChanged: (val) => onConfigChanged(config.copyWith(opacity: val)),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label, bool isDark) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
      ),
    );
  }

  Widget _buildTypePill({
    required String label,
    required IconData icon,
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
          padding: const EdgeInsets.symmetric(vertical: 9),
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
              Icon(
                icon,
                size: 15,
                color: isSelected ? AppColors.primary : const Color(0xFF64748B),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
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

  Widget _buildSegmentChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? AppColors.primary.withValues(alpha: 0.25) : const Color(0xFFFFEDD5))
                : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC)),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected
                    ? (isDark ? AppColors.primary : const Color(0xFFC2410C))
                    : (isDark ? AppColors.textPrimaryDark : const Color(0xFF334155)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
