import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdf_toolkit/app/features/compress_pdf/widgets/compress_estimate_card.dart';
import 'package:pdf_toolkit/app/features/compress_pdf/widgets/compress_file_picker_card.dart';
import 'package:pdf_toolkit/app/features/compress_pdf/widgets/compress_header_banner.dart';
import 'package:pdf_toolkit/app/features/compress_pdf/widgets/compress_level_selector.dart';
import 'package:pdf_toolkit/app/features/compress_pdf/widgets/compress_success_view.dart';
import 'package:pdf_toolkit/app/shared/models/pdf_document_model.dart';

void main() {
  group('Compress PDF Feature Tests', () {
    testWidgets('CompressHeaderBanner displays title and subtitle', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CompressHeaderBanner(),
          ),
        ),
      );

      expect(find.text('Compress PDF'), findsOneWidget);
      expect(find.textContaining('Reduce your PDF file size'), findsOneWidget);
    });

    testWidgets('CompressFilePickerCard handles empty state and selected file state', (tester) async {
      final doc = PdfDocumentModel(
        id: 'comp_1',
        name: 'Project_Proposal.pdf',
        path: '/tmp/Project_Proposal.pdf',
        sizeInBytes: 2516582, // 2.40 MB
        modifiedAt: DateTime.now(),
        pageCount: 1,
      );

      bool cleared = false;

      // 1. Empty state
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CompressFilePickerCard(
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

      // 2. Populated state
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CompressFilePickerCard(
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
      expect(find.text('2.40 MB • 1 page'), findsOneWidget);
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pump();
      expect(cleared, isTrue);
    });

    testWidgets('CompressLevelSelector renders 3 compression levels and responds to tap', (tester) async {
      String selected = 'balanced';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => CompressLevelSelector(
                selectedLevel: selected,
                onLevelSelected: (lvl) => setState(() => selected = lvl),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Compression Level'), findsOneWidget);
      expect(find.text('Low'), findsOneWidget);
      expect(find.text('Balanced'), findsOneWidget);
      expect(find.text('High'), findsOneWidget);

      await tester.tap(find.text('High'));
      await tester.pump();
      expect(selected, 'high');
    });

    testWidgets('CompressEstimateCard displays byte transformation and percentage pill', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CompressEstimateCard(
              originalSize: '2.40 MB',
              estimatedSize: '780 KB',
              percentReduction: 68,
            ),
          ),
        ),
      );

      expect(find.text('Estimated Result'), findsOneWidget);
      expect(find.text('2.40 MB → ~ 780 KB'), findsOneWidget);
      expect(find.text('≈ 68% smaller'), findsOneWidget);
      expect(find.byIcon(Icons.layers_rounded), findsOneWidget);
    });

    testWidgets('CompressSuccessView displays comparison card, savings banner, and actions', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final origDoc = PdfDocumentModel(
        id: 'orig',
        name: 'Design Guide.pdf',
        path: '/tmp/Design Guide.pdf',
        sizeInBytes: 8808038, // 8.40 MB
        modifiedAt: DateTime.now(),
        pageCount: 5,
      );

      final compDoc = PdfDocumentModel(
        id: 'comp',
        name: 'Design Guide (Compressed).pdf',
        path: '/tmp/Design Guide (Compressed).pdf',
        sizeInBytes: 2411724, // 2.30 MB
        modifiedAt: DateTime.now(),
        pageCount: 5,
      );

      bool compressAnother = false;
      bool openDoc = false;

      await tester.pumpWidget(
        MaterialApp(
          home: CompressSuccessView(
            originalDoc: origDoc,
            compressedDoc: compDoc,
            onCompressAnother: () => compressAnother = true,
            onOpenDoc: () => openDoc = true,
            onShareDoc: () {},
            onRenameDoc: () {},
          ),
        ),
      );

      expect(find.text('PDF Compressed Successfully!'), findsOneWidget);
      expect(find.text('Your file size has been reduced.'), findsOneWidget);
      expect(find.text('Original Size'), findsOneWidget);
      expect(find.text('8.40 MB'), findsOneWidget);
      expect(find.text('Compressed Size'), findsOneWidget);
      expect(find.text('2.30 MB'), findsOneWidget);
      expect(find.text('73% smaller'), findsOneWidget);
      expect(find.text('Design Guide (Compressed).pdf'), findsOneWidget);
      expect(find.text('Open'), findsOneWidget);
      expect(find.text('Share'), findsOneWidget);

      await tester.tap(find.text('Open'));
      await tester.pump();
      expect(openDoc, isTrue);

      await tester.ensureVisible(find.text('Compress Another PDF'));
      await tester.tap(find.text('Compress Another PDF'));
      await tester.pumpAndSettle();
      expect(compressAnother, isTrue);
    });
  });
}

