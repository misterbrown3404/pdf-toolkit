import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../models/protect_mode_enum.dart';

class ProtectBottomBar extends StatelessWidget {
  final ProtectMode mode;
  final bool hasSelectedPdf;
  final bool isFormValid;
  final bool isProcessing;
  final VoidCallback onAction;

  const ProtectBottomBar({
    super.key,
    required this.mode,
    required this.hasSelectedPdf,
    required this.isFormValid,
    required this.isProcessing,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isProtect = mode == ProtectMode.protect;
    final canProceed = hasSelectedPdf && isFormValid && !isProcessing;

    String buttonText;
    if (!hasSelectedPdf) {
      buttonText = isProtect ? 'Select PDF to Protect' : 'Select PDF to Unlock';
    } else if (!isFormValid) {
      buttonText = isProtect ? 'Enter Matching Passwords' : 'Enter Password to Decrypt';
    } else {
      buttonText = isProtect ? 'Protect PDF' : 'Unlock PDF';
    }

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
          onPressed: canProceed ? onAction : null,
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
                    Icon(
                      isProtect ? Icons.lock_outline_rounded : Icons.lock_open_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      buttonText,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                      ),
                    ),
                    if (canProceed) ...[
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
