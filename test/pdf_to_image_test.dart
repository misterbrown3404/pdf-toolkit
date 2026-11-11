import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdf_toolkit/app/features/pdf_to_image/widgets/pdf_to_image_file_card.dart';
import 'package:pdf_toolkit/app/features/pdf_to_image/widgets/pdf_to_image_header_banner.dart';
import 'package:pdf_toolkit/app/features/pdf_to_image/widgets/pdf_to_image_settings_card.dart';
import 'package:pdf_toolkit/app/features/pdf_to_image/widgets/pdf_to_image_success_view.dart';
import 'package:pdf_toolkit/app/features/pdf_to_image/widgets/pdf_to_image_thumbnail_card.dart';
import 'package:pdf_toolkit/app/shared/models/pdf_document_model.dart';

void main() {
  group('PDF to Image Feature Tests', () {
    testWidgets('PdfToImageHeaderBanner renders title and subtitle', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PdfToImageHeaderBanner(),
          ),
        ),
      );

      expect(find.text('PDF to Image'), findsOneWidget);
      expect(find.textContaining('Convert a PDF into high-quality images'), findsOneWidget);
    });

    testWidgets('PdfToImageFileCard handles empty and selected states', (tester) async {
      final doc = PdfDocumentModel(
        id: 'p2i_doc_1',
        name: 'Project_Proposal.pdf',
        path: '/tmp/Project_Proposal.pdf',
        sizeInBytes: 2516582,
        modifiedAt: DateTime.now(),
        pageCount: 12,
      );

      bool cleared = false;

      // 1. Empty state
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PdfToImageFileCard(
              selectedPdf: null,
              onPickFile: () {},
              onClearFile: () {},
              recentFiles: const [],
              onSelectRecent: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Select a PDF file'), findsOneWidget);
      expect(find.text('Choose File'), findsOneWidget);

      // 2. Selected state
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PdfToImageFileCard(
              selectedPdf: doc,
              onPickFile: () {},
              onClearFile: () => cleared = true,
              recentFiles: const [],
              onSelectRecent: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Project_Proposal.pdf'), findsOneWidget);
      expect(find.text('2.40 MB • 12 pages'), findsOneWidget);
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pump();
      expect(cleared, isTrue);
    });

    testWidgets('PdfToImageSettingsCard switches format, quality, and range', (tester) async {
      String format = 'jpg';
      String quality = 'high';
      bool isCustomRange = false;
      String customRange = '1-5';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => SingleChildScrollView(
                child: PdfToImageSettingsCard(
                  format: format,
                  onFormatChanged: (f) => setState(() => format = f),
                  quality: quality,
                  onQualityChanged: (q) => setState(() => quality = q),
                  isCustomRange: isCustomRange,
                  onRangeTypeChanged: (c) => setState(() => isCustomRange = c),
                  totalPages: 12,
                  customRange: customRange,
                  onCustomRangeChanged: (r) => setState(() => customRange = r),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Conversion Settings'), findsOneWidget);
      expect(find.text('Output Format'), findsOneWidget);
      expect(find.text('Image Quality'), findsOneWidget);
      expect(find.text('Page Range'), findsOneWidget);
      expect(find.text('All Pages (12)'), findsOneWidget);

      // Tap PNG
      await tester.tap(find.text('PNG'));
      await tester.pump();
      expect(format, 'png');

      // Tap Medium
      await tester.tap(find.text('Medium'));
      await tester.pump();
      expect(quality, 'medium');

      // Tap Custom Range
      await tester.tap(find.text('Custom Range'));
      await tester.pump();
      expect(isCustomRange, isTrue);
    });

    testWidgets('PdfToImageThumbnailCard renders page pill', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PdfToImageThumbnailCard(
              imagePath: '/tmp/non_existent.jpg',
              pageIndex: 3,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('PdfToImageSuccessView displays summary, image count, and action buttons', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final doc = PdfDocumentModel(
        id: 'succ_doc',
        name: 'Project_Proposal.pdf',
        path: '/tmp/Project_Proposal.pdf',
        sizeInBytes: 2516582,
        modifiedAt: DateTime.now(),
        pageCount: 12,
      );

      bool viewAllTapped = false;
      bool convertAnotherTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: PdfToImageSuccessView(
            sourceDoc: doc,
            generatedImagePaths: const ['/tmp/p1.jpg', '/tmp/p2.jpg'],
            onConvertAnother: () => convertAnotherTapped = true,
            onViewAllImages: () => viewAllTapped = true,
            onShareImages: () {},
          ),
        ),
      );

      expect(find.text('Conversion Successful!'), findsOneWidget);
      expect(find.text('Your PDF has been converted to images.'), findsOneWidget);
      expect(find.text('Project_Proposal.pdf'), findsOneWidget);
      expect(find.text('2 Images'), findsOneWidget);
      expect(find.text('Converted Images (2)'), findsOneWidget);
      expect(find.text('View All Images'), findsOneWidget);
      expect(find.text('Convert Another PDF'), findsOneWidget);

      await tester.tap(find.text('View All Images'));
      await tester.pump();
      expect(viewAllTapped, isTrue);

      await tester.ensureVisible(find.text('Convert Another PDF'));
      await tester.tap(find.text('Convert Another PDF'));
      await tester.pumpAndSettle();
      expect(convertAnotherTapped, isTrue);
    });
  });
}

