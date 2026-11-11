import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:pdf_toolkit/app/features/image_to_pdf/image_to_pdf_controller.dart';
import 'package:pdf_toolkit/app/features/image_to_pdf/models/image_to_pdf_item_model.dart';
import 'package:pdf_toolkit/app/features/image_to_pdf/widgets/image_to_pdf_bottom_bar.dart';
import 'package:pdf_toolkit/app/features/image_to_pdf/widgets/image_to_pdf_card_item.dart';
import 'package:pdf_toolkit/app/features/image_to_pdf/widgets/image_to_pdf_header_banner.dart';
import 'package:pdf_toolkit/app/features/image_to_pdf/widgets/image_to_pdf_settings_card.dart';
import 'package:pdf_toolkit/app/features/image_to_pdf/widgets/image_to_pdf_success_view.dart';
import 'package:pdf_toolkit/app/features/image_to_pdf/widgets/image_to_pdf_upload_card.dart';

void main() {
  group('Image to PDF Feature Tests', () {
    test('ImageToPdfItemModel handles properties, formattedSize, and copyWith', () {
      final file = File('/tmp/test_photo.jpg');
      final item = ImageToPdfItemModel(
        id: 'img_1',
        file: file,
        rotationQuarterTurns: 0,
        sizeInBytes: 2097152, // 2.0 MB
      );

      expect(item.id, 'img_1');
      expect(item.formattedSize, '2.00 MB');
      expect(item.rotationQuarterTurns, 0);

      final rotated = item.copyWith(rotationQuarterTurns: 1);
      expect(rotated.rotationQuarterTurns, 1);
      expect(rotated.id, 'img_1');
      expect(rotated.formattedSize, '2.00 MB');
    });

    testWidgets('ImageToPdfHeaderBanner renders title, subtitle and responds to back', (tester) async {
      bool backTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ImageToPdfHeaderBanner(
              onBack: () => backTapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Image to PDF'), findsOneWidget);
      expect(find.text('Convert photos into a high-quality PDF'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pump();
      expect(backTapped, isTrue);
    });

    testWidgets('ImageToPdfUploadCard renders buttons and triggers callbacks', (tester) async {
      bool galleryTapped = false;
      bool cameraTapped = false;
      bool sampleTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ImageToPdfUploadCard(
              onPickGallery: () => galleryTapped = true,
              onTakePhoto: () => cameraTapped = true,
              onLoadSamples: () => sampleTapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Select Images to Convert'), findsOneWidget);
      expect(find.text('From Gallery'), findsOneWidget);
      expect(find.text('Take Photo'), findsOneWidget);
      expect(find.text('Load Sample Photos'), findsOneWidget);

      await tester.tap(find.text('From Gallery'));
      await tester.pump();
      expect(galleryTapped, isTrue);

      await tester.tap(find.text('Take Photo'));
      await tester.pump();
      expect(cameraTapped, isTrue);

      await tester.tap(find.text('Load Sample Photos'));
      await tester.pump();
      expect(sampleTapped, isTrue);
    });

    testWidgets('ImageToPdfCardItem displays page badge, size, and triggers rotate & remove', (tester) async {
      final file = File('/tmp/sample.png');
      final item = ImageToPdfItemModel(
        id: 'item_1',
        file: file,
        rotationQuarterTurns: 1, // 90°
        sizeInBytes: 1536000,
      );

      bool rotateTapped = false;
      bool removeTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ImageToPdfCardItem(
              item: item,
              index: 0,
              onRotate: () => rotateTapped = true,
              onRemove: () => removeTapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Page 1'), findsOneWidget);
      expect(find.text('90°'), findsOneWidget);
      expect(find.text('1.46 MB'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.rotate_right_rounded));
      await tester.pump();
      expect(rotateTapped, isTrue);

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pump();
      expect(removeTapped, isTrue);
    });

    testWidgets('ImageToPdfSettingsCard renders orientation, size, margin and fit options', (tester) async {
      String orientation = 'portrait';
      String pageSize = 'a4';
      String margin = 'none';
      String fitMode = 'contain';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => ImageToPdfSettingsCard(
                orientation: orientation,
                pageSize: pageSize,
                margin: margin,
                fitMode: fitMode,
                onOrientationChanged: (val) => setState(() => orientation = val),
                onPageSizeChanged: (val) => setState(() => pageSize = val),
                onMarginChanged: (val) => setState(() => margin = val),
                onFitModeChanged: (val) => setState(() => fitMode = val),
              ),
            ),
          ),
        ),
      );

      expect(find.text('PDF Page & Layout Settings'), findsOneWidget);
      expect(find.text('Portrait'), findsOneWidget);
      expect(find.text('Landscape'), findsOneWidget);
      expect(find.text('A4'), findsOneWidget);
      expect(find.text('Letter'), findsOneWidget);
      expect(find.text('Fit to Image'), findsOneWidget);

      await tester.tap(find.text('Landscape'));
      await tester.pump();
      expect(orientation, 'landscape');

      await tester.tap(find.text('Letter'));
      await tester.pump();
      expect(pageSize, 'letter');
    });

    testWidgets('ImageToPdfBottomBar displays correct state for empty vs populated count', (tester) async {
      bool convertTapped = false;

      // 1. Empty state
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ImageToPdfBottomBar(
              imageCount: 0,
              isProcessing: false,
              onConvert: () => convertTapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Select Images First'), findsOneWidget);

      // 2. Populated state
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ImageToPdfBottomBar(
              imageCount: 3,
              isProcessing: false,
              onConvert: () => convertTapped = true,
            ),
          ),
        ),
      );

      expect(find.textContaining('Convert to PDF (3 Images)'), findsOneWidget);

      await tester.tap(find.textContaining('Convert to PDF (3 Images)'));
      await tester.pump();
      expect(convertTapped, isTrue);
    });

    testWidgets('ImageToPdfSuccessView renders document summary and 4 action cards', (tester) async {
      final controller = Get.put(ImageToPdfController());
      controller.generatedPdfPath.value = '/tmp/Vacation_Photos.pdf';
      controller.generatedPdfSize.value = 3145728; // 3.0 MB
      controller.generatedPdfPages.value = 5;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ImageToPdfSuccessView(controller: controller),
          ),
        ),
      );

      expect(find.text('PDF Created From Images!'), findsOneWidget);
      expect(find.text('Vacation_Photos.pdf'), findsOneWidget);
      expect(find.text('5 pages • 3.00 MB • High Quality'), findsOneWidget);
      expect(find.text('Open PDF'), findsOneWidget);
      expect(find.text('Share PDF'), findsOneWidget);
      expect(find.text('View in Files'), findsOneWidget);
      expect(find.text('Print / Export'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
      expect(find.text('Convert More Images'), findsOneWidget);

      Get.delete<ImageToPdfController>();
    });

    test('ImageToPdfController manages items, rotations, settings and reset', () {
      final controller = Get.put(ImageToPdfController());
      final file = File('/tmp/photo_test.png');

      controller.imageItems.addAll([
        ImageToPdfItemModel(id: '1', file: file, sizeInBytes: 1000),
        ImageToPdfItemModel(id: '2', file: file, sizeInBytes: 2000),
      ]);

      expect(controller.imageItems.length, 2);

      // Rotate
      controller.rotateImage(0);
      expect(controller.imageItems[0].rotationQuarterTurns, 1);

      // Reorder
      controller.reorderImages(0, 1);
      expect(controller.imageItems[1].id, '1');

      // Remove
      controller.removeImage(0);
      expect(controller.imageItems.length, 1);

      // Settings
      controller.setOrientation('landscape');
      expect(controller.pageOrientation.value, 'landscape');

      controller.setPageSize('letter');
      expect(controller.pageSize.value, 'letter');

      // Reset
      controller.reset();
      expect(controller.imageItems.isEmpty, isTrue);
      expect(controller.isSuccess.value, isFalse);

      Get.delete<ImageToPdfController>();
    });
  });
}

