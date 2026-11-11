import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:pdf_toolkit/app/features/watermark/models/watermark_config_model.dart';
import 'package:pdf_toolkit/app/features/watermark/watermark_controller.dart';
import 'package:pdf_toolkit/app/features/watermark/widgets/watermark_bottom_bar.dart';
import 'package:pdf_toolkit/app/features/watermark/widgets/watermark_file_card.dart';
import 'package:pdf_toolkit/app/features/watermark/widgets/watermark_header_banner.dart';
import 'package:pdf_toolkit/app/features/watermark/widgets/watermark_preview_card.dart';
import 'package:pdf_toolkit/app/features/watermark/widgets/watermark_settings_card.dart';
import 'package:pdf_toolkit/app/features/watermark/widgets/watermark_success_view.dart';
import 'package:pdf_toolkit/app/shared/models/pdf_document_model.dart';

void main() {
  group('Watermark Feature Tests', () {
    test('WatermarkConfigModel has correct defaults and copyWith updates', () {
      const config = WatermarkConfigModel();

      expect(config.text, 'CONFIDENTIAL');
      expect(config.opacity, 0.25);
      expect(config.rotationAngle, -45.0);
      expect(config.fontSize, 38.0);
      expect(config.position, 'center');
      expect(config.imageLogoPath, isNull);

      final updated = config.copyWith(
        text: 'TOP SECRET',
        opacity: 0.5,
        rotationAngle: 0.0,
        fontSize: 48.0,
        color: const Color(0xFFEF4444),
        position: 'top',
        imageLogoPath: '/tmp/logo.png',
      );

      expect(updated.text, 'TOP SECRET');
      expect(updated.opacity, 0.5);
      expect(updated.rotationAngle, 0.0);
      expect(updated.fontSize, 48.0);
      expect(updated.color.toARGB32(), const Color(0xFFEF4444).toARGB32());
      expect(updated.position, 'top');
      expect(updated.imageLogoPath, '/tmp/logo.png');
    });

    testWidgets('WatermarkHeaderBanner renders title, subtitle and triggers back', (tester) async {
      bool backPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WatermarkHeaderBanner(
              onBack: () => backPressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Add Watermark'), findsOneWidget);
      expect(find.text('Stamp custom text or seals across pages'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pump();
      expect(backPressed, isTrue);
    });

    testWidgets('WatermarkFileCard displays empty state and pick action', (tester) async {
      bool pickTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WatermarkFileCard(
              selectedPdf: null,
              onPickPdf: () => pickTapped = true,
              onClearPdf: () {},
              recentFiles: const [],
              onSelectRecent: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Select PDF to Watermark'), findsOneWidget);
      expect(find.text('Choose any PDF document from your device storage.'), findsOneWidget);
      expect(find.text('Choose PDF Document'), findsOneWidget);

      await tester.tap(find.text('Choose PDF Document'));
      await tester.pump();
      expect(pickTapped, isTrue);
    });

    testWidgets('WatermarkFileCard displays selected file details and triggers remove', (tester) async {
      bool clearTapped = false;
      final pdf = PdfDocumentModel(
        id: 'pdf_test',
        name: 'Annual_Report.pdf',
        path: '/tmp/Annual_Report.pdf',
        sizeInBytes: 2097152,
        pageCount: 14,
        modifiedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WatermarkFileCard(
              selectedPdf: pdf,
              onPickPdf: () {},
              onClearPdf: () => clearTapped = true,
              recentFiles: const [],
              onSelectRecent: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Annual_Report.pdf'), findsOneWidget);
      expect(find.text('14 pages • 2.00 MB'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pump();
      expect(clearTapped, isTrue);
    });

    testWidgets('WatermarkPreviewCard renders live preview with config text', (tester) async {
      const config = WatermarkConfigModel(
        text: 'FOR INTERNAL USE ONLY',
        rotationAngle: -45,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WatermarkPreviewCard(
              config: config,
            ),
          ),
        ),
      );

      expect(find.text('Live Page Preview'), findsOneWidget);
      expect(find.text('Page 1 of Document'), findsOneWidget);
      expect(find.text('FOR INTERNAL USE ONLY'), findsWidgets);
    });

    testWidgets('WatermarkSettingsCard allows changing watermark presets and text', (tester) async {
      WatermarkConfigModel currentConfig = const WatermarkConfigModel();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => WatermarkSettingsCard(
                config: currentConfig,
                onPickLogo: () {},
                onConfigChanged: (newConfig) {
                  setState(() => currentConfig = newConfig);
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Watermark Customization'), findsOneWidget);
      expect(find.text('CONFIDENTIAL'), findsWidgets);
      expect(find.text('DRAFT'), findsOneWidget);
      expect(find.text('SAMPLE'), findsOneWidget);
      expect(find.text('DO NOT COPY'), findsOneWidget);

      // Tap DRAFT chip
      await tester.tap(find.text('DRAFT'));
      await tester.pump();
      expect(currentConfig.text, 'DRAFT');

      // Tap Angle 0°
      await tester.tap(find.text('Horizontal (0°)'));
      await tester.pump();
      expect(currentConfig.rotationAngle, 0.0);
    });

    testWidgets('WatermarkBottomBar changes state based on document presence', (tester) async {
      bool applyTapped = false;

      // 1. Without file
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WatermarkBottomBar(
              hasSelectedPdf: false,
              isProcessing: false,
              onApply: () => applyTapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Select PDF Document First'), findsOneWidget);

      // 2. With file
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WatermarkBottomBar(
              hasSelectedPdf: true,
              isProcessing: false,
              onApply: () => applyTapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Apply Watermark'), findsOneWidget);
      await tester.tap(find.text('Apply Watermark'));
      await tester.pump();
      expect(applyTapped, isTrue);
    });

    testWidgets('WatermarkSuccessView displays summary and all action buttons', (tester) async {
      final controller = Get.put(WatermarkController());
      controller.generatedPdfPath.value = '/tmp/Confidential_Report.pdf';
      controller.generatedPdfSize.value = 1048576; // 1 MB
      controller.generatedPdfPages.value = 8;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WatermarkSuccessView(controller: controller),
          ),
        ),
      );

      expect(find.text('Watermark Added!'), findsOneWidget);
      expect(find.text('Confidential_Report.pdf'), findsOneWidget);
      expect(find.text('8 pages • 1.00 MB'), findsOneWidget);
      expect(find.text('View PDF'), findsOneWidget);
      expect(find.text('Share PDF'), findsOneWidget);
      expect(find.text('Add Another Watermark'), findsOneWidget);
      expect(find.text('Open File Location'), findsOneWidget);
      expect(find.text('Back to Home'), findsOneWidget);

      Get.delete<WatermarkController>();
    });

    test('WatermarkController manages selection, config updates and reset', () {
      final controller = Get.put(WatermarkController());
      final pdf = PdfDocumentModel(
        id: 'pdf_sample',
        name: 'Contract.pdf',
        path: '/tmp/Contract.pdf',
        sizeInBytes: 512000,
        pageCount: 3,
        modifiedAt: DateTime.now(),
      );

      controller.selectRecentPdf(pdf);
      expect(controller.selectedPdf.value, isNotNull);
      expect(controller.selectedPdf.value?.name, 'Contract.pdf');

      controller.updateConfig(controller.config.value.copyWith(text: 'SAMPLE TEST'));
      expect(controller.config.value.text, 'SAMPLE TEST');

      controller.reset();
      expect(controller.isSuccess.value, isFalse);
      expect(controller.generatedPdfPath.value, isEmpty);

      controller.clearPdf();
      expect(controller.selectedPdf.value, isNull);

      Get.delete<WatermarkController>();
    });
  });
}
