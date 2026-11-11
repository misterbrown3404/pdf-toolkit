import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class WatermarkBottomBar extends StatelessWidget {
  final bool hasSelectedPdf;
  final bool isProcessing;
  final VoidCallback onApply;

  const WatermarkBottomBar({
    super.key,
    required this.hasSelectedPdf,
    required this.isProcessing,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: (hasSelectedPdf && !isProcessing) ? onApply : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
            disabledForegroundColor: Colors.white60,
            elevation: 4,
            shadowColor: AppColors.primary.withValues(alpha: 0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: isProcessing
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.branding_watermark_rounded, size: 20, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      hasSelectedPdf ? 'Apply Watermark' : 'Select PDF Document First',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                      ),
                    ),
                    if (hasSelectedPdf) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.white),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
