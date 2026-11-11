import 'dart:io';
import 'package:get/get.dart';
import '../../core/services/ads_service.dart';
import '../../core/services/file_service.dart';
import '../../core/services/pdf_service.dart';
import '../../core/services/storage_service.dart';
import '../../routes/app_routes.dart';
import '../../shared/models/pdf_document_model.dart';

class SplitPdfController extends GetxController {
  final FileService _fileService = Get.find<FileService>();
  final PdfService _pdfService = Get.find<PdfService>();
  final AdsService _adsService = Get.find<AdsService>();
  final StorageService _storageService = Get.find<StorageService>();

  final Rx<PdfDocumentModel?> selectedPdf = Rx<PdfDocumentModel?>(null);
  final RxInt totalPages = 10.obs;
  final RxBool isProcessing = false.obs;
  final RxInt splitMethod = 0.obs; // 0 = Range, 1 = Extract All, 2 = Fixed Interval
  final RxString pageRangeInput = '1-5, 6-10'.obs;
  final RxInt intervalPages = 2.obs;

  final RxList<PdfDocumentModel> recentFiles = <PdfDocumentModel>[].obs;
  final RxList<PdfDocumentModel> createdFiles = <PdfDocumentModel>[].obs;
  final RxBool isSuccess = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final rawRecents = _storageService.getRecentFiles();
    final models = rawRecents.map((e) => PdfDocumentModel.fromMap(e)).toList();
    recentFiles.assignAll(models);

    // If file passed via route argument
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
        selectDocument(doc);
        return;
      }
    }

    // Default to Merged_Document.pdf if available
    if (models.isNotEmpty) {
      final preferred = models.firstWhereOrNull((d) => d.name.contains('Merged')) ?? models.first;
      selectDocument(preferred);
    }
  }

  void selectDocument(PdfDocumentModel doc) async {
    selectedPdf.value = doc;
    try {
      final count = await _pdfService.getPageCount(doc.path);
      totalPages.value = count > 0 ? count : 10;
    } catch (_) {
      totalPages.value = doc.pageCount ?? 10;
    }
  }

  Future<void> pickPdf() async {
    final file = await _fileService.pickSinglePdf();
    if (file != null) {
      selectDocument(file);
    }
  }

  void setSplitMethod(int index) {
    splitMethod.value = index;
  }

  void setPageRange(String range) {
    pageRangeInput.value = range;
  }

  void setInterval(int interval) {
    intervalPages.value = interval;
  }

  int get estimatedFileCount {
    if (splitMethod.value == 1) {
      return totalPages.value;
    }
    if (splitMethod.value == 2) {
      return (totalPages.value / intervalPages.value).ceil();
    }
    // Custom range
    final parts = pageRangeInput.value.split(',').where((s) => s.trim().isNotEmpty).toList();
    return parts.isEmpty ? 2 : parts.length;
  }

  String get summaryDescription {
    if (splitMethod.value == 1) {
      return 'Pages 1 through ${totalPages.value} will each become single-page files.';
    }
    if (splitMethod.value == 2) {
      return 'Document divided into parts of ${intervalPages.value} pages each.';
    }
    return 'Dividing into ranges: ${pageRangeInput.value}';
  }

  Future<void> splitPdf() async {
    if (selectedPdf.value == null) {
      Get.snackbar('Attention', 'Please select a PDF file first.');
      return;
    }

    isProcessing.value = true;
    try {
      final srcPath = selectedPdf.value!.path;
      final results = <Map<String, dynamic>>[];

      if (splitMethod.value == 1) {
        // Extract every single page
        final out = await _pdfService.splitPdf(srcPath);
        for (final p in out) {
          results.add({'path': p, 'pages': 1});
        }
      } else if (splitMethod.value == 2) {
        // Fixed interval
        final pagesPerDoc = intervalPages.value;
        final total = totalPages.value;
        for (int start = 1; start <= total; start += pagesPerDoc) {
          final end = (start + pagesPerDoc - 1).clamp(1, total);
          final rangeList = List<int>.generate(end - start + 1, (i) => start + i);
          final out = await _pdfService.extractPages(srcPath, rangeList);
          results.add({'path': out, 'pages': rangeList.length});
        }
      } else {
        // Custom ranges (e.g. 1-5, 6-10)
        final parts = pageRangeInput.value.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
        if (parts.isEmpty) {
          final out = await _pdfService.splitPdf(srcPath);
          for (final p in out) {
            results.add({'path': p, 'pages': 1});
          }
        } else {
          for (final part in parts) {
            final pageList = <int>[];
            if (part.contains('-')) {
              final range = part.split('-');
              final start = int.tryParse(range[0].trim()) ?? 1;
              final end = int.tryParse(range[1].trim()) ?? totalPages.value;
              for (int i = start; i <= end; i++) {
                pageList.add(i);
              }
            } else {
              final p = int.tryParse(part);
              if (p != null) pageList.add(p);
            }
            if (pageList.isNotEmpty) {
              final out = await _pdfService.extractPages(srcPath, pageList);
              results.add({'path': out, 'pages': pageList.length});
            }
          }
        }
      }

      // Convert generated output paths into models
      final createdModels = <PdfDocumentModel>[];
      for (int i = 0; i < results.length; i++) {
        final item = results[i];
        final path = item['path'] as String;
        final count = item['pages'] as int;
        final f = File(path);
        final stat = await f.stat();
        final model = PdfDocumentModel(
          id: path,
          name: '${selectedPdf.value!.name.replaceAll(".pdf", "")}_part_${i + 1}.pdf',
          path: path,
          sizeInBytes: stat.size,
          modifiedAt: DateTime.now(),
          pageCount: count,
        );
        createdModels.add(model);
        await _storageService.addRecentFile(model.toMap());
      }

      createdFiles.assignAll(createdModels);
      isSuccess.value = true;

      _adsService.showInterstitialIfReady();
    } catch (e) {
      Get.snackbar('Error', 'Failed to split document: $e');
    } finally {
      isProcessing.value = false;
    }
  }

  void resetForAnother() {
    isSuccess.value = false;
    createdFiles.clear();
  }

  void openCreatedDocument(PdfDocumentModel doc) {
    Get.toNamed(
      AppRoutes.pdfViewer,
      arguments: {'path': doc.path, 'title': doc.name},
    );
  }

  Future<void> shareCreatedDocument(PdfDocumentModel doc) async {
    await _fileService.shareFile(doc.path, subject: doc.name);
  }
}
