import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/models/pdf_document_model.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../files_controller.dart';

class FilesDetailsBottomSheet extends StatelessWidget {
  final PdfDocumentModel document;

  const FilesDetailsBottomSheet({
    super.key,
    required this.document,
  });

  String _formatDateTime(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final month = months[dt.month - 1];
    final hour = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$month ${dt.day}, ${dt.year} • $hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FilesController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isDark ? AppColors.surfaceDark : Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.borderDark : AppColors.borderLightMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

          // Scrollable content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                // Header with PDF Icon & Name
                Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: AppColors.pdfRed.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.picture_as_pdf_rounded,
                          color: AppColors.pdfRed,
                          size: 32,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            document.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.titleLarge.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  document.formattedSize,
                                  style: AppTypography.labelSmall.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              if (document.pageCount != null) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.1)
                                        : Colors.black.withValues(alpha: 0.06),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '${document.pageCount} Pages',
                                    style: AppTypography.labelSmall.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? AppColors.textPrimaryDark
                                          : AppColors.textPrimaryLight,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // File Details Table
                Text(
                  'File Information',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.cardLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.borderLightMuted,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow(
                        'File Type',
                        'Portable Document Format (.pdf)',
                        Icons.description_outlined,
                        isDark,
                      ),
                      const Divider(height: 16),
                      _buildInfoRow(
                        'Size in bytes',
                        '${document.sizeInBytes} bytes',
                        Icons.data_usage_rounded,
                        isDark,
                      ),
                      const Divider(height: 16),
                      _buildInfoRow(
                        'Total Pages',
                        '${document.pageCount ?? 1} pages',
                        Icons.auto_stories_outlined,
                        isDark,
                      ),
                      const Divider(height: 16),
                      _buildInfoRow(
                        'Last Modified',
                        _formatDateTime(document.modifiedAt),
                        Icons.schedule_rounded,
                        isDark,
                      ),
                      const Divider(height: 16),
                      _buildInfoRow(
                        'Security',
                        document.isEncrypted
                            ? 'AES-256 Protected'
                            : 'None (Unprotected)',
                        document.isEncrypted
                            ? Icons.lock_rounded
                            : Icons.lock_open_rounded,
                        isDark,
                        valueColor: document.isEncrypted ? Colors.teal : null,
                      ),
                      const Divider(height: 16),
                      _buildInfoRow(
                        'Location',
                        document.path,
                        Icons.folder_open_rounded,
                        isDark,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // Quick Actions
                Text(
                  'Quick Actions',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),

                _buildActionTile(
                  icon: Icons.visibility_rounded,
                  title: 'Open in Viewer',
                  color: AppColors.primary,
                  onTap: () {
                    Navigator.of(context).pop();
                    controller.openDocument(document);
                  },
                ),
                _buildActionTile(
                  icon: Icons.share_rounded,
                  title: 'Share File',
                  color: AppColors.docxBlue,
                  onTap: () {
                    Navigator.of(context).pop();
                    controller.shareDocument(document);
                  },
                ),
                _buildActionTile(
                  icon: Icons.drive_file_rename_outline_rounded,
                  title: 'Rename File',
                  color: Colors.indigo,
                  onTap: () {
                    Navigator.of(context).pop();
                    controller.showRenameDialog(context, document);
                  },
                ),
                _buildActionTile(
                  icon: Icons.copy_rounded,
                  title: 'Duplicate File',
                  color: Colors.teal,
                  onTap: () {
                    Navigator.of(context).pop();
                    controller.duplicateDocument(document);
                  },
                ),
                _buildActionTile(
                  icon: Icons.lock_rounded,
                  title: 'Protect / Lock PDF',
                  color: Colors.amber.shade800,
                  onTap: () {
                    Navigator.of(context).pop();
                    controller.openProtect(document);
                  },
                ),
                _buildActionTile(
                  icon: Icons.branding_watermark_rounded,
                  title: 'Add Watermark',
                  color: Colors.deepOrange,
                  onTap: () {
                    Navigator.of(context).pop();
                    controller.openWatermark(document);
                  },
                ),
                _buildActionTile(
                  icon: Icons.compress_rounded,
                  title: 'Compress PDF',
                  color: Colors.purple,
                  onTap: () {
                    Navigator.of(context).pop();
                    controller.openCompress(document);
                  },
                ),
                _buildActionTile(
                  icon: Icons.call_split_rounded,
                  title: 'Split PDF Pages',
                  color: Colors.blueGrey,
                  onTap: () {
                    Navigator.of(context).pop();
                    controller.openSplit(document);
                  },
                ),
                _buildActionTile(
                  icon: Icons.delete_outline_rounded,
                  title: 'Delete File',
                  color: Colors.redAccent,
                  isDestructive: true,
                  onTap: () {
                    Navigator.of(context).pop();
                    controller.showDeleteDialog(context, document);
                  },
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon,
    bool isDark, {
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
          ),
        ),
        const Spacer(),
        Expanded(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: valueColor ??
                  (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
      title: Text(
        title,
        style: AppTypography.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
          color: isDestructive ? Colors.redAccent : null,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, size: 18, color: Colors.grey),
      onTap: onTap,
    );
  }
}
