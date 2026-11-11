import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../models/protect_mode_enum.dart';
import '../protect_pdf_controller.dart';

class ProtectSuccessView extends StatelessWidget {
  final ProtectPdfController controller;

  const ProtectSuccessView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isProtect = controller.mode.value == ProtectMode.protect;
    final fileName = controller.generatedPdfPath.value.split('/').last;
    final fileSizeMb = (controller.generatedPdfSize.value / (1024 * 1024)).toStringAsFixed(2);
    final pageCount = controller.generatedPdfPages.value;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        children: [
          // 3D Stamped Shield / Lock Hero Artwork
          Center(
            child: Image.asset(
              'assets/images/protect_success_hero.png',
              height: 160,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.check_circle_rounded,
                size: 80,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Green Pill Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 16),
                const SizedBox(width: 6),
                Text(
                  isProtect ? 'Password Protected' : 'Document Unlocked',
                  style: const TextStyle(
                    color: Color(0xFF15803D),
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Title & Subtitle
          Text(
            isProtect ? 'PDF Protected!' : 'PDF Unlocked!',
            textAlign: TextAlign.center,
            style: AppTypography.headlineMedium.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 22,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isProtect
                ? 'Your PDF has been secured with a password.'
                : 'Password encryption has been successfully removed.',
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),

          // Document Details Card
          Container(
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
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.picture_as_pdf_rounded,
                          color: AppColors.pdfRed,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fileName.isEmpty ? 'Project Proposal (Protected).pdf' : fileName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            pageCount > 0
                                ? '$pageCount ${pageCount == 1 ? "page" : "pages"} • $fileSizeMb MB'
                                : '$fileSizeMb MB',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isProtect ? 'Security Status' : 'Decryption Status',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_rounded, color: Color(0xFF16A34A), size: 13),
                          const SizedBox(width: 4),
                          Text(
                            isProtect ? 'AES-256 Encrypted' : 'Decrypted Clean',
                            style: const TextStyle(
                              color: Color(0xFF15803D),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Primary Button: Open PDF
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: controller.openPdf,
              icon: const Icon(Icons.visibility_outlined, size: 20),
              label: const Text(
                'Open PDF',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Action 2: Share PDF
          _buildSecondaryButton(
            icon: Icons.share_outlined,
            label: 'Share PDF',
            onTap: controller.sharePdf,
            isDark: isDark,
          ),
          const SizedBox(height: 10),

          // Action 3: Protect Another PDF
          _buildSecondaryButton(
            icon: Icons.refresh_rounded,
            label: isProtect ? 'Protect Another PDF' : 'Unlock Another PDF',
            onTap: controller.reset,
            isDark: isDark,
          ),
          const SizedBox(height: 16),

          // Back to Home Link
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => Get.offNamed(AppRoutes.home),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.arrow_back_rounded, size: 16, color: Color(0xFF64748B)),
                  SizedBox(width: 6),
                  Text(
                    'Back to Home',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18, color: isDark ? Colors.white : const Color(0xFF0F172A)),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
