import 'dart:io';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import '../../core/services/file_service.dart';
import '../../core/services/pdf_service.dart';
import '../../core/services/storage_service.dart';
import '../../routes/app_routes.dart';
import '../../shared/models/pdf_document_model.dart';
import 'models/watermark_config_model.dart';

class WatermarkController extends GetxController {
  final FileService? _injectedFileService;
  final PdfService? _injectedPdfService;
  final StorageService? _injectedStorageService;

  WatermarkController({
    FileService? fileService,
    PdfService? pdfService,
    StorageService? storageService,
  })  : _injectedFileService = fileService,
        _injectedPdfService = pdfService,
        _injectedStorageService = storageService;

  FileService? get _fileService =>
      _injectedFileService ?? (Get.isRegistered<FileService>() ? Get.find<FileService>() : null);

  PdfService? get _pdfService =>
      _injectedPdfService ?? (Get.isRegistered<PdfService>() ? Get.find<PdfService>() : null);

  StorageService? get _storageService =>
      _injectedStorageService ?? (Get.isRegistered<StorageService>() ? Get.find<StorageService>() : null);

  final Rx<PdfDocumentModel?> selectedPdf = Rx<PdfDocumentModel?>(null);
  final Rx<WatermarkConfigModel> config = const WatermarkConfigModel().obs;
  final RxList<PdfDocumentModel> recentFiles = <PdfDocumentModel>[].obs;

  final RxBool isProcessing = false.obs;
  final RxBool isSuccess = false.obs;

  final RxString generatedPdfPath = ''.obs;
  final RxInt generatedPdfSize = 0.obs;
  final RxInt generatedPdfPages = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadRecentDocuments();
  }

  Future<void> _loadRecentDocuments() async {
    try {
      if (_fileService != null) {
        await _fileService!.ensureSampleDocuments();
        final docs = await _fileService!.getSavedDocuments();
        recentFiles.assignAll(docs);

        // If a document was passed via route arguments
        if (Get.arguments is Map && Get.arguments['path'] != null) {
          final path = Get.arguments['path'] as String;
          final file = File(path);
          if (await file.exists()) {
            final doc = docs.firstWhereOrNull((d) => d.path == path) ??
                PdfDocumentModel(
                  id: path,
                  name: file.uri.pathSegments.last,
                  path: path,
                  sizeInBytes: await file.length(),
                  modifiedAt: DateTime.now(),
                );
            selectedPdf.value = doc;
          }
        } else if (docs.isNotEmpty && selectedPdf.value == null) {
          // Pre-select most recent document as convenient default
          selectedPdf.value = docs.first;
        }
      }
    } catch (_) {}
  }

  Future<void> pickPdf() async {
    try {
      final file = await _fileService?.pickSinglePdf();
      if (file != null) {
        selectedPdf.value = file;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick PDF file: $e');
    }
  }

  void selectRecentPdf(PdfDocumentModel doc) {
    selectedPdf.value = doc;
  }

  void clearPdf() {
    selectedPdf.value = null;
  }

  void updateConfig(WatermarkConfigModel newConfig) {
    config.value = newConfig;
  }

  Future<void> pickLogoImage() async {
    try {
      final images = await _fileService?.pickImages() ?? [];
      if (images.isNotEmpty) {
        config.value = config.value.copyWith(
          watermarkType: 'image',
          imageLogoPath: images.first.path,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick logo image: $e');
    }
  }

  Future<void> applyWatermark() async {
    final pdf = selectedPdf.value;
    if (pdf == null) {
      Get.snackbar('Notice', 'Please select a PDF document first.');
      return;
    }

    try {
      isProcessing.value = true;
      final pdfService = _pdfService;
      if (pdfService == null) {
        throw StateError('PdfService not registered');
      }

      final c = config.value;
      final outputPath = await pdfService.addWatermark(
        inputPath: pdf.path,
        watermarkText: c.text.trim().isEmpty ? 'CONFIDENTIAL' : c.text.trim(),
        opacity: c.opacity,
        rotationAngle: c.rotationAngle,
        fontSize: c.fontSize,
        red: (c.color.r * 255.0).round().clamp(0, 255),
        green: (c.color.g * 255.0).round().clamp(0, 255),
        blue: (c.color.b * 255.0).round().clamp(0, 255),
        position: c.position,
        imageLogoPath: c.imageLogoPath,
      );

      final outputFile = File(outputPath);
      final size = await outputFile.length();

      // Register with Recent Files
      await _storageService?.addRecentFile({
        'path': outputPath,
        'name': p.basename(outputPath),
        'size': size,
        'pageCount': pdf.pageCount ?? 1,
        'createdAt': DateTime.now().toIso8601String(),
        'modifiedAt': DateTime.now().toIso8601String(),
      });

      generatedPdfPath.value = outputPath;
      generatedPdfSize.value = size;
      generatedPdfPages.value = pdf.pageCount ?? 1;
      isSuccess.value = true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to apply watermark: $e');
    } finally {
      isProcessing.value = false;
    }
  }

  void openPdf() {
    if (generatedPdfPath.value.isNotEmpty) {
      Get.toNamed(
        AppRoutes.pdfViewer,
        arguments: {'filePath': generatedPdfPath.value},
      );
    }
  }

  Future<void> sharePdf() async {
    if (generatedPdfPath.value.isNotEmpty) {
      await _fileService?.shareFile(
        generatedPdfPath.value,
        subject: 'Watermarked PDF Document',
      );
    }
  }

  void reset() {
    isSuccess.value = false;
    generatedPdfPath.value = '';
    generatedPdfSize.value = 0;
    generatedPdfPages.value = 0;
  }
}
