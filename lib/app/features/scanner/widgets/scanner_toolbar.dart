import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../scanner_controller.dart';

class ScannerToolbar extends StatelessWidget {
  final ScannerController controller;

  const ScannerToolbar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildToolItem(
            icon: Icons.rotate_right_rounded,
            label: 'Rotate',
            onTap: controller.rotateCurrentPage,
            isDark: isDark,
          ),
          _buildToolItem(
            icon: Icons.crop_rounded,
            label: 'Auto Crop',
            onTap: controller.autoCropCurrentPage,
            isDark: isDark,
          ),
          _buildToolItem(
            icon: Icons.camera_alt_outlined,
            label: 'Retake',
            onTap: controller.retakeCurrentPage,
            isDark: isDark,
          ),
          _buildToolItem(
            icon: Icons.delete_outline_rounded,
            label: 'Delete',
            onTap: controller.deleteCurrentPage,
            isDestructive: true,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildToolItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
    required bool isDark,
  }) {
    final color = isDestructive
        ? Colors.redAccent
        : (isDark ? AppColors.textPrimaryDark : const Color(0xFF334155));

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

