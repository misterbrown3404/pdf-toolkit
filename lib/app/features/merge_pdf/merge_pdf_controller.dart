import 'dart:io';
import 'package:get/get.dart';
import '../../core/services/ads_service.dart';
import '../../core/services/file_service.dart';
import '../../core/services/pdf_service.dart';
import '../../core/services/storage_service.dart';
import '../../routes/app_routes.dart';
import '../../shared/models/pdf_document_model.dart';

class MergePdfController extends GetxController {
  final FileService _fileService = Get.find<FileService>();
  final PdfService _pdfService = Get.find<PdfService>();
  final AdsService _adsService = Get.find<AdsService>();
  final StorageService _storageService = Get.find<StorageService>();

  final RxList<PdfDocumentModel> selectedFiles = <PdfDocumentModel>[].obs;
  final RxBool isProcessing = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialFiles();
  }

  Future<void> _loadInitialFiles() async {
    if (Get.arguments is List<PdfDocumentModel>) {
      selectedFiles.assignAll(Get.arguments as List<PdfDocumentModel>);
    } else {
      final recents = _storageService.getRecentFiles().map((e) => PdfDocumentModel.fromMap(e)).toList();
      if (recents.length >= 2) {
        selectedFiles.assignAll(recents.take(3));
      }
    }
  }

  Future<void> pickPdfs() async {
    final files = await _fileService.pickMultiplePdfs();
    if (files.isNotEmpty) {
      selectedFiles.addAll(files);
    }
  }

  void removeFile(int index) {
    if (index >= 0 && index < selectedFiles.length) {
      selectedFiles.removeAt(index);
    }
  }

  void reorderFiles(int oldIndex, int newIndex) {
    if (oldIndex < selectedFiles.length && newIndex <= selectedFiles.length) {
      final item = selectedFiles.removeAt(oldIndex);
      selectedFiles.insert(newIndex, item);
    }
  }

  Future<void> mergePdfs() async {
    if (selectedFiles.length < 2) {
      Get.snackbar('Attention', 'Please add at least 2 PDF files to merge.');
      return;
    }

    isProcessing.value = true;
    try {
      final paths = selectedFiles.map((doc) => doc.path).toList();
      final outputPath = await _pdfService.mergePdfs(paths);

      // Save to recent files
      final file = File(outputPath);
      final stat = await file.stat();
      final totalPages = selectedFiles.fold<int>(0, (sum, doc) => sum + (doc.pageCount ?? 1));

      final newDoc = PdfDocumentModel(
        id: outputPath,
        name: 'Merged_${DateTime.now().millisecondsSinceEpoch}.pdf',
        path: outputPath,
        sizeInBytes: stat.size,
        modifiedAt: DateTime.now(),
        pageCount: totalPages,
      );
      await _storageService.addRecentFile(newDoc.toMap());

      _adsService.showInterstitialIfReady(onDismissed: () {
        Get.offNamed(
          AppRoutes.pdfViewer,
          arguments: {
            'path': outputPath,
            'title': 'Merged Document',
          },
        );
      });
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isProcessing.value = false;
    }
  }
}
