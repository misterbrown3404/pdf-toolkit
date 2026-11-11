import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/ads_service.dart';
import '../../core/services/file_service.dart';
import '../../core/services/pdf_service.dart';
import '../../core/services/storage_service.dart';
import '../../shared/models/pdf_document_model.dart';

class PdfToImageController extends GetxController {
  final FileService _fileService = Get.find<FileService>();
  final PdfService _pdfService = Get.find<PdfService>();
  final AdsService _adsService = Get.find<AdsService>();
  final StorageService _storageService = Get.find<StorageService>();

  final Rx<PdfDocumentModel?> selectedPdf = Rx<PdfDocumentModel?>(null);
  final RxString format = 'jpg'.obs; // 'jpg', 'png'
  final RxString quality = 'high'.obs; // 'low', 'medium', 'high'
  final RxBool isCustomRange = false.obs;
  final RxString customRange = '1-5'.obs;

  final RxBool isProcessing = false.obs;
  final RxBool isSuccess = false.obs;
  final RxList<PdfDocumentModel> recentFiles = <PdfDocumentModel>[].obs;
  final RxList<String> generatedImages = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final rawRecents = _storageService.getRecentFiles();
    final models = rawRecents.map((e) => PdfDocumentModel.fromMap(e)).toList();
    recentFiles.assignAll(models);

    if (Get.arguments is Map && Get.arguments['path'] != null) {
      final path = Get.arguments['path'] as String;
      final file = File(path);
      if (await file.exists()) {
        final doc = models.firstWhereOrNull((d) => d.path == path) ??
            PdfDocumentModel(
              id: path,
              name: file.uri.pathSegments.last,
              path: path,
              sizeInBytes: await file.length(),
              modifiedAt: DateTime.now(),
            );
        selectedPdf.value = doc;
      }
    } else if (models.isNotEmpty && selectedPdf.value == null) {
      selectedPdf.value = models.first;
    }
  }

  Future<void> pickPdf() async {
    final file = await _fileService.pickSinglePdf();
    if (file != null) selectedPdf.value = file;
  }

  void clearPdf() {
    selectedPdf.value = null;
  }

  void selectRecent(PdfDocumentModel doc) {
    selectedPdf.value = doc;
  }

  void setFormat(String f) => format.value = f;
  void setQuality(String q) => quality.value = q;
  void setRangeType(bool isCustom) => isCustomRange.value = isCustom;
  void setCustomRange(String r) => customRange.value = r;

  List<int>? _parseCustomPages(int total) {
    if (!isCustomRange.value) return null;
    final parts = customRange.value.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty);
    final pages = <int>{};
    for (final p in parts) {
      if (p.contains('-')) {
        final r = p.split('-');
        final start = int.tryParse(r[0].trim()) ?? 1;
        final end = int.tryParse(r[1].trim()) ?? total;
        for (int i = start; i <= end; i++) {
          if (i >= 1 && i <= total) pages.add(i);
        }
      } else {
        final pageNum = int.tryParse(p);
        if (pageNum != null && pageNum >= 1 && pageNum <= total) {
          pages.add(pageNum);
        }
      }
    }
    return pages.isNotEmpty ? pages.toList() : null;
  }

  Future<void> exportImages() async {
    final pdf = selectedPdf.value;
    if (pdf == null) {
      Get.snackbar('Select File', 'Please select a PDF document first.');
      return;
    }

    isProcessing.value = true;
    try {
      final total = pdf.pageCount ?? 1;
      final targetPages = _parseCustomPages(total);

      final images = await _pdfService.renderPdfToImages(
        inputPath: pdf.path,
        format: format.value,
        quality: quality.value,
        pageNumbers: targetPages,
      );

      if (images.isEmpty) {
        Get.snackbar('Error', 'No pages could be extracted.');
        return;
      }

      generatedImages.assignAll(images);
      isSuccess.value = true;
      _adsService.showInterstitialIfReady();
    } catch (e) {
      Get.snackbar('Error', 'Failed to export images: $e');
    } finally {
      isProcessing.value = false;
    }
  }

  void shareImages() {
    if (generatedImages.isNotEmpty) {
      _fileService.shareFile(
        generatedImages.first,
        subject: 'Exported image from ${selectedPdf.value?.name ?? "PDF"}',
      );
    }
  }

  void viewAllImages() {
    if (generatedImages.isEmpty) return;

    Get.dialog(
      Dialog.fullscreen(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Exported Images (${generatedImages.length})'),
            leading: const CloseButton(),
          ),
          body: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: generatedImages.length,
            itemBuilder: (context, index) {
              final path = generatedImages[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(path),
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void resetForAnother() {
    isSuccess.value = false;
    generatedImages.clear();
  }
}
