import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdf_toolkit/app/features/merge_pdf/widgets/merge_doc_thumbnail.dart';
import 'package:pdf_toolkit/app/features/merge_pdf/widgets/merge_file_card.dart';
import 'package:pdf_toolkit/app/features/merge_pdf/widgets/merge_hero_card.dart';
import 'package:pdf_toolkit/app/features/merge_pdf/widgets/merge_stepper_header.dart';
import 'package:pdf_toolkit/app/shared/models/pdf_document_model.dart';

void main() {
  group('Merge PDF Feature Tests', () {
    testWidgets('MergeStepperHeader displays steps correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MergeStepperHeader(fileCount: 3, isMerging: false),
          ),
        ),
      );

      expect(find.text('Add Files'), findsOneWidget);
      expect(find.text('Reorder'), findsOneWidget);
      expect(find.text('Merge'), findsOneWidget);
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    });

    testWidgets('MergeHeroCard displays illustration and title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MergeHeroCard(),
          ),
        ),
      );

      expect(find.text('Reorder Files'), findsOneWidget);
      expect(find.textContaining('Drag and drop'), findsOneWidget);
    });

    testWidgets('MergeDocThumbnail differentiates certificates and standard docs', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                MergeDocThumbnail(fileName: 'Certificate.pdf'),
                MergeDocThumbnail(fileName: 'CV.pdf'),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(MergeDocThumbnail), findsNWidgets(2));
      expect(find.byIcon(Icons.star_rounded), findsOneWidget); // Certificate star icon
    });

    testWidgets('MergeFileCard renders file name, size, pages, and remove callback', (tester) async {
      final doc = PdfDocumentModel(
        id: '1',
        name: 'CV.pdf',
        path: '/tmp/CV.pdf',
        sizeInBytes: 1258291, // 1.2 MB
        modifiedAt: DateTime.now(),
        pageCount: 2,
      );

      bool removed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MergeFileCard(
              file: doc,
              index: 0,
              onRemove: () => removed = true,
            ),
          ),
        ),
      );

      expect(find.text('1. CV.pdf'), findsOneWidget);
      expect(find.text('1.20 MB'), findsOneWidget);
      expect(find.text('2 pages'), findsOneWidget);
      expect(find.byIcon(Icons.drag_indicator_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pump();

      expect(removed, isTrue);
    });
  });
}

