import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:pdf_toolkit/app/features/pdf_viewer/pdf_viewer_controller.dart';
import 'package:pdf_toolkit/app/features/pdf_viewer/widgets/viewer_bottom_controls.dart';
import 'package:pdf_toolkit/app/features/pdf_viewer/widgets/viewer_header_app_bar.dart';
import 'package:pdf_toolkit/app/features/pdf_viewer/widgets/viewer_meta_ribbon.dart';
import 'package:pdf_toolkit/app/features/pdf_viewer/widgets/viewer_page_jump_dialog.dart';
import 'package:pdf_toolkit/app/features/pdf_viewer/widgets/viewer_password_dialog.dart';
import 'package:pdf_toolkit/app/features/pdf_viewer/widgets/viewer_search_bar.dart';
import 'package:pdf_toolkit/app/features/pdf_viewer/widgets/viewer_thumbnails_drawer.dart';
import 'package:pdf_toolkit/app/features/pdf_viewer/widgets/viewer_tools_sheet.dart';

void main() {
  group('PDF Reader / Viewer Feature Tests', () {
    testWidgets('ViewerHeaderAppBar renders title, subtitle, and triggers action buttons', (tester) async {
      bool backTapped = false;
      bool searchTapped = false;
      bool nightTapped = false;
      bool thumbsTapped = false;
      bool shareTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ViewerHeaderAppBar(
              isSearchOpen: false,
              isNightMode: false,
              onToggleSearch: () => searchTapped = true,
              onToggleNightMode: () => nightTapped = true,
              onOpenThumbnails: () => thumbsTapped = true,
              onShare: () => shareTapped = true,
              onBack: () => backTapped = true,
            ),
          ),
        ),
      );

      expect(find.text('PDF Viewer'), findsOneWidget);
      expect(find.text('Read your document'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pump();
      expect(backTapped, isTrue);

      await tester.tap(find.byIcon(Icons.search_rounded));
      await tester.pump();
      expect(searchTapped, isTrue);

      await tester.tap(find.byIcon(Icons.dark_mode_outlined));
      await tester.pump();
      expect(nightTapped, isTrue);

      await tester.tap(find.byIcon(Icons.grid_view_rounded));
      await tester.pump();
      expect(thumbsTapped, isTrue);

      await tester.tap(find.byIcon(Icons.share_outlined));
      await tester.pump();
      expect(shareTapped, isTrue);
    });

    testWidgets('ViewerMetaRibbon displays document name, size, and page pill', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ViewerMetaRibbon(
              fileName: 'Merged_Document.pdf',
              fileSizeFormatted: '5.6 MB',
              currentPage: 1,
              totalPages: 10,
            ),
          ),
        ),
      );

      expect(find.text('Merged_Document.pdf'), findsOneWidget);
      expect(find.text('5.6 MB • 10 pages'), findsOneWidget);
      expect(find.text('1/10'), findsOneWidget);
    });

    testWidgets('ViewerSearchBar renders input, match pill, and callbacks', (tester) async {
      final ctrl = TextEditingController(text: 'project');
      bool nextTapped = false;
      bool prevTapped = false;
      bool closeTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ViewerSearchBar(
              searchController: ctrl,
              matchCount: 5,
              currentMatchIndex: 1,
              onSearchChanged: (_) {},
              onNextMatch: () => nextTapped = true,
              onPrevMatch: () => prevTapped = true,
              onClose: () => closeTapped = true,
            ),
          ),
        ),
      );

      expect(find.text('2/5'), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_up_rounded), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.keyboard_arrow_down_rounded));
      await tester.pump();
      expect(nextTapped, isTrue);

      await tester.tap(find.byIcon(Icons.keyboard_arrow_up_rounded));
      await tester.pump();
      expect(prevTapped, isTrue);

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pump();
      expect(closeTapped, isTrue);
    });

    testWidgets('ViewerBottomControls renders page info, zoom, and tools buttons', (tester) async {
      bool zoomInTapped = false;
      bool zoomOutTapped = false;
      bool jumpTapped = false;
      bool prevTapped = false;
      bool nextTapped = false;
      bool toolsTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ViewerBottomControls(
              currentPage: 3,
              totalPages: 8,
              onZoomIn: () => zoomInTapped = true,
              onZoomOut: () => zoomOutTapped = true,
              onPageJump: () => jumpTapped = true,
              onPrevPage: () => prevTapped = true,
              onNextPage: () => nextTapped = true,
              onOpenTools: () => toolsTapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Page 3 of 8'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.remove_circle_outline_rounded));
      await tester.pump();
      expect(zoomOutTapped, isTrue);

      await tester.tap(find.byIcon(Icons.add_circle_outline_rounded));
      await tester.pump();
      expect(zoomInTapped, isTrue);

      await tester.tap(find.text('Page 3 of 8'));
      await tester.pump();
      expect(jumpTapped, isTrue);

      await tester.tap(find.byIcon(Icons.chevron_left_rounded));
      await tester.pump();
      expect(prevTapped, isTrue);

      await tester.tap(find.byIcon(Icons.chevron_right_rounded));
      await tester.pump();
      expect(nextTapped, isTrue);

      await tester.tap(find.byIcon(Icons.more_vert_rounded));
      await tester.pump();
      expect(toolsTapped, isTrue);
    });

    testWidgets('ViewerPageJumpDialog renders slider and triggers jump callback', (tester) async {
      int jumpedPage = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ViewerPageJumpDialog(
              currentPage: 2,
              totalPages: 10,
              onJump: (page) => jumpedPage = page,
            ),
          ),
        ),
      );

      expect(find.text('Jump to Page'), findsOneWidget);
      expect(find.text('Page 2 of 10'), findsOneWidget);

      await tester.tap(find.text('Go to Page'));
      await tester.pump();
      expect(jumpedPage, 2);
    });

    testWidgets('ViewerToolsSheet renders tool shortcuts', (tester) async {
      bool splitTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ViewerToolsSheet(
              onSplit: () => splitTapped = true,
              onMerge: () {},
              onCompress: () {},
              onPdfToImage: () {},
              onWatermark: () {},
              onProtect: () {},
            ),
          ),
        ),
      );

      expect(find.text('Tools for this PDF'), findsOneWidget);
      expect(find.text('Split PDF'), findsOneWidget);
      expect(find.text('Merge PDF'), findsOneWidget);
      expect(find.text('Compress'), findsOneWidget);
      expect(find.text('PDF to Image'), findsOneWidget);
      expect(find.text('Watermark'), findsOneWidget);
      expect(find.text('Protect PDF'), findsOneWidget);

      await tester.tap(find.text('Split PDF'));
      await tester.pump();
      expect(splitTapped, isTrue);
    });

    testWidgets('ViewerPasswordDialog renders password prompt and unlock button', (tester) async {
      final pwdCtrl = TextEditingController(text: 'secretPass');
      String submitted = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ViewerPasswordDialog(
              passwordController: pwdCtrl,
              onSubmit: (val) => submitted = val,
              onCancel: () {},
            ),
          ),
        ),
      );

      expect(find.text('Protected Document'), findsOneWidget);
      expect(find.text('Unlock'), findsOneWidget);

      await tester.tap(find.text('Unlock'));
      await tester.pump();
      expect(submitted, 'secretPass');
    });

    testWidgets('ViewerThumbnailsDrawer renders page grid and triggers selection', (tester) async {
      int selected = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ViewerThumbnailsDrawer(
              currentPage: 1,
              totalPages: 5,
              onSelectPage: (p) => selected = p,
            ),
          ),
        ),
      );

      expect(find.text('Page Thumbnails'), findsOneWidget);
      expect(find.text('5 pages'), findsOneWidget);
      expect(find.text('Page 1'), findsOneWidget);
      expect(find.text('Page 2'), findsOneWidget);

      await tester.tap(find.text('Page 2'));
      await tester.pump();
      expect(selected, 2);
    });

    test('DocumentViewerController manages pages, night mode, and search state', () {
      final controller = Get.put(DocumentViewerController());
      controller.totalPages.value = 6;
      controller.currentPage.value = 1;

      expect(controller.isNightMode.value, isFalse);
      controller.toggleNightMode();
      expect(controller.isNightMode.value, isTrue);

      expect(controller.isSearchOpen.value, isFalse);
      controller.toggleSearch();
      expect(controller.isSearchOpen.value, isTrue);

      controller.nextPage();
      expect(controller.currentPage.value, 2);

      controller.prevPage();
      expect(controller.currentPage.value, 1);

      controller.goToPage(5);
      expect(controller.currentPage.value, 5);

      Get.delete<DocumentViewerController>();
    });
  });
}
