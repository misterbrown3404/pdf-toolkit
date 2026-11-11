import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui' show Offset, Size, Rect;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart' as pw_pdf;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdfrx/pdfrx.dart' as rx;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../errors/app_exceptions.dart';
import 'file_service.dart';

class PdfService extends GetxService {
  final FileService _fileService = Get.find<FileService>();

  /// Merge multiple PDF files into a single PDF
  Future<String> mergePdfs(List<String> inputPaths) async {
    try {
      if (inputPaths.length < 2) {
        throw PdfProcessingException('Please select at least two PDF files to merge.');
      }

      final outputDoc = PdfDocument();

      for (final path in inputPaths) {
        final bytes = await File(path).readAsBytes();
        final loadedDoc = PdfDocument(inputBytes: bytes);
        for (int i = 0; i < loadedDoc.pages.count; i++) {
          final template = loadedDoc.pages[i].createTemplate();
          final page = outputDoc.pages.add();
          page.graphics.drawPdfTemplate(
            template,
            const Offset(0, 0),
            Size(page.getClientSize().width, page.getClientSize().height),
          );
        }
        loadedDoc.dispose();
      }

      final outputPath = await _fileService.generateOutputPath(prefix: 'merged');
      final outputBytes = outputDoc.saveSync();
      outputDoc.dispose();

      await File(outputPath).writeAsBytes(outputBytes);
      return outputPath;
    } catch (e) {
      throw PdfProcessingException('Failed to merge PDFs: $e');
    }
  }

  /// Split PDF into separate pages or ranges
  Future<List<String>> splitPdf(String inputPath, {List<int>? pageNumbers}) async {
    try {
      final bytes = await File(inputPath).readAsBytes();
      final sourceDoc = PdfDocument(inputBytes: bytes);
      final totalPages = sourceDoc.pages.count;
      final outputPaths = <String>[];

      final targets = pageNumbers ?? List.generate(totalPages, (i) => i + 1);

      for (final pageNum in targets) {
        if (pageNum < 1 || pageNum > totalPages) continue;

        final newDoc = PdfDocument();
        final template = sourceDoc.pages[pageNum - 1].createTemplate();
        final page = newDoc.pages.add();
        page.graphics.drawPdfTemplate(
          template,
          const Offset(0, 0),
          Size(page.getClientSize().width, page.getClientSize().height),
        );

        final outputPath = await _fileService.generateOutputPath(
          prefix: 'split_p$pageNum',
        );
        final splitBytes = newDoc.saveSync();
        newDoc.dispose();

        await File(outputPath).writeAsBytes(splitBytes);
        outputPaths.add(outputPath);
      }

      sourceDoc.dispose();
      return outputPaths;
    } catch (e) {
      throw PdfProcessingException('Failed to split PDF: $e');
    }
  }

  /// Extract a subset of pages into a single new PDF document
  Future<String> extractPages(String inputPath, List<int> pageNumbers) async {
    try {
      final bytes = await File(inputPath).readAsBytes();
      final sourceDoc = PdfDocument(inputBytes: bytes);
      final totalPages = sourceDoc.pages.count;
      final newDoc = PdfDocument();

      for (final pageNum in pageNumbers) {
        if (pageNum < 1 || pageNum > totalPages) continue;
        final template = sourceDoc.pages[pageNum - 1].createTemplate();
        final page = newDoc.pages.add();
        page.graphics.drawPdfTemplate(
          template,
          const Offset(0, 0),
          Size(page.getClientSize().width, page.getClientSize().height),
        );
      }

      final label = pageNumbers.length == 1
          ? 'p${pageNumbers.first}'
          : 'p${pageNumbers.first}_to_p${pageNumbers.last}';
      final outputPath = await _fileService.generateOutputPath(
        prefix: 'split_$label',
      );
      final splitBytes = newDoc.saveSync();
      newDoc.dispose();
      sourceDoc.dispose();

      await File(outputPath).writeAsBytes(splitBytes);
      return outputPath;
    } catch (e) {
      throw PdfProcessingException('Failed to extract PDF pages: $e');
    }
  }

