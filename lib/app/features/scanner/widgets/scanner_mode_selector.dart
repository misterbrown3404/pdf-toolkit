import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../scanner_controller.dart';

class ScannerModeSelector extends StatelessWidget {
  final ScannerController controller;

  const ScannerModeSelector({
    super.key,
    required this.controller,
  });

  static const List<Map<String, dynamic>> modes = [
    {
      'id': 'document',
      'label': 'Document',
      'icon': Icons.description_outlined,
    },
    {
      'id': 'batch',
      'label': 'Batch Scan',
      'icon': Icons.burst_mode_rounded,
    },
    {
      'id': 'id_card',
      'label': 'ID Card',
      'icon': Icons.badge_outlined,
    },
    {
      'id': 'whiteboard',
      'label': 'Whiteboard',
      'icon': Icons.dashboard_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Obx(
        () => Row(
          children: modes.map((mode) {
            final id = mode['id'] as String;
            final label = mode['label'] as String;
            final icon = mode['icon'] as IconData;
            final isSelected = controller.scanMode.value == id;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => controller.setScanMode(id),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDark ? AppColors.primary : const Color(0xFFFFEDD5))
                        : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        size: 15,
                        color: isSelected
                            ? (isDark ? Colors.white : const Color(0xFFC2410C))
                            : (isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B)),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        label,
                        style: TextStyle(
                          color: isSelected
                              ? (isDark ? Colors.white : const Color(0xFFC2410C))
                              : (isDark ? AppColors.textPrimaryDark : const Color(0xFF334155)),
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

