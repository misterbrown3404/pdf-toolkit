import 'package:flutter/material.dart';
import '../../../shared/models/pdf_document_model.dart';
import '../../../theme/app_colors.dart';
import 'merge_doc_thumbnail.dart';

class MergeFileCard extends StatelessWidget {
  final PdfDocumentModel file;
  final int index;
  final VoidCallback onRemove;

  const MergeFileCard({
    super.key,
    required this.file,
    required this.index,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFF1F5F9),
          width: 1.2,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            // 6-Dot Drag Indicator
            Icon(
              Icons.drag_indicator_rounded,
              color: isDark ? AppColors.textSecondaryDark : const Color(0xFF94A3B8),
              size: 20,
            ),
            const SizedBox(width: 10),

            // Red PDF Document Icon Badge
            Container(
              width: 38,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.picture_as_pdf_rounded,
                    color: AppColors.pdfRed,
                    size: 18,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 1),
                    padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                    decoration: BoxDecoration(
                      color: AppColors.pdfRed,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: const Text(
                      'PDF',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 7.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // File Name & Size
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${index + 1}. ${file.name}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                      color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    file.formattedSize,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),

            // Page Count Pill Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF3B1E54) : const Color(0xFFF3E8FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${file.pageCount ?? 1} pages',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: isDark ? const Color(0xFFE9D5FF) : const Color(0xFF6B21A8),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Miniature Document Page Thumbnail
            MergeDocThumbnail(fileName: file.name),
            const SizedBox(width: 4),

            // Remove Button
            IconButton(
              icon: Icon(
                Icons.close_rounded,
                size: 18,
                color: isDark ? AppColors.textSecondaryDark : const Color(0xFF94A3B8),
              ),
              onPressed: onRemove,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              tooltip: 'Remove',
            ),
          ],
        ),
      ),
    );
  }
}
