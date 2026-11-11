import 'package:flutter/material.dart';
import '../../../shared/models/pdf_document_model.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../models/protect_mode_enum.dart';

class ProtectFileCard extends StatelessWidget {
  final PdfDocumentModel? selectedPdf;
  final ProtectMode mode;
  final VoidCallback onPickPdf;
  final VoidCallback onClearPdf;
  final List<PdfDocumentModel> recentFiles;
  final Function(PdfDocumentModel) onSelectRecent;

  const ProtectFileCard({
    super.key,
    required this.selectedPdf,
    required this.mode,
    required this.onPickPdf,
    required this.onClearPdf,
    this.recentFiles = const [],
    required this.onSelectRecent,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isProtect = mode == ProtectMode.protect;

    if (selectedPdf != null) {
      final doc = selectedPdf!;
      final pageText = doc.pageCount != null
          ? '${doc.pageCount} ${doc.pageCount == 1 ? "page" : "pages"} • '
          : '';

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(14),
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
        child: Row(
          children: [
            // PDF Document Badge
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Icon(
                  Icons.picture_as_pdf_rounded,
                  color: AppColors.pdfRed,
                  size: 26,
                ),
              ),
            ),
            const SizedBox(width: 14),

            // File Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    doc.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '$pageText${doc.formattedSize}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),

            // Change Action
            IconButton(
              icon: const Icon(Icons.swap_horiz_rounded),
              color: AppColors.primary,
              tooltip: 'Change Document',
              onPressed: onPickPdf,
            ),

            // Remove Action
            IconButton(
              icon: const Icon(Icons.close_rounded, size: 20),
              color: Colors.redAccent.shade200,
              tooltip: 'Remove',
              onPressed: onClearPdf,
            ),
          ],
        ),
      );
    }

    // Empty state card
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFFED7AA),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: isDark ? 0.08 : 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xFFFFEDD5),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFFDBA74),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Icon(
                isProtect ? Icons.lock_outline_rounded : Icons.lock_open_rounded,
                size: 28,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isProtect ? 'Select PDF to Protect' : 'Select Protected PDF to Unlock',
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isProtect
                ? 'Choose any PDF document from your device storage.'
                : 'Choose an encrypted PDF you want to permanently decrypt.',
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(
              fontSize: 12,
              color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: onPickPdf,
              icon: const Icon(Icons.folder_open_rounded, size: 18),
              label: Text(
                isProtect ? 'Choose PDF Document' : 'Choose Protected PDF',
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 2,
              ),
            ),
          ),
          if (recentFiles.isNotEmpty) ...[
            const SizedBox(height: 14),
            Row(
              children: const [
                Text(
                  'Or pick recent document:',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: recentFiles.take(3).map((doc) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => onSelectRecent(doc),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.picture_as_pdf_rounded,
                              size: 14,
                              color: AppColors.pdfRed,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              doc.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
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
          ],
        ],
      ),
    );
  }
}
