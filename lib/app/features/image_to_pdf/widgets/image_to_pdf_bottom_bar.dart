import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class ImageToPdfBottomBar extends StatelessWidget {
  final int imageCount;
  final bool isProcessing;
  final VoidCallback onConvert;

  const ImageToPdfBottomBar({
    super.key,
    required this.imageCount,
    required this.isProcessing,
    required this.onConvert,
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
          onPressed: (imageCount > 0 && !isProcessing) ? onConvert : null,
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
                    const Icon(Icons.picture_as_pdf_rounded, size: 20, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      imageCount == 0
                          ? 'Select Images First'
                          : 'Convert to PDF ($imageCount ${imageCount == 1 ? "Image" : "Images"})',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                      ),
                    ),
                    if (imageCount > 0) ...[
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

