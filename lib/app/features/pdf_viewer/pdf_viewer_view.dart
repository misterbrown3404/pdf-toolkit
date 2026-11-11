import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdfrx/pdfrx.dart';
import '../../theme/app_colors.dart';
import 'pdf_viewer_controller.dart';
import 'widgets/viewer_bottom_controls.dart';
import 'widgets/viewer_header_app_bar.dart';
import 'widgets/viewer_meta_ribbon.dart';
import 'widgets/viewer_page_jump_dialog.dart';
import 'widgets/viewer_search_bar.dart';
import 'widgets/viewer_thumbnails_drawer.dart';
import 'widgets/viewer_tools_sheet.dart';

class PdfViewerView extends GetView<DocumentViewerController> {
  const PdfViewerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isNightMode = controller.isNightMode.value;
      final isDark = Theme.of(context).brightness == Brightness.dark || isNightMode;

      return Scaffold(
        backgroundColor: isNightMode
            ? const Color(0xFF0F172A)
            : (isDark ? AppColors.backgroundDark : const Color(0xFFF1F5F9)),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  // 1. Header Bar
                  ViewerHeaderAppBar(
                    isSearchOpen: controller.isSearchOpen.value,
                    isNightMode: isNightMode,
                    onToggleSearch: controller.toggleSearch,
                    onToggleNightMode: controller.toggleNightMode,
                    onOpenThumbnails: () => _openThumbnailsDrawer(context),
                    onShare: controller.shareCurrentPdf,
                  ),

                  // 2. Document Meta Ribbon
                  ViewerMetaRibbon(
                    fileName: controller.fileName.value,
                    fileSizeFormatted: controller.fileSizeFormatted.value,
                    currentPage: controller.currentPage.value,
                    totalPages: controller.totalPages.value,
                  ),

                  // 3. Search Bar (when active)
                  if (controller.isSearchOpen.value)
                    ViewerSearchBar(
                      searchController: controller.searchController,
                      matchCount: controller.searchMatchCount.value,
                      currentMatchIndex: controller.currentMatchIndex.value,
                      onSearchChanged: controller.onSearchTextChanged,
                      onNextMatch: controller.nextMatch,
                      onPrevMatch: controller.prevMatch,
                      onClose: controller.toggleSearch,
                    ),

                  // 4. Main PDF Viewport
                  Expanded(
                    child: controller.error.value.isNotEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Text(
                                controller.error.value,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: AppColors.pdfRed,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          )
                        : controller.filePath.value.isEmpty
                            ? const Center(
                                child: CircularProgressIndicator(color: AppColors.primary),
                              )
                            : ColorFiltered(
                                colorFilter: isNightMode
                                    ? const ColorFilter.matrix([
                                        -1, 0, 0, 0, 255, // red
                                        0, -1, 0, 0, 255, // green
                                        0, 0, -1, 0, 255, // blue
                                        0, 0, 0, 1, 0, // alpha
                                      ])
                                    : const ColorFilter.mode(
                                        Colors.transparent,
                                        BlendMode.dst,
                                      ),
                                child: PdfViewer.file(
                                  controller.filePath.value,
                                  passwordProvider: () => controller.password.value.isNotEmpty
                                      ? controller.password.value
                                      : null,
                                  params: PdfViewerParams(
                                    onViewerReady: (document, pdfController) {
                                      controller.onViewerReady(document, pdfController);
                                    },
                                    onPageChanged: (page) {
                                      controller.onPageChanged(page);
                                    },
                                    loadingBannerBuilder: (context, bytesDownloaded, totalBytes) {
                                      return const Center(
                                        child: CircularProgressIndicator(color: AppColors.primary),
                                      );
                                    },
                                    errorBannerBuilder: (context, error, stackTrace, documentRef) {
                                      return Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Text(
                                            'Failed to load document: $error',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(color: AppColors.pdfRed),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                  ),
                ],
              ),

              // 5. Floating Bottom Controls Dock
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ViewerBottomControls(
                  currentPage: controller.currentPage.value,
                  totalPages: controller.totalPages.value,
                  onZoomIn: controller.zoomIn,
                  onZoomOut: controller.zoomOut,
                  onPageJump: () => _openPageJumpDialog(context),
                  onPrevPage: controller.prevPage,
                  onNextPage: controller.nextPage,
                  onOpenTools: () => _openToolsSheet(context),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _openPageJumpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ViewerPageJumpDialog(
        currentPage: controller.currentPage.value,
        totalPages: controller.totalPages.value,
        onJump: controller.goToPage,
      ),
    );
  }

  void _openThumbnailsDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ViewerThumbnailsDrawer(
        currentPage: controller.currentPage.value,
        totalPages: controller.totalPages.value,
        onSelectPage: controller.goToPage,
      ),
    );
  }

  void _openToolsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ViewerToolsSheet(
        onSplit: controller.openSplitPdf,
        onMerge: controller.openMergePdf,
        onCompress: controller.openCompressPdf,
        onPdfToImage: controller.openPdfToImage,
        onWatermark: controller.openWatermark,
        onProtect: controller.openProtectPdf,
      ),
    );
  }
}