  /// Convert image list to PDF
  Future<String> imagesToPdf(
    List<File> imageFiles, {
    String prefix = 'converted_images',
    List<int>? rotations,
    pw_pdf.PdfPageFormat? pageFormat,
    pw.EdgeInsets? margin,
    pw.BoxFit fit = pw.BoxFit.contain,
  }) async {
    try {
      if (imageFiles.isEmpty) {
        throw PdfProcessingException('No images provided for conversion.');
      }

      final doc = pw.Document();
      final effectivePageFormat = pageFormat ?? pw_pdf.PdfPageFormat.a4;
      final effectiveMargin = margin ?? pw.EdgeInsets.zero;

      for (int i = 0; i < imageFiles.length; i++) {
        final imgFile = imageFiles[i];
        final imageBytes = await imgFile.readAsBytes();
        final image = pw.MemoryImage(imageBytes);
        final quarterTurns = (rotations != null && i < rotations.length) ? rotations[i] : 0;

        doc.addPage(
          pw.Page(
            pageFormat: effectivePageFormat,
            margin: effectiveMargin,
            build: (pw.Context context) {
              pw.Widget content = pw.Center(
                child: pw.Image(image, fit: fit),
              );
              if (quarterTurns % 4 != 0) {
                content = pw.Transform.rotate(
                  angle: (quarterTurns % 4) * 1.5707963267948966,
                  child: content,
                );
              }
              return content;
            },
          ),
        );
      }

      final outputPath = await _fileService.generateOutputPath(prefix: prefix);
      final bytes = await doc.save();
      await File(outputPath).writeAsBytes(bytes);
      return outputPath;
    } catch (e) {
      throw PdfProcessingException('Failed to convert images to PDF: $e');
    }
  }

  /// Add text or image watermark across pages
  Future<String> addWatermark({
    required String inputPath,
    required String watermarkText,
    double opacity = 0.3,
    double rotationAngle = -45,
    double fontSize = 38,
    int red = 148,
    int green = 163,
    int blue = 184,
    String position = 'center',
    String? imageLogoPath,
  }) async {
    try {
      final bytes = await File(inputPath).readAsBytes();
      final document = PdfDocument(inputBytes: bytes);

      final font = PdfStandardFont(
        PdfFontFamily.helvetica,
        fontSize,
        style: PdfFontStyle.bold,
      );
      final alphaInt = (opacity.clamp(0.05, 0.95) * 255).toInt();
      final brush = PdfSolidBrush(PdfColor(red, green, blue, alphaInt));

      PdfBitmap? logoBitmap;
      if (imageLogoPath != null && await File(imageLogoPath).exists()) {
        final logoBytes = await File(imageLogoPath).readAsBytes();
        logoBitmap = PdfBitmap(logoBytes);
      }

      for (int i = 0; i < document.pages.count; i++) {
        final page = document.pages[i];
        final size = page.getClientSize();

        double tx = size.width / 2;
        double ty = size.height / 2;

        if (position == 'top') {
          ty = size.height * 0.25;
        } else if (position == 'bottom') {
          ty = size.height * 0.75;
        }

        page.graphics.save();
        page.graphics.translateTransform(tx, ty);
        page.graphics.rotateTransform(rotationAngle);

        if (logoBitmap != null) {
          const logoW = 160.0;
          final logoH = logoW * (logoBitmap.height / logoBitmap.width);
          page.graphics.setTransparency(opacity);
          page.graphics.drawImage(
            logoBitmap,
            Rect.fromLTWH(-logoW / 2, -logoH / 2, logoW, logoH),
          );
        } else {
          final textSize = font.measureString(watermarkText);
          page.graphics.drawString(
            watermarkText,
            font,
            brush: brush,
            bounds: Rect.fromLTWH(
              -textSize.width / 2,
              -textSize.height / 2,
              textSize.width,
              textSize.height,
            ),
          );
        }
        page.graphics.restore();
      }

      final outputPath = await _fileService.generateOutputPath(prefix: 'watermarked');
      final outputBytes = document.saveSync();
      document.dispose();

      await File(outputPath).writeAsBytes(outputBytes);
      return outputPath;
    } catch (e) {
      throw PdfProcessingException('Failed to apply watermark: $e');
    }
  }

  /// Protect PDF with a user password and AES-256 encryption
  Future<String> protectPdf({
    required String inputPath,
    required String userPassword,
    String? ownerPassword,
    bool allowPrinting = true,
    bool allowCopying = true,
  }) async {
    try {
      final bytes = await File(inputPath).readAsBytes();
      final document = PdfDocument(inputBytes: bytes);

      final security = document.security;
      security.userPassword = userPassword;
      if (ownerPassword != null && ownerPassword.isNotEmpty) {
        security.ownerPassword = ownerPassword;
      }
      security.algorithm = PdfEncryptionAlgorithm.aesx256Bit;
      security.permissions.clear();
      if (allowPrinting) {
        security.permissions.add(PdfPermissionsFlags.print);
      }
      if (allowCopying) {
        security.permissions.add(PdfPermissionsFlags.copyContent);
      }

      final outputPath = await _fileService.generateOutputPath(prefix: 'protected');
      final outputBytes = document.saveSync();
      document.dispose();

      await File(outputPath).writeAsBytes(outputBytes);
      return outputPath;
    } catch (e) {
      throw PdfProcessingException('Failed to encrypt PDF: $e');
    }
  }

