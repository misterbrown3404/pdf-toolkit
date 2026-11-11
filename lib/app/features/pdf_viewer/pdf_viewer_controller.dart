import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:pdfrx/pdfrx.dart';
import '../../core/services/file_service.dart';
import '../../routes/app_routes.dart';

class DocumentViewerController extends GetxController {
  final FileService? _injectedFileService;

  DocumentViewerController({FileService? fileService})
      : _injectedFileService = fileService;

  FileService? get _fileService =>
      _injectedFileService ?? (Get.isRegistered<FileService>() ? Get.find<FileService>() : null);

  final RxString filePath = ''.obs;
  final RxString fileName = 'Document.pdf'.obs;
  final RxString fileSizeFormatted = ''.obs;

  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;

  final RxBool isNightMode = false.obs;
  final RxBool isSearchOpen = false.obs;

  late final TextEditingController searchController;
  final RxInt searchMatchCount = 0.obs;
  final RxInt currentMatchIndex = 0.obs;

  final RxString password = ''.obs;
  late final TextEditingController passwordController;
  final RxBool isPasswordRequired = false.obs;

  PdfViewerController? pdfViewerController;
  PdfTextSearcher? textSearcher;

  @override
  void onInit() {
    super.onInit();
    searchController = TextEditingController();
    passwordController = TextEditingController();

    final args = Get.arguments as Map<String, dynamic>?;
    final path = args?['filePath'] ?? args?['path'] ?? '';
    final initialPwd = args?['password'] as String?;

    if (initialPwd != null && initialPwd.isNotEmpty) {
      password.value = initialPwd;
      passwordController.text = initialPwd;
    }

    if (path != null && path.toString().isNotEmpty) {
      filePath.value = path.toString();
      _loadDocumentMetadata();
    } else {
      _loadFallbackSample();
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    passwordController.dispose();
    textSearcher?.dispose();
    super.onClose();
  }

  Future<void> _loadFallbackSample() async {
    try {
      if (_fileService != null) {
        await _fileService!.ensureSampleDocuments();
        final docs = await _fileService!.getSavedDocuments();
        if (docs.isNotEmpty) {
          filePath.value = docs.first.path;
          _loadDocumentMetadata();
          return;
        }
      }
    } catch (_) {}
    error.value = 'No PDF file path provided';
    isLoading.value = false;
  }

  Future<void> _loadDocumentMetadata() async {
    try {
      final file = File(filePath.value);
      fileName.value = p.basename(filePath.value);
      if (await file.exists()) {
        final length = await file.length();
        if (length < 1024 * 1024) {
          fileSizeFormatted.value = '${(length / 1024).toStringAsFixed(1)} KB';
        } else {
          fileSizeFormatted.value = '${(length / (1024 * 1024)).toStringAsFixed(1)} MB';
        }
      }
    } catch (_) {}
  }

  void onViewerReady(PdfDocument document, PdfViewerController controller) {
    pdfViewerController = controller;
    totalPages.value = document.pages.length;
    isLoading.value = false;

    // Attach searcher
    try {
      textSearcher = PdfTextSearcher(controller)
        ..addListener(() {
          searchMatchCount.value = textSearcher?.matches.length ?? 0;
          currentMatchIndex.value = textSearcher?.currentIndex ?? 0;
        });
    } catch (_) {}
  }

  void onPageChanged(int? page) {
    if (page != null) {
      currentPage.value = page;
    }
  }

  void toggleNightMode() {
    isNightMode.value = !isNightMode.value;
  }

  void toggleSearch() {
    isSearchOpen.value = !isSearchOpen.value;
    if (!isSearchOpen.value) {
      searchController.clear();
      textSearcher?.resetTextSearch();
      searchMatchCount.value = 0;
      currentMatchIndex.value = 0;
    }
  }

  void onSearchTextChanged(String query) {
    if (query.trim().isEmpty) {
      textSearcher?.resetTextSearch();
      searchMatchCount.value = 0;
      currentMatchIndex.value = 0;
    } else {
      textSearcher?.startTextSearch(query.trim());
    }
  }

  void nextMatch() {
    textSearcher?.goToNextMatch();
  }

  void prevMatch() {
    textSearcher?.goToPrevMatch();
  }

  void zoomIn() {
    if (pdfViewerController != null && pdfViewerController!.isReady) {
      final next = pdfViewerController!.getNextZoom();
      pdfViewerController!.goTo(
        pdfViewerController!.calcMatrixFor(pdfViewerController!.centerPosition, zoom: next),
      );
    }
  }

  void zoomOut() {
    if (pdfViewerController != null && pdfViewerController!.isReady) {
      final prev = pdfViewerController!.getPreviousZoom();
      pdfViewerController!.goTo(
        pdfViewerController!.calcMatrixFor(pdfViewerController!.centerPosition, zoom: prev),
      );
    }
  }

  void goToPage(int page) {
    final target = page.clamp(1, totalPages.value);
    pdfViewerController?.goToPage(pageNumber: target);
    currentPage.value = target;
  }

  void nextPage() {
    if (currentPage.value < totalPages.value) {
      goToPage(currentPage.value + 1);
    }
  }

  void prevPage() {
    if (currentPage.value > 1) {
      goToPage(currentPage.value - 1);
    }
  }

  Future<void> shareCurrentPdf() async {
    if (filePath.value.isNotEmpty) {
      await _fileService?.shareFile(filePath.value, subject: fileName.value);
    }
  }

  // Tool Shortcuts
  void openSplitPdf() {
    Get.toNamed(AppRoutes.splitPdf, arguments: {'path': filePath.value});
  }

  void openMergePdf() {
    Get.toNamed(AppRoutes.mergePdf, arguments: {'path': filePath.value});
  }

  void openCompressPdf() {
    Get.toNamed(AppRoutes.compressPdf, arguments: {'path': filePath.value});
  }

  void openPdfToImage() {
    Get.toNamed(AppRoutes.pdfToImage, arguments: {'path': filePath.value});
  }

  void openWatermark() {
    Get.toNamed(AppRoutes.watermark, arguments: {'path': filePath.value});
  }

  void openProtectPdf() {
    Get.toNamed(AppRoutes.protectPdf, arguments: {'path': filePath.value});
  }
}
