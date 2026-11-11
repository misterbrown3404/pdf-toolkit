import 'dart:io';
import 'dart:ui' show Rect;
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../shared/models/pdf_document_model.dart';
import '../errors/app_exceptions.dart';
import 'storage_service.dart';

class FileService extends GetxService {
  final ImagePicker _imagePicker = ImagePicker();
  final StorageService _storageService = Get.find<StorageService>();

  /// Pick one PDF file
  Future<PdfDocumentModel?> pickSinglePdf() async {
    try {
      final picked = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (picked != null && picked.path != null) {
        final file = File(picked.path!);
        final model = await _createModelFromFile(file);
        await _storageService.addRecentFile(model.toMap());
        return model;
      }
      return null;
    } catch (e) {
      throw AppException('Failed to pick PDF file: $e');
    }
  }

  /// Pick multiple PDF files
  Future<List<PdfDocumentModel>> pickMultiplePdfs() async {
    try {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (files.isNotEmpty) {
        final models = <PdfDocumentModel>[];
        for (final item in files) {
          if (item.path != null) {
            final file = File(item.path!);
            final model = await _createModelFromFile(file);
            models.add(model);
            await _storageService.addRecentFile(model.toMap());
          }
        }
        return models;
      }
      return [];
    } catch (e) {
      throw AppException('Failed to pick PDF files: $e');
    }
  }

  /// Pick multiple images from gallery
  Future<List<File>> pickImages() async {
    try {
      final images = await _imagePicker.pickMultiImage();
      return images.map((xFile) => File(xFile.path)).toList();
    } catch (e) {
      throw AppException('Failed to pick images: $e');
    }
  }

  /// Take a photo with camera
  Future<File?> takePhoto() async {
    try {
      final photo = await _imagePicker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        return File(photo.path);
      }
      return null;
    } catch (e) {
      throw AppException('Failed to take photo: $e');
    }
  }

  /// Get app output directory for processed PDFs
  Future<Directory> getOutputDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final outputDir = Directory(p.join(appDir.path, 'PdfToolkit'));
    if (!await outputDir.exists()) {
      await outputDir.create(recursive: true);
    }
    return outputDir;
  }

  /// Generate a unique output file path
  Future<String> generateOutputPath({required String prefix, String ext = 'pdf'}) async {
    final dir = await getOutputDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return p.join(dir.path, '${prefix}_$timestamp.$ext');
  }

  /// Share file via system share sheet
  Future<void> shareFile(String filePath, {String? subject}) async {
    try {
      final file = XFile(filePath);
      await SharePlus.instance.share(ShareParams(files: [file], subject: subject));
    } catch (e) {
      throw AppException('Failed to share file: $e');
    }
  }

  /// List saved files created by PdfToolkit
  Future<List<PdfDocumentModel>> getSavedDocuments() async {
    try {
      final dir = await getOutputDirectory();
      if (!await dir.exists()) return [];

      final entities = dir.listSync();
      final pdfs = <PdfDocumentModel>[];

      for (final entity in entities) {
        if (entity is File && entity.path.toLowerCase().endsWith('.pdf')) {
          final model = await _createModelFromFile(entity);
          pdfs.add(model);
        }
      }

      pdfs.sort((a, b) => b.modifiedAt.compareTo(a.modifiedAt));
      return pdfs;
    } catch (e) {
      return [];
    }
  }

  /// Delete a file and remove from recent files
  Future<bool> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
      await _storageService.removeRecentFile(filePath);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Rename a file and update records
  Future<PdfDocumentModel?> renameFile(String filePath, String newName) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return null;
      final dir = file.parent.path;
      final cleanName = newName.toLowerCase().endsWith('.pdf') ? newName : '$newName.pdf';
      final newPath = p.join(dir, cleanName);
      final renamedFile = await file.rename(newPath);
      final model = await _createModelFromFile(renamedFile);
      await _storageService.removeRecentFile(filePath);
      await _storageService.addRecentFile(model.toMap());
      return model;
    } catch (_) {
      return null;
    }
  }

  /// Duplicate a file and add copy to records
  Future<PdfDocumentModel?> duplicateFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return null;
      final dir = file.parent.path;
      final nameWithoutExt = p.basenameWithoutExtension(filePath);
      final ext = p.extension(filePath);
      final newPath = p.join(dir, '${nameWithoutExt}_copy$ext');
      final newFile = await file.copy(newPath);
      final model = await _createModelFromFile(newFile);
      await _storageService.addRecentFile(model.toMap());
      return model;
    } catch (_) {
      return null;
    }
  }

  /// Seed initial demo documents matching design mockups
  Future<void> ensureSampleDocuments() async {
    try {
      final dir = await getOutputDirectory();
      final samples = [
        {
          'name': 'Merged_Document.pdf',
          'pages': 10,
          'title': 'Merged Document - Annual Report',
          'sub': 'Comprehensive Financial & Operational Overview 2026',
        },
        {
          'name': 'Certificate.pdf',
          'pages': 3,
          'title': 'Professional Certificate of Achievement',
          'sub': 'Advanced PDF Systems & Digital Document Security',
        },
        {
          'name': 'CV.pdf',
          'pages': 2,
          'title': 'Curriculum Vitae - Senior Engineer',
          'sub': 'Experience, Qualifications, and Project Portfolio',
        },
      ];

      for (final sample in samples.reversed) {
        final name = sample['name'] as String;
        final pages = sample['pages'] as int;
        final title = sample['title'] as String;
        final sub = sample['sub'] as String;
        final file = File(p.join(dir.path, name));

        if (!await file.exists()) {
          final doc = PdfDocument();
          for (int i = 0; i < pages; i++) {
            final page = doc.pages.add();
            page.graphics.drawString(
              title,
              PdfStandardFont(PdfFontFamily.helvetica, 18, style: PdfFontStyle.bold),
              bounds: const Rect.fromLTWH(30, 40, 500, 30),
            );
            page.graphics.drawString(
              sub,
              PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.italic),
              bounds: const Rect.fromLTWH(30, 75, 500, 24),
            );
            page.graphics.drawString(
              'Page ${i + 1} of $pages\n\nGenerated with PDF Toolkit offline engine.\nThis document can be viewed, split, compressed, or converted.',
              PdfStandardFont(PdfFontFamily.helvetica, 11),
              bounds: const Rect.fromLTWH(30, 110, 500, 150),
            );
          }
          final bytes = await doc.save();
          doc.dispose();
          await file.writeAsBytes(bytes);
        }

        final model = await _createModelFromFile(file);
        await _storageService.addRecentFile(
          model.copyWith(pageCount: pages).toMap(),
        );
      }
    } catch (_) {}
  }

  Future<PdfDocumentModel> _createModelFromFile(File file) async {
    final stat = await file.stat();
    final name = p.basename(file.path);
    return PdfDocumentModel(
      id: file.path,
      name: name,
      path: file.path,
      sizeInBytes: stat.size,
      modifiedAt: stat.modified,
    );
  }
}