  /// Unlock an encrypted PDF using its password, creating an unencrypted copy
  Future<String> unlockPdf({
    required String inputPath,
    required String password,
  }) async {
    try {
      final bytes = await File(inputPath).readAsBytes();
      final document = PdfDocument(inputBytes: bytes, password: password);

      final cleanDoc = PdfDocument();
      for (int i = 0; i < document.pages.count; i++) {
        final template = document.pages[i].createTemplate();
        final newPage = cleanDoc.pages.add();
        newPage.graphics.drawPdfTemplate(template, const Offset(0, 0));
      }

      final outputPath = await _fileService.generateOutputPath(prefix: 'unlocked');
      final outputBytes = cleanDoc.saveSync();
      cleanDoc.dispose();
      document.dispose();

      await File(outputPath).writeAsBytes(outputBytes);
      return outputPath;
    } catch (e) {
      throw PdfProcessingException('Failed to unlock PDF. Please check the password: $e');
    }
  }

  /// Compress PDF document with optimized compression levels
  Future<String> compressPdf({
    required String inputPath,
    String quality = 'medium',
  }) async {
    try {
      final bytes = await File(inputPath).readAsBytes();
      final document = PdfDocument(inputBytes: bytes);

      switch (quality.toLowerCase()) {
        case 'low':
        case 'extreme':
          document.compressionLevel = PdfCompressionLevel.best;
          break;
        case 'medium':
        case 'balanced':
          document.compressionLevel = PdfCompressionLevel.best;
          break;
        case 'high':
        case 'less':
          document.compressionLevel = PdfCompressionLevel.normal;
          break;
        default:
          document.compressionLevel = PdfCompressionLevel.best;
      }

      document.fileStructure.crossReferenceType = PdfCrossReferenceType.crossReferenceStream;
      document.fileStructure.incrementalUpdate = false;

      final outputPath = await _fileService.generateOutputPath(prefix: 'compressed');
      final outputBytes = document.saveSync();
      document.dispose();

      await File(outputPath).writeAsBytes(outputBytes);
      return outputPath;
    } catch (e) {
      throw PdfProcessingException('Failed to compress PDF: $e');
    }
  }

  /// Render PDF pages to high-resolution image files (JPG or PNG)
  Future<List<String>> renderPdfToImages({
    required String inputPath,
    String format = 'jpg',
    String quality = 'high',
    List<int>? pageNumbers,
  }) async {
    try {
      final doc = await rx.PdfDocument.openFile(inputPath);
      final totalPages = doc.pages.length;
      final targets = pageNumbers ?? List.generate(totalPages, (i) => i + 1);
      final outputPaths = <String>[];

      // Determine target render width
      double targetWidth;
      switch (quality.toLowerCase()) {
        case 'low':
          targetWidth = 720.0;
          break;
        case 'medium':
          targetWidth = 1200.0;
          break;
        case 'high':
        default:
          targetWidth = 1800.0;
          break;
      }

      final isJpg = format.toLowerCase() == 'jpg' || format.toLowerCase() == 'jpeg';
      final ext = isJpg ? 'jpg' : 'png';

      for (final pageNum in targets) {
        if (pageNum < 1 || pageNum > totalPages) continue;

        final page = doc.pages[pageNum - 1];
        final renderResult = await page.render(fullWidth: targetWidth);
        if (renderResult == null) continue;

        final uiImage = await renderResult.createImage();
        final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);
        if (byteData == null) continue;

        Uint8List imageBytes = byteData.buffer.asUint8List();

        // Compress to JPG if requested
        if (isJpg) {
          final compressQuality = quality == 'low' ? 65 : (quality == 'medium' ? 80 : 92);
          final jpgBytes = await FlutterImageCompress.compressWithList(
            imageBytes,
            quality: compressQuality,
            format: CompressFormat.jpeg,
          );
          if (jpgBytes.isNotEmpty) {
            imageBytes = Uint8List.fromList(jpgBytes);
          }
        }

        final outputPath = await _fileService.generateOutputPath(
          prefix: 'page_$pageNum',
          ext: ext,
        );
        await File(outputPath).writeAsBytes(imageBytes);
        outputPaths.add(outputPath);
      }

      await doc.dispose();
      return outputPaths;
    } catch (e) {
      throw PdfProcessingException('Failed to convert PDF to images: $e');
    }
  }

  /// Get page count & file stats
  Future<int> getPageCount(String inputPath) async {
    try {
      final bytes = await File(inputPath).readAsBytes();
      final document = PdfDocument(inputBytes: bytes);
      final count = document.pages.count;
      document.dispose();
      return count;
    } catch (e) {
      return 0;
    }
  }
}
