import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';

class ViewerHeaderAppBar extends StatelessWidget {
  final bool isSearchOpen;
  final bool isNightMode;
  final VoidCallback onToggleSearch;
  final VoidCallback onToggleNightMode;
  final VoidCallback onOpenThumbnails;
  final VoidCallback onShare;
  final VoidCallback? onBack;

  const ViewerHeaderAppBar({
    super.key,
    required this.isSearchOpen,
    required this.isNightMode,
    required this.onToggleSearch,
    required this.onToggleNightMode,
    required this.onOpenThumbnails,
    required this.onShare,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || isNightMode;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 12, 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(22)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Circular Back Button
          Material(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onBack ?? () => Get.back(),
              child: const Padding(
                padding: EdgeInsets.all(9),
                child: Icon(
                  Icons.arrow_back_rounded,
                  size: 20,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'PDF Viewer',
                  style: AppTypography.headlineSmall.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                    color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  'Read your document',
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11.5,
                    color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),

          // Action: Search in document toggle
          _buildActionButton(
            icon: isSearchOpen ? Icons.close_rounded : Icons.search_rounded,
            tooltip: 'Search in Document',
            isActive: isSearchOpen,
            onTap: onToggleSearch,
            isDark: isDark,
          ),
          const SizedBox(width: 6),

          // Action: Night mode toggle
          _buildActionButton(
            icon: isNightMode ? Icons.light_mode_rounded : Icons.dark_mode_outlined,
            tooltip: 'Night Reading Mode',
            isActive: isNightMode,
            onTap: onToggleNightMode,
            isDark: isDark,
          ),
          const SizedBox(width: 6),

          // Action: Page thumbnails drawer
          _buildActionButton(
            icon: Icons.grid_view_rounded,
            tooltip: 'Page Thumbnails',
            isActive: false,
            onTap: onOpenThumbnails,
            isDark: isDark,
          ),
          const SizedBox(width: 6),

          // Action: Share
          _buildActionButton(
            icon: Icons.share_outlined,
            tooltip: 'Share PDF',
            isActive: false,
            onTap: onShare,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String tooltip,
    required bool isActive,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Material(
      color: isActive
          ? AppColors.primary
          : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Tooltip(
          message: tooltip,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              size: 19,
              color: isActive
                  ? Colors.white
                  : (isDark ? Colors.white : const Color(0xFF334155)),
            ),
          ),
        ),
      ),
    );
  }
}
