import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/models/pdf_document_model.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import 'pdf_to_image_thumbnail_card.dart';

class PdfToImageSuccessView extends StatelessWidget {
  final PdfDocumentModel sourceDoc;
  final List<String> generatedImagePaths;
  final VoidCallback onConvertAnother;
  final VoidCallback onViewAllImages;
  final VoidCallback onShareImages;

  const PdfToImageSuccessView({
    super.key,
    required this.sourceDoc,
    required this.generatedImagePaths,
    required this.onConvertAnother,
    required this.onViewAllImages,
    required this.onShareImages,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Calculate total size of generated images
    int totalBytes = 0;
    for (final p in generatedImagePaths) {
      final f = File(p);
      if (f.existsSync()) totalBytes += f.lengthSync();
    }
    final totalSizeFormatted = PdfDocumentModel(
      id: 'images_total',
      name: 'images_total',
      path: 'images_total',
      sizeInBytes: totalBytes,
      modifiedAt: DateTime.now(),
    ).formattedSize;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.share_outlined,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
            ),
            onPressed: onShareImages,
            tooltip: 'Share',
          ),
          IconButton(
            icon: Icon(
              Icons.home_outlined,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
            ),
            onPressed: () => Get.offAllNamed(AppRoutes.home),
            tooltip: 'Home',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            children: [
              // 3D Celebration Hero Illustration
              Image.asset(
                'assets/images/pdf_to_image_success_hero.png',
                height: 135,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDCFCE7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF16A34A),
                    size: 52,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title & Subtitle
              Text(
                'Conversion Successful!',
                textAlign: TextAlign.center,
                style: AppTypography.headlineSmall.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  letterSpacing: -0.5,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Your PDF has been converted to images.',
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 13.5,
                  color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 20),

              // Summary Card (PDF -> Images)
              Container(
                padding: const EdgeInsets.all(12),
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
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
                child: Row(
                  children: [
                    // PDF Left Card
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7ED),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEE2E2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Center(
                                child: Icon(Icons.picture_as_pdf_rounded, color: AppColors.pdfRed, size: 16),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    sourceDoc.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${sourceDoc.pageCount ?? 1} pages • ${sourceDoc.formattedSize}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 10.5,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Arrow
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: Color(0xFFF97316),
                      size: 20,
                    ),
                    const SizedBox(width: 8),

                    // Images Right Card
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Center(
                                child: Icon(Icons.image_rounded, color: Color(0xFF16A34A), size: 16),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${generatedImagePaths.length} Images',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF15803D),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    totalSizeFormatted,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF166534),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Section: Converted Images & Thumbnails
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Converted Images (${generatedImagePaths.length})',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: onViewAllImages,
                    borderRadius: BorderRadius.circular(8),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      child: Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Horizontal Scrollable Thumbnail Strip
              SizedBox(
                height: 116,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: generatedImagePaths.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    return PdfToImageThumbnailCard(
                      imagePath: generatedImagePaths[index],
                      pageIndex: index + 1,
                      onTap: onViewAllImages,
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // 4 Quick Action Buttons Grid
              Row(
                children: [
                  _buildQuickAction(
                    icon: Icons.visibility_outlined,
                    label: 'View',
                    onTap: onViewAllImages,
                    isDark: isDark,
                  ),
                  const SizedBox(width: 10),
                  _buildQuickAction(
                    icon: Icons.share_outlined,
                    label: 'Share',
                    onTap: onShareImages,
                    isDark: isDark,
                  ),
                  const SizedBox(width: 10),
                  _buildQuickAction(
                    icon: Icons.folder_outlined,
                    label: 'Files',
                    onTap: () => Get.offAllNamed(AppRoutes.home),
                    isDark: isDark,
                  ),
                  const SizedBox(width: 10),
                  _buildQuickAction(
                    icon: Icons.edit_outlined,
                    label: 'Rename',
                    onTap: () {},
                    isDark: isDark,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Bottom CTA Buttons
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  elevation: 2,
                ),
                onPressed: onViewAllImages,
                icon: const Icon(Icons.image_outlined, size: 20),
                label: const Text(
                  'View All Images',
                  style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary, width: 1.5),
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                onPressed: onConvertAnother,
                icon: const Icon(Icons.add_rounded, size: 20),
                label: const Text(
                  'Convert Another PDF',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.borderDark : const Color(0xFFF1F5F9),
                width: 1.2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: AppColors.primary, size: 22),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
