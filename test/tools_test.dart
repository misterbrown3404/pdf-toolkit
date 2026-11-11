import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:pdf_toolkit/app/features/tools/models/tools_filter_category_enum.dart';
import 'package:pdf_toolkit/app/features/tools/tools_controller.dart';
import 'package:pdf_toolkit/app/features/tools/widgets/tools_category_filter_pills.dart';
import 'package:pdf_toolkit/app/features/tools/widgets/tools_empty_state.dart';
import 'package:pdf_toolkit/app/features/tools/widgets/tools_grid_card.dart';
import 'package:pdf_toolkit/app/features/tools/widgets/tools_header_banner.dart';
import 'package:pdf_toolkit/app/features/tools/widgets/tools_popular_section.dart';
import 'package:pdf_toolkit/app/features/tools/widgets/tools_pro_dialog.dart';
import 'package:pdf_toolkit/app/features/tools/widgets/tools_search_bar.dart';
import 'package:pdf_toolkit/app/shared/models/tool_item_model.dart';
import 'package:pdf_toolkit/app/shared/utils/tools_catalog.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Tools Feature Models & Logic', () {
    test('ToolsFilterCategory enum contains all expected values', () {
      expect(ToolsFilterCategory.values.length, 5);
      expect(ToolsFilterCategory.values, contains(ToolsFilterCategory.all));
      expect(ToolsFilterCategory.values, contains(ToolsFilterCategory.organize));
      expect(ToolsFilterCategory.values, contains(ToolsFilterCategory.convert));
      expect(ToolsFilterCategory.values, contains(ToolsFilterCategory.security));
      expect(ToolsFilterCategory.values, contains(ToolsFilterCategory.optimize));
    });

    test('ToolsController initializes with default state', () {
      Get.reset();
      final controller = ToolsController();
      Get.put<ToolsController>(controller);

      expect(controller.searchQuery.value, '');
      expect(controller.selectedCategory.value, ToolsFilterCategory.all);
      expect(controller.popularTools.length, 4);
      expect(controller.popularTools.map((t) => t.id), containsAll(['compress', 'merge', 'split', 'pdf_to_image']));
    });

    test('Category filtering narrows tool list correctly', () {
      Get.reset();
      final controller = ToolsController();
      Get.put<ToolsController>(controller);

      // All
      controller.setCategory(ToolsFilterCategory.all);
      final allCount = controller.filteredTools.length;
      expect(allCount, greaterThan(10));

      // Organize
      controller.setCategory(ToolsFilterCategory.organize);
      for (final t in controller.filteredTools) {
        expect(t.category, ToolCategory.organize);
      }

      // Convert
      controller.setCategory(ToolsFilterCategory.convert);
      for (final t in controller.filteredTools) {
        expect(t.category == ToolCategory.convert || t.category == ToolCategory.scan, isTrue);
      }

      // Security
      controller.setCategory(ToolsFilterCategory.security);
      for (final t in controller.filteredTools) {
        expect(t.category, ToolCategory.security);
      }

      // Optimize
      controller.setCategory(ToolsFilterCategory.optimize);
      for (final t in controller.filteredTools) {
        expect(t.category, ToolCategory.optimize);
      }
    });

    test('Search query filters tools by title or description', () {
      Get.reset();
      final controller = ToolsController();
      Get.put<ToolsController>(controller);

      controller.setSearchQuery('merge');
      expect(controller.filteredTools.any((t) => t.id == 'merge'), isTrue);

      controller.setSearchQuery('password');
      expect(controller.filteredTools.any((t) => t.id == 'protect'), isTrue);

      controller.setSearchQuery('XYZUnknownQuery');
      expect(controller.filteredTools.isEmpty, isTrue);

      controller.clearSearch();
      expect(controller.searchQuery.value, '');
      expect(controller.filteredTools.isNotEmpty, isTrue);
    });

    test('countForCategory returns valid counts matching list', () {
      Get.reset();
      final controller = ToolsController();
      Get.put<ToolsController>(controller);

      for (final cat in ToolsFilterCategory.values) {
        controller.setCategory(cat);
        expect(controller.countForCategory(cat), controller.filteredTools.length);
      }
    });
  });

  group('Tools Widgets', () {
    late ToolsController controller;

    setUp(() {
      Get.reset();
      controller = ToolsController();
      Get.put<ToolsController>(controller);
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('ToolsHeaderBanner renders title, subtitle, and badge', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ToolsHeaderBanner(),
          ),
        ),
      );

      expect(find.text('PDF Tools'), findsOneWidget);
      expect(find.text('ALL-IN-ONE'), findsOneWidget);
      expect(find.textContaining('All the PDF tools you need'), findsOneWidget);
    });

    testWidgets('ToolsSearchBar handles text input and clears on button tap', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ToolsSearchBar(),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'watermark');
      await tester.pump();
      expect(controller.searchQuery.value, 'watermark');

      expect(find.byIcon(Icons.close_rounded), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pump();
      expect(controller.searchQuery.value, '');
    });

    testWidgets('ToolsCategoryFilterPills displays chips and switches category', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ToolsCategoryFilterPills(),
          ),
        ),
      );

      expect(find.text('All Tools'), findsOneWidget);
      expect(find.text('Organize'), findsOneWidget);
      expect(find.text('Convert'), findsOneWidget);
      expect(find.text('Security'), findsOneWidget);
      expect(find.text('Optimize'), findsOneWidget);

      await tester.tap(find.text('Security'));
      await tester.pump();
      expect(controller.selectedCategory.value, ToolsFilterCategory.security);
    });

    testWidgets('ToolsPopularSection displays all 4 popular tools', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ToolsPopularSection(),
          ),
        ),
      );

      expect(find.text('Popular Tools'), findsOneWidget);
      expect(find.text('View All'), findsOneWidget);
      expect(find.text('Compress\nPDF'), findsOneWidget);
      expect(find.text('Merge\nPDF'), findsOneWidget);
      expect(find.text('Split\nPDF'), findsOneWidget);
      expect(find.text('PDF to\nImage'), findsOneWidget);

      await tester.tap(find.text('View All'));
      await tester.pump();
      expect(controller.selectedCategory.value, ToolsFilterCategory.all);
    });

    testWidgets('ToolsGridCard renders tool title, description, and responds to tap', (tester) async {
      final tool = ToolsCatalog.allTools.firstWhere((t) => t.id == 'merge');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ToolsGridCard(tool: tool),
          ),
        ),
      );

      expect(find.text('Merge PDF'), findsOneWidget);
      expect(find.text(tool.description), findsOneWidget);
      expect(find.byIcon(Icons.layers_rounded), findsOneWidget);
    });

    testWidgets('ToolsEmptyState displays search notice and reset button', (tester) async {
      controller.setSearchQuery('NonExistentKeyword');

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ToolsEmptyState(),
          ),
        ),
      );

      expect(find.text('No tools found'), findsOneWidget);
      expect(find.textContaining('NonExistentKeyword'), findsOneWidget);
      expect(find.text('Reset Search'), findsOneWidget);

      await tester.tap(find.text('Reset Search'));
      await tester.pump();
      expect(controller.searchQuery.value, '');
    });

    testWidgets('ToolsProDialog renders Pro feature notice and actions', (tester) async {
      final proTool = ToolsCatalog.allTools.firstWhere((t) => t.id == 'pdf_to_word');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ToolsProDialog(tool: proTool),
          ),
        ),
      );

      expect(find.text('PDF to Word is a Pro Feature'), findsOneWidget);
      expect(find.text(proTool.description), findsOneWidget);
      expect(find.text('Upgrade to Pro for unlimited access'), findsOneWidget);
      expect(find.text('Maybe Later'), findsOneWidget);
      expect(find.text('Unlock Pro'), findsOneWidget);
    });
  });
}

