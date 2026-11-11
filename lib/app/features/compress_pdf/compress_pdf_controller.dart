import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/ads_service.dart';
import '../../core/services/file_service.dart';
import '../../core/services/pdf_service.dart';
import '../../core/services/storage_service.dart';
import '../../routes/app_routes.dart';
import '../../shared/models/pdf_document_model.dart';

class CompressPdfController extends GetxController {
  final FileService _fileService = Get.find<FileService>();
  final PdfService _pdfService = Get.find<PdfService>();
  final AdsService _adsService = Get.find<AdsService>();
  final StorageService _storageService = Get.find<StorageService>();

  final Rx<PdfDocumentModel?> selectedPdf = Rx<PdfDocumentModel?>(null);
  final RxString compressionLevel = 'balanced'.obs; // 'low', 'balanced', 'high'
  final RxBool isProcessing = false.obs;
  final RxBool isSuccess = false.obs;
  final Rx<PdfDocumentModel?> compressedDoc = Rx<PdfDocumentModel?>(null);

  final RxList<PdfDocumentModel> recentFiles = <PdfDocumentModel>[].obs;

  // Advanced Options
  final RxBool removeMetadata = true.obs;
  final RxBool downsampleImages = true.obs;
  final RxDouble imageQuality = 0.75.obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final rawRecents = _storageService.getRecentFiles();
    final models = rawRecents.map((e) => PdfDocumentModel.fromMap(e)).toList();
    recentFiles.assignAll(models);

    // If a document was passed via route arguments
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
      // Pre-select most recent document as convenient default
      selectedPdf.value = models.first;
    }
  }

  Future<void> pickPdf() async {
    final file = await _fileService.pickSinglePdf();
    if (file != null) {
      selectedPdf.value = file;
    }
  }

  void clearPdf() {
    selectedPdf.value = null;
  }

  void selectRecent(PdfDocumentModel doc) {
    selectedPdf.value = doc;
  }

  void setLevel(String level) {
    compressionLevel.value = level;
  }

  int get estimatedReductionPercent {
    switch (compressionLevel.value) {
      case 'low':
        return 28;
      case 'high':
        return 78;
      case 'balanced':
      default:
        return 68;
    }
  }

  String get estimatedCompressedSizeFormatted {
    final pdf = selectedPdf.value;
    if (pdf == null) return '0 KB';
    final factor = (100 - estimatedReductionPercent) / 100.0;
    final estimatedBytes = (pdf.sizeInBytes * factor).round();
    return PdfDocumentModel(
      id: 'estimate',
      name: 'estimate',
      path: 'estimate',
      sizeInBytes: estimatedBytes,
      modifiedAt: DateTime.now(),
    ).formattedSize;
  }

  Future<void> compress() async {
    final pdf = selectedPdf.value;
    if (pdf == null) {
      Get.snackbar('Select File', 'Please select a PDF document to compress.');
      return;
    }

    isProcessing.value = true;
    try {
      final outputPath = await _pdfService.compressPdf(
        inputPath: pdf.path,
        quality: compressionLevel.value,
      );

      final outputFile = File(outputPath);
      final stat = await outputFile.stat();
      final pageCount = await _pdfService.getPageCount(outputPath);

      final compressedModel = PdfDocumentModel(
        id: outputPath,
        name: '${pdf.name.replaceAll(".pdf", "")} (Compressed).pdf',
        path: outputPath,
        sizeInBytes: stat.size,
        modifiedAt: DateTime.now(),
        pageCount: pageCount > 0 ? pageCount : (pdf.pageCount ?? 1),
      );

      compressedDoc.value = compressedModel;
      await _storageService.addRecentFile(compressedModel.toMap());

      isSuccess.value = true;
      _adsService.showInterstitialIfReady();
    } catch (e) {
      Get.snackbar('Error', 'Failed to compress PDF: $e');
    } finally {
      isProcessing.value = false;
    }
  }

  void openCompressedFile() {
    final doc = compressedDoc.value;
    if (doc != null) {
      Get.toNamed(AppRoutes.pdfViewer, arguments: {'path': doc.path, 'title': doc.name});
    }
  }

  void shareCompressedFile() {
    final doc = compressedDoc.value;
    if (doc != null) {
      _fileService.shareFile(doc.path, subject: 'Sharing compressed document: ${doc.name}');
    }
  }

  void renameCompressedFile() {
    final doc = compressedDoc.value;
    if (doc == null) return;

    final textController = TextEditingController(text: doc.name.replaceAll('.pdf', ''));
    Get.defaultDialog(
      title: 'Rename File',
      content: TextField(
        controller: textController,
        autofocus: true,
        decoration: const InputDecoration(
          labelText: 'File Name',
          suffixText: '.pdf',
          border: OutlineInputBorder(),
        ),
      ),
      textConfirm: 'Save',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFF97316),
      onConfirm: () {
        final newName = textController.text.trim();
        if (newName.isNotEmpty) {
          compressedDoc.value = doc.copyWith(name: '$newName.pdf');
          Get.back();
        }
      },
    );
  }

  void resetForAnother() {
    isSuccess.value = false;
    compressedDoc.value = null;
  }
}
