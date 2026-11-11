import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdf_toolkit/app/features/home/widgets/home_hero_banner.dart';
import 'package:pdf_toolkit/app/features/home/widgets/home_recent_file_row.dart';
import 'package:pdf_toolkit/app/shared/models/pdf_document_model.dart';
import 'package:pdf_toolkit/app/shared/utils/tools_catalog.dart';

void main() {
  group('Home Features & Tools Catalog Tests', () {
    test('ToolsCatalog.homeGridTools returns exactly 6 primary tools', () {
      final tools = ToolsCatalog.homeGridTools;
      expect(tools.length, 6);

      final ids = tools.map((t) => t.id).toList();
      expect(ids, contains('merge'));
      expect(ids, contains('split'));
      expect(ids, contains('compress'));
      expect(ids, contains('pdf_to_image'));
      expect(ids, contains('image_to_pdf'));
      expect(ids, contains('more_tools'));
    });

    test('PdfDocumentModel copyWith and formattedSize work accurately', () {
      final doc = PdfDocumentModel(
        id: 'test_id',
        name: 'Sample.pdf',
        path: '/tmp/sample.pdf',
        sizeInBytes: 1572864, // 1.5 MB
        modifiedAt: DateTime.now(),
        pageCount: 5,
      );

      expect(doc.formattedSize, '1.50 MB');
      expect(doc.pageCount, 5);

      final updated = doc.copyWith(name: 'Updated.pdf', pageCount: 10);
      expect(updated.name, 'Updated.pdf');
      expect(updated.pageCount, 10);
      expect(updated.sizeInBytes, 1572864);
    });

    testWidgets('HomeHeroBanner displays title, pill and triggers tap', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HomeHeroBanner(
              onExploreTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('ALL-IN-ONE PDF TOOLS'), findsOneWidget);
      expect(find.byType(RichText), findsWidgets);
      expect(find.text('Explore Tools'), findsOneWidget);

      await tester.tap(find.text('Explore Tools'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('HomeRecentFileRow renders file name and details', (tester) async {
      final doc = PdfDocumentModel(
        id: 'doc_1',
        name: 'Merged_Document.pdf',
        path: '/docs/Merged_Document.pdf',
        sizeInBytes: 5872025, // ~5.6 MB
        modifiedAt: DateTime.now(),
        pageCount: 10,
      );

      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HomeRecentFileRow(
              document: doc,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Merged_Document.pdf'), findsOneWidget);
      expect(find.text('10 pages'), findsOneWidget);
      expect(find.text('PDF'), findsOneWidget);

      await tester.tap(find.text('Merged_Document.pdf'));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });
}
