import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:pdf_toolkit/app/features/files/files_controller.dart';
import 'package:pdf_toolkit/app/features/files/models/file_category_enum.dart';
import 'package:pdf_toolkit/app/features/files/models/file_sort_enum.dart';
import 'package:pdf_toolkit/app/features/files/widgets/files_category_chips.dart';
import 'package:pdf_toolkit/app/features/files/widgets/files_details_bottom_sheet.dart';
import 'package:pdf_toolkit/app/features/files/widgets/files_document_grid_card.dart';
import 'package:pdf_toolkit/app/features/files/widgets/files_document_tile.dart';
import 'package:pdf_toolkit/app/features/files/widgets/files_empty_view.dart';
import 'package:pdf_toolkit/app/features/files/widgets/files_header_app_bar.dart';
import 'package:pdf_toolkit/app/features/files/widgets/files_search_bar.dart';
import 'package:pdf_toolkit/app/features/files/widgets/files_sort_bottom_sheet.dart';
import 'package:pdf_toolkit/app/features/files/widgets/files_storage_card.dart';
import 'package:pdf_toolkit/app/shared/models/pdf_document_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Files Feature Models', () {
    test('FileCategory enum contains expected items', () {
      expect(FileCategory.values.length, 5);
      expect(FileCategory.values, contains(FileCategory.all));
      expect(FileCategory.values, contains(FileCategory.pdf));
      expect(FileCategory.values, contains(FileCategory.scanned));
      expect(FileCategory.values, contains(FileCategory.compressed));
      expect(FileCategory.values, contains(FileCategory.protected));
    });

    test('FileSort enum contains expected items', () {
      expect(FileSort.values.length, 6);
      expect(FileSort.values, contains(FileSort.dateDesc));
      expect(FileSort.values, contains(FileSort.dateAsc));
      expect(FileSort.values, contains(FileSort.nameAsc));
      expect(FileSort.values, contains(FileSort.nameDesc));
      expect(FileSort.values, contains(FileSort.sizeDesc));
      expect(FileSort.values, contains(FileSort.sizeAsc));
    });
  });

  group('FilesController Logic', () {
    late FilesController controller;

    setUp(() {
      Get.reset();
      controller = FilesController();
      Get.put<FilesController>(controller);

      // Populate mock files
      controller.allFiles.assignAll([
        PdfDocumentModel(
          id: '1',
          name: 'Annual_Report_2026.pdf',
          path: '/path/Annual_Report_2026.pdf',
          sizeInBytes: 2500000,
          modifiedAt: DateTime.now(),
          pageCount: 15,
        ),
        PdfDocumentModel(
          id: '2',
          name: 'Scanned_Receipt_May.pdf',
          path: '/path/Scanned_Receipt_May.pdf',
          sizeInBytes: 850000,
          modifiedAt: DateTime.now().subtract(const Duration(days: 1)),
          pageCount: 2,
        ),
        PdfDocumentModel(
          id: '3',
          name: 'Contract_Protected.pdf',
          path: '/path/Contract_Protected.pdf',
          sizeInBytes: 1200000,
          modifiedAt: DateTime.now().subtract(const Duration(days: 5)),
          pageCount: 6,
          isEncrypted: true,
        ),
        PdfDocumentModel(
          id: '4',
          name: 'Presentation_compressed.pdf',
          path: '/path/Presentation_compressed.pdf',
          sizeInBytes: 450000,
          modifiedAt: DateTime.now().subtract(const Duration(days: 10)),
          pageCount: 8,
        ),
      ]);
    });

    tearDown(() {
      Get.reset();
    });

    test('Initial controller state has expected defaults', () {
      expect(controller.selectedCategory.value, FileCategory.all);
      expect(controller.currentSort.value, FileSort.dateDesc);
      expect(controller.isGridView.value, isFalse);
      expect(controller.isSearchVisible.value, isFalse);
      expect(controller.searchQuery.value, '');
      expect(controller.allFiles.length, 4);
    });

    test('Category filtering works correctly', () {
      // All
      controller.setCategory(FileCategory.all);
      expect(controller.filteredFiles.length, 4);

      // Scanned
      controller.setCategory(FileCategory.scanned);
      expect(controller.filteredFiles.length, 1);
      expect(controller.filteredFiles.first.name, contains('Scanned'));

      // Compressed
      controller.setCategory(FileCategory.compressed);
      expect(controller.filteredFiles.length, 1);
      expect(controller.filteredFiles.first.name, contains('compressed'));

      // Protected
      controller.setCategory(FileCategory.protected);
      expect(controller.filteredFiles.length, 1);
      expect(controller.filteredFiles.first.isEncrypted, isTrue);
    });

    test('Search filtering works correctly', () {
      controller.setCategory(FileCategory.all);

      controller.setSearchQuery('report');
      expect(controller.filteredFiles.length, 1);
      expect(controller.filteredFiles.first.name, 'Annual_Report_2026.pdf');

      controller.setSearchQuery('NonExistentFile');
      expect(controller.filteredFiles.isEmpty, isTrue);

      controller.setSearchQuery('');
      expect(controller.filteredFiles.length, 4);
    });

    test('Sorting by Name and Size works correctly', () {
      controller.setCategory(FileCategory.all);

      // Name Asc
      controller.setSort(FileSort.nameAsc);
      expect(controller.filteredFiles.first.name, 'Annual_Report_2026.pdf');

      // Name Desc
      controller.setSort(FileSort.nameDesc);
      expect(controller.filteredFiles.first.name, 'Scanned_Receipt_May.pdf');

      // Size Desc
      controller.setSort(FileSort.sizeDesc);
      expect(controller.filteredFiles.first.sizeInBytes, 2500000);

      // Size Asc
      controller.setSort(FileSort.sizeAsc);
      expect(controller.filteredFiles.first.sizeInBytes, 450000);
    });

    test('Storage calculations work accurately', () {
      final total = controller.totalSizeInBytes;
      expect(total, 2500000 + 850000 + 1200000 + 450000);
      expect(controller.formattedTotalStorage, contains('MB'));
    });

    test('Date grouping divides files into Today, Yesterday, Earlier', () {
      controller.setCategory(FileCategory.all);
      final groups = controller.groupedFiles;
      expect(groups.containsKey('Today'), isTrue);
      expect(groups.containsKey('Yesterday'), isTrue);
      expect(groups.containsKey('Earlier'), isTrue);
      expect(groups['Today']!.length, 1);
      expect(groups['Yesterday']!.length, 1);
      expect(groups['Earlier']!.length, 2);
    });

    test('Toggles view mode and search visibility', () {
      expect(controller.isGridView.value, isFalse);
      controller.toggleViewMode();
      expect(controller.isGridView.value, isTrue);

      expect(controller.isSearchVisible.value, isFalse);
      controller.toggleSearch();
      expect(controller.isSearchVisible.value, isTrue);
      controller.setSearchQuery('abc');
      controller.toggleSearch();
      expect(controller.isSearchVisible.value, isFalse);
      expect(controller.searchQuery.value, '');
    });
  });

  group('Files Widgets', () {
    late FilesController controller;

    setUp(() {
      Get.reset();
      controller = FilesController();
      Get.put<FilesController>(controller);

      controller.allFiles.assignAll([
        PdfDocumentModel(
          id: '1',
          name: 'Annual_Report_2026.pdf',
          path: '/path/Annual_Report_2026.pdf',
          sizeInBytes: 2500000,
          modifiedAt: DateTime.now(),
          pageCount: 15,
        ),
      ]);
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('FilesHeaderAppBar renders title and action buttons', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: FilesHeaderAppBar(),
          ),
        ),
      );

      expect(find.text('My Files'), findsOneWidget);
      expect(find.text('All your files in one place'), findsOneWidget);
      expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      expect(find.byIcon(Icons.swap_vert_rounded), findsOneWidget);
      expect(find.byIcon(Icons.grid_view_rounded), findsOneWidget);
    });

    testWidgets('FilesStorageCard renders storage info and progress bar', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FilesStorageCard(),
          ),
        ),
      );

      expect(find.text('Device Storage'), findsOneWidget);
      expect(find.textContaining('24.8 GB used of 128 GB'), findsOneWidget);
      expect(find.text('19%'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('FilesCategoryChips renders categories and responds to tap', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FilesCategoryChips(),
          ),
        ),
      );

      expect(find.text('All Files'), findsOneWidget);
      expect(find.text('PDFs'), findsOneWidget);
      expect(find.text('Scanned'), findsOneWidget);
      expect(find.text('Compressed'), findsOneWidget);
      expect(find.text('Protected'), findsOneWidget);

      await tester.tap(find.text('Scanned'));
      await tester.pump();
      expect(controller.selectedCategory.value, FileCategory.scanned);
    });

    testWidgets('FilesSearchBar accepts input and clears on button tap', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FilesSearchBar(),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'receipt');
      await tester.pump();
      expect(controller.searchQuery.value, 'receipt');

      expect(find.byIcon(Icons.close_rounded), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pump();
      expect(controller.searchQuery.value, '');
    });

    testWidgets('FilesDocumentTile renders document name, size, and icons', (tester) async {
      final doc = controller.allFiles.first;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FilesDocumentTile(document: doc),
          ),
        ),
      );

      expect(find.text('Annual_Report_2026.pdf'), findsOneWidget);
      expect(find.textContaining('2.38 MB'), findsOneWidget);
      expect(find.textContaining('15 pgs'), findsOneWidget);
      expect(find.byIcon(Icons.picture_as_pdf_rounded), findsOneWidget);
      expect(find.byIcon(Icons.more_vert_rounded), findsOneWidget);
    });

    testWidgets('FilesDocumentGridCard renders preview card', (tester) async {
      final doc = controller.allFiles.first;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 180,
              height: 200,
              child: FilesDocumentGridCard(document: doc),
            ),
          ),
        ),
      );

      expect(find.text('Annual_Report_2026.pdf'), findsOneWidget);
      expect(find.byIcon(Icons.picture_as_pdf_rounded), findsOneWidget);
    });

    testWidgets('FilesEmptyView renders icon and action button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FilesEmptyView(),
          ),
        ),
      );

      expect(find.text('No documents found'), findsOneWidget);
      expect(find.text('Pick PDF Document'), findsOneWidget);
      expect(find.byIcon(Icons.folder_open_rounded), findsOneWidget);
    });

    testWidgets('FilesSortBottomSheet renders sort options and updates sort', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FilesSortBottomSheet(),
          ),
        ),
      );

      expect(find.text('Sort Files By'), findsOneWidget);
      expect(find.text('Name (A to Z)'), findsOneWidget);
      expect(find.text('Size (Largest first)'), findsOneWidget);

      await tester.tap(find.text('Name (A to Z)'));
      await tester.pump();
      expect(controller.currentSort.value, FileSort.nameAsc);
    });

    testWidgets('FilesDetailsBottomSheet renders metadata and action list', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final doc = controller.allFiles.first;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FilesDetailsBottomSheet(document: doc),
          ),
        ),
      );

      expect(find.text('Annual_Report_2026.pdf'), findsOneWidget);
      expect(find.text('File Information'), findsOneWidget);
      expect(find.text('Portable Document Format (.pdf)'), findsOneWidget);
      expect(find.textContaining('2500000 bytes'), findsOneWidget);
      expect(find.text('15 pages'), findsOneWidget);
      expect(find.text('Quick Actions'), findsOneWidget);
      expect(find.text('Open in Viewer'), findsOneWidget);
      expect(find.text('Share File'), findsOneWidget);
      expect(find.text('Rename File'), findsOneWidget);
      expect(find.text('Duplicate File'), findsOneWidget);
      expect(find.text('Protect / Lock PDF'), findsOneWidget);
      expect(find.text('Add Watermark'), findsOneWidget);
      expect(find.text('Compress PDF'), findsOneWidget);
      expect(find.text('Split PDF Pages'), findsOneWidget);
      expect(find.text('Delete File'), findsOneWidget);
    });
  });
}
