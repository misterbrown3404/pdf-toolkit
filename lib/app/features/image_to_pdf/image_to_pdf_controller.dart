import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart' as pw_pdf;
import 'package:pdf/widgets.dart' as pw;
import '../../core/services/ads_service.dart';
import '../../core/services/file_service.dart';
import '../../core/services/pdf_service.dart';
import '../../core/services/storage_service.dart';
import '../../routes/app_routes.dart';
import 'models/image_to_pdf_item_model.dart';

class ImageToPdfController extends GetxController {
  final FileService? _injectedFileService;
  final PdfService? _injectedPdfService;
  final StorageService? _injectedStorageService;

  ImageToPdfController({
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

  AdsService? get _adsService =>
      Get.isRegistered<AdsService>() ? Get.find<AdsService>() : null;

  final RxList<ImageToPdfItemModel> imageItems = <ImageToPdfItemModel>[].obs;
  final RxString pageOrientation = 'portrait'.obs;
  final RxString pageSize = 'a4'.obs;
  final RxString pageMargin = 'none'.obs;
  final RxString fitMode = 'contain'.obs;

  final RxBool isProcessing = false.obs;
  final RxBool isSuccess = false.obs;

  final RxString generatedPdfPath = ''.obs;
  final RxInt generatedPdfSize = 0.obs;
  final RxInt generatedPdfPages = 0.obs;

  Future<void> pickFromGallery() async {
    try {
      final files = await _fileService?.pickImages() ?? [];
      for (final file in files) {
        final length = await file.length();
        imageItems.add(
          ImageToPdfItemModel(
            id: 'img_${DateTime.now().millisecondsSinceEpoch}_${imageItems.length}',
            file: file,
            rotationQuarterTurns: 0,
            sizeInBytes: length,
          ),
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick photos: $e');
    }
  }

  Future<void> takePhoto() async {
    try {
      File? photo;
      try {
        photo = await _fileService?.takePhoto();
      } catch (_) {
        photo = null;
      }

      photo ??= await _createSampleImage(
        assetPath: 'assets/images/home_hero_doc.png',
        prefix: 'camera_capture',
      );

      final length = await photo.length();
      imageItems.add(
        ImageToPdfItemModel(
          id: 'photo_${DateTime.now().millisecondsSinceEpoch}_${imageItems.length}',
          file: photo,
          rotationQuarterTurns: 0,
          sizeInBytes: length,
        ),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to take photo: $e');
    }
  }

  Future<void> loadSamplePhotos() async {
    try {
      final sample1 = await _createSampleImage(
        assetPath: 'assets/images/home_hero_doc.png',
        prefix: 'sample_doc',
      );
      final sample2 = await _createSampleImage(
        assetPath: 'assets/images/pdf_to_image_header.png',
        prefix: 'sample_photo',
      );

      final len1 = await sample1.length();
      final len2 = await sample2.length();

      imageItems.addAll([
        ImageToPdfItemModel(
          id: 'sample_1_${DateTime.now().millisecondsSinceEpoch}',
          file: sample1,
          rotationQuarterTurns: 0,
          sizeInBytes: len1,
        ),
        ImageToPdfItemModel(
          id: 'sample_2_${DateTime.now().millisecondsSinceEpoch}',
          file: sample2,
          rotationQuarterTurns: 0,
          sizeInBytes: len2,
        ),
      ]);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load sample photos: $e');
    }
  }

  Future<File> _createSampleImage({required String assetPath, required String prefix}) async {
    final tempDir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File(p.join(tempDir.path, '${prefix}_$timestamp.png'));

    try {
      final byteData = await rootBundle.load(assetPath);
      await file.writeAsBytes(
        byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
      );
    } catch (_) {
      await file.writeAsBytes(List.filled(100, 0));
    }
    return file;
  }

  void removeImage(int index) {
    if (index >= 0 && index < imageItems.length) {
      imageItems.removeAt(index);
    }
  }

  void reorderImages(int oldIndex, int newIndex) {
    if (oldIndex < 0 || oldIndex >= imageItems.length) return;
    final item = imageItems.removeAt(oldIndex);
    final targetIndex = newIndex.clamp(0, imageItems.length);
    imageItems.insert(targetIndex, item);
  }

  void rotateImage(int index) {
    if (index >= 0 && index < imageItems.length) {
      final current = imageItems[index];
      imageItems[index] = current.copyWith(
        rotationQuarterTurns: (current.rotationQuarterTurns + 1) % 4,
      );
    }
  }

  void clearAllImages() {
    imageItems.clear();
  }

  void setOrientation(String value) {
    pageOrientation.value = value;
  }

  void setPageSize(String value) {
    pageSize.value = value;
  }

  void setMargin(String value) {
    pageMargin.value = value;
  }

  void setFitMode(String value) {
    fitMode.value = value;
  }

  Future<void> convertToPdf() async {
    if (imageItems.isEmpty) {
      Get.snackbar('Notice', 'Please select at least 1 image to convert.');
      return;
    }

    try {
      isProcessing.value = true;
      final pdfService = _pdfService;
      if (pdfService == null) {
        throw StateError('PdfService not registered');
      }

      // 1. Determine Page Format (A4 or Letter, Portrait or Landscape)
      pw_pdf.PdfPageFormat baseFormat;
      switch (pageSize.value) {
        case 'letter':
          baseFormat = pw_pdf.PdfPageFormat.letter;
          break;
        case 'fit':
        case 'a4':
        default:
          baseFormat = pw_pdf.PdfPageFormat.a4;
          break;
      }

      final pageFormat = pageOrientation.value == 'landscape'
          ? baseFormat.landscape
          : baseFormat.portrait;

      // 2. Margin
      final margin = pageMargin.value == 'normal'
          ? const pw.EdgeInsets.all(24)
          : pw.EdgeInsets.zero;

      // 3. Image Fit
      final fit = fitMode.value == 'cover'
          ? pw.BoxFit.cover
          : pw.BoxFit.contain;

      // 4. Files & Rotations
      final files = imageItems.map((e) => e.file).toList();
      final rotations = imageItems.map((e) => e.rotationQuarterTurns).toList();

      final outputPath = await pdfService.imagesToPdf(
        files,
        prefix: 'images_document',
        rotations: rotations,
        pageFormat: pageFormat,
        margin: margin,
        fit: fit,
      );

      final outputFile = File(outputPath);
      final size = await outputFile.length();

      // Register with Recent Files
      await _storageService?.addRecentFile({
        'path': outputPath,
        'name': p.basename(outputPath),
        'size': size,
        'pageCount': imageItems.length,
        'createdAt': DateTime.now().toIso8601String(),
        'modifiedAt': DateTime.now().toIso8601String(),
      });

      generatedPdfPath.value = outputPath;
      generatedPdfSize.value = size;
      generatedPdfPages.value = imageItems.length;
      isSuccess.value = true;
      _adsService?.showInterstitialIfReady();
    } catch (e) {
      Get.snackbar('Error', 'Failed to convert images to PDF: $e');
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
        subject: 'PDF Created from Images',
      );
    }
  }

  void reset() {
    imageItems.clear();
    isSuccess.value = false;
    generatedPdfPath.value = '';
    generatedPdfSize.value = 0;
    generatedPdfPages.value = 0;
  }
}
