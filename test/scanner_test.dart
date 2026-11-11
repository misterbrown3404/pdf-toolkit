import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:pdf_toolkit/app/features/scanner/models/scanned_page_model.dart';
import 'package:pdf_toolkit/app/features/scanner/scanner_controller.dart';
import 'package:pdf_toolkit/app/features/scanner/utils/scanner_filter_matrix.dart';
import 'package:pdf_toolkit/app/features/scanner/widgets/scanner_bottom_bar.dart';
import 'package:pdf_toolkit/app/features/scanner/widgets/scanner_filter_selector.dart';
import 'package:pdf_toolkit/app/features/scanner/widgets/scanner_header_banner.dart';
import 'package:pdf_toolkit/app/features/scanner/widgets/scanner_mode_selector.dart';
import 'package:pdf_toolkit/app/features/scanner/widgets/scanner_review_header.dart';
import 'package:pdf_toolkit/app/features/scanner/widgets/scanner_success_view.dart';
import 'package:pdf_toolkit/app/features/scanner/widgets/scanner_toolbar.dart';

void main() {
  group('Document Scanner Feature Tests', () {
    test('ScannedPageModel holds data and supports copyWith', () {
      final file = File('/tmp/scan_1.png');
      final page = ScannedPageModel(
        id: 'scan_1',
        file: file,
        filter: 'magic',
        rotationQuarterTurns: 0,
        capturedAt: DateTime(2026, 11, 10),
      );

      expect(page.id, 'scan_1');
      expect(page.filter, 'magic');
      expect(page.rotationQuarterTurns, 0);

      final rotated = page.copyWith(rotationQuarterTurns: 1, filter: 'bw');
      expect(rotated.rotationQuarterTurns, 1);
      expect(rotated.filter, 'bw');
      expect(rotated.id, 'scan_1');
    });

    test('ScannerFilterMatrix returns matrices for all 5 filter presets', () {
      expect(ScannerFilterMatrix.filters.length, 5);
      final ids = ScannerFilterMatrix.filters.map((f) => f.id).toList();
      expect(ids, contains('magic'));
      expect(ids, contains('original'));
      expect(ids, contains('bw'));
      expect(ids, contains('grayscale'));
      expect(ids, contains('eco'));

      expect(ScannerFilterMatrix.getFilter('magic'), isA<ColorFilter>());
      expect(ScannerFilterMatrix.getFilter('bw'), isA<ColorFilter>());
      expect(ScannerFilterMatrix.getFilter('original'), isA<ColorFilter>());
    });

    testWidgets('ScannerHeaderBanner renders title, subtitle, and responds to back', (tester) async {
      bool backTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScannerHeaderBanner(
              onBack: () => backTapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Document Scanner'), findsOneWidget);
      expect(find.text('Auto-detect document edges & enhance quality'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pump();
      expect(backTapped, isTrue);
    });

    testWidgets('ScannerModeSelector renders 4 scan modes and responds to selection', (tester) async {
      final controller = Get.put(ScannerController());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScannerModeSelector(controller: controller),
          ),
        ),
      );

      expect(find.text('Document'), findsOneWidget);
      expect(find.text('Batch Scan'), findsOneWidget);
      expect(find.text('ID Card'), findsOneWidget);
      expect(find.text('Whiteboard'), findsOneWidget);

      await tester.tap(find.text('Batch Scan'));
      await tester.pump();
      expect(controller.scanMode.value, 'batch');

      await tester.tap(find.text('ID Card'));
      await tester.pump();
      expect(controller.scanMode.value, 'id_card');

      Get.delete<ScannerController>();
    });

    testWidgets('ScannerReviewHeader displays page indicator and navigates pages', (tester) async {
      final controller = Get.put(ScannerController());
      final file = File('/tmp/dummy.png');

      controller.pages.addAll([
        ScannedPageModel(id: '1', file: file, capturedAt: DateTime.now()),
        ScannedPageModel(id: '2', file: file, capturedAt: DateTime.now()),
        ScannedPageModel(id: '3', file: file, capturedAt: DateTime.now()),
      ]);
      controller.currentPageIndex.value = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScannerReviewHeader(controller: controller),
          ),
        ),
      );

      expect(find.text('Page 1 of 3'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.chevron_right_rounded));
      await tester.pump();
      expect(controller.currentPageIndex.value, 1);
      expect(find.text('Page 2 of 3'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.chevron_left_rounded));
      await tester.pump();
      expect(controller.currentPageIndex.value, 0);

      Get.delete<ScannerController>();
    });

    testWidgets('ScannerFilterSelector updates active filter on tap', (tester) async {
      final controller = Get.put(ScannerController());
      final file = File('/tmp/dummy.png');

      controller.pages.add(
        ScannedPageModel(id: '1', file: file, filter: 'magic', capturedAt: DateTime.now()),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScannerFilterSelector(controller: controller),
          ),
        ),
      );

      expect(find.text('Magic Color'), findsOneWidget);
      expect(find.text('B&W Text'), findsOneWidget);
      expect(find.text('Grayscale'), findsOneWidget);

      await tester.tap(find.text('B&W Text'));
      await tester.pump();
      expect(controller.currentActiveFilter, 'bw');

      await tester.tap(find.text('Grayscale'));
      await tester.pump();
      expect(controller.currentActiveFilter, 'grayscale');

      Get.delete<ScannerController>();
    });

    testWidgets('ScannerToolbar rotates and deletes current page', (tester) async {
      final controller = Get.put(ScannerController());
      final file = File('/tmp/dummy.png');

      controller.pages.addAll([
        ScannedPageModel(id: 'p1', file: file, capturedAt: DateTime.now()),
        ScannedPageModel(id: 'p2', file: file, capturedAt: DateTime.now()),
      ]);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScannerToolbar(controller: controller),
          ),
        ),
      );

      expect(find.text('Rotate'), findsOneWidget);
      expect(find.text('Auto Crop'), findsOneWidget);
      expect(find.text('Retake'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);

      // Rotate page
      await tester.tap(find.text('Rotate'));
      await tester.pump();
      expect(controller.pages[0].rotationQuarterTurns, 1);

      // Delete page
      await tester.tap(find.text('Delete'));
      await tester.pump();
      expect(controller.pages.length, 1);

      Get.delete<ScannerController>();
    });

    testWidgets('ScannerBottomBar displays Save as PDF with page count', (tester) async {
      final controller = Get.put(ScannerController());
      final file = File('/tmp/dummy.png');

      controller.pages.addAll([
        ScannedPageModel(id: 'p1', file: file, capturedAt: DateTime.now()),
        ScannedPageModel(id: 'p2', file: file, capturedAt: DateTime.now()),
      ]);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScannerBottomBar(controller: controller),
          ),
        ),
      );

      expect(find.textContaining('Save as PDF (2 Pages)'), findsOneWidget);
      expect(find.byIcon(Icons.share_outlined), findsOneWidget);

      Get.delete<ScannerController>();
    });

    testWidgets('ScannerSuccessView renders summary and 4 action cards', (tester) async {
      final controller = Get.put(ScannerController());
      controller.generatedPdfPath.value = '/tmp/Scanned_Invoice.pdf';
      controller.generatedPdfSize.value = 1048576; // 1 MB
      controller.generatedPdfPages.value = 4;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScannerSuccessView(controller: controller),
          ),
        ),
      );

      expect(find.text('Document Scanned Successfully!'), findsOneWidget);
      expect(find.text('Scanned_Invoice.pdf'), findsOneWidget);
      expect(find.text('4 pages • 1.00 MB • High Quality'), findsOneWidget);
      expect(find.text('Open PDF'), findsOneWidget);
      expect(find.text('Share PDF'), findsOneWidget);
      expect(find.text('View in Files'), findsOneWidget);
      expect(find.text('Print / Export'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
      expect(find.text('Scan Another Document'), findsOneWidget);

      Get.delete<ScannerController>();
    });
  });
}

