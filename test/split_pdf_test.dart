import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdf_toolkit/app/features/split_pdf/widgets/split_file_header.dart';
import 'package:pdf_toolkit/app/features/split_pdf/widgets/split_mode_selector.dart';
import 'package:pdf_toolkit/app/features/split_pdf/widgets/split_range_input.dart';
import 'package:pdf_toolkit/app/features/split_pdf/widgets/split_success_view.dart';
import 'package:pdf_toolkit/app/features/split_pdf/widgets/split_summary_card.dart';
import 'package:pdf_toolkit/app/shared/models/pdf_document_model.dart';

void main() {
  group('Split PDF Feature Tests', () {
    testWidgets('SplitModeSelector renders all 3 modes and responds to selection', (tester) async {
      int selectedMode = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => SplitModeSelector(
                selectedIndex: selectedMode,
                onSelectMode: (mode) {
                  setState(() => selectedMode = mode);
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Page Range'), findsOneWidget);
      expect(find.text('Extract All'), findsOneWidget);
      expect(find.text('Fixed Interval'), findsOneWidget);

      await tester.tap(find.text('Extract All'));
      await tester.pump();
      expect(selectedMode, 1);

      await tester.tap(find.text('Fixed Interval'));
      await tester.pump();
      expect(selectedMode, 2);
    });

    testWidgets('SplitRangeInput shows preset chips and custom range text input', (tester) async {
      String changedRange = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SplitRangeInput(
              splitMethod: 0,
              totalPages: 24,
              currentInput: '',
              onRangeChanged: (val) => changedRange = val,
              intervalPages: 2,
              onIntervalChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Page Ranges'), findsOneWidget);
      expect(find.widgetWithText(ActionChip, '1-5'), findsOneWidget);
      expect(find.widgetWithText(ActionChip, '6-10'), findsOneWidget);
      expect(find.widgetWithText(ActionChip, 'All Odd'), findsOneWidget);
      expect(find.widgetWithText(ActionChip, 'All Even'), findsOneWidget);

      await tester.tap(find.widgetWithText(ActionChip, '6-10'));
      await tester.pump();
      expect(changedRange, '6-10');
    });

    testWidgets('SplitSummaryCard renders estimated files and description', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SplitSummaryCard(
              estimatedFiles: 3,
              summaryText: 'Pages 1-5, 6-10, and 11-20 will be created as 3 PDFs.',
            ),
          ),
        ),
      );

      expect(find.text('3 files will be created'), findsOneWidget);
      expect(find.text('Pages 1-5, 6-10, and 11-20 will be created as 3 PDFs.'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    });

    testWidgets('SplitFileHeader displays empty upload container and file details', (tester) async {
      final doc = PdfDocumentModel(
        id: 'split_doc_1',
        name: 'Annual_Report_2025.pdf',
        path: '/tmp/Annual_Report_2025.pdf',
        sizeInBytes: 4299161, // 4.10 MB
        modifiedAt: DateTime.now(),
        pageCount: 24,
      );

      // 1. Empty state
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SplitFileHeader(
              selectedPdf: null,
              totalPages: 10,
              onPickFile: () {},
              recentFiles: const [],
              onSelectRecent: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Select a PDF file'), findsOneWidget);
      expect(find.text('Choose File'), findsOneWidget);

      // 2. Selected file state
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SplitFileHeader(
              selectedPdf: doc,
              totalPages: 24,
              onPickFile: () {},
              recentFiles: const [],
              onSelectRecent: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Annual_Report_2025.pdf'), findsOneWidget);
      expect(find.text('4.10 MB • 24 pages'), findsOneWidget);
      expect(find.byIcon(Icons.swap_horiz_rounded), findsOneWidget);
    });

    testWidgets('SplitSuccessView renders success header, created files, and action buttons', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final file1 = PdfDocumentModel(
        id: 'part_1',
        name: 'Annual_Report_2025_part_1.pdf',
        path: '/tmp/Annual_Report_2025_part_1.pdf',
        sizeInBytes: 1048576,
        modifiedAt: DateTime.now(),
        pageCount: 5,
      );
      final file2 = PdfDocumentModel(
        id: 'part_2',
        name: 'Annual_Report_2025_part_2.pdf',
        path: '/tmp/Annual_Report_2025_part_2.pdf',
        sizeInBytes: 1572864,
        modifiedAt: DateTime.now(),
        pageCount: 5,
      );

      bool splitAnotherTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: SplitSuccessView(
            createdFiles: [file1, file2],
            onSplitAnother: () => splitAnotherTapped = true,
            onOpenFile: (_) {},
            onShareFile: (_) {},
          ),
        ),
      );

      expect(find.text('PDF Split Successfully!'), findsOneWidget);
      expect(find.text('Created Files (2)'), findsOneWidget);
      expect(find.text('Annual_Report_2025_part_1.pdf'), findsOneWidget);
      expect(find.text('Annual_Report_2025_part_2.pdf'), findsOneWidget);
      expect(find.text('Go to My Files'), findsOneWidget);
      expect(find.text('Split Another PDF'), findsOneWidget);

      await tester.ensureVisible(find.text('Split Another PDF'));
      await tester.tap(find.text('Split Another PDF'));
      await tester.pumpAndSettle();
      expect(splitAnotherTapped, isTrue);
    });
  });
}
