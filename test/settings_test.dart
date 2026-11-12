import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:pdf_toolkit/app/features/settings/settings_controller.dart';
import 'package:pdf_toolkit/app/features/settings/widgets/settings_about_dialog.dart';
import 'package:pdf_toolkit/app/features/settings/widgets/settings_header_banner.dart';
import 'package:pdf_toolkit/app/features/settings/widgets/settings_plan_card.dart';
import 'package:pdf_toolkit/app/features/settings/widgets/settings_pro_banner.dart';
import 'package:pdf_toolkit/app/features/settings/widgets/settings_section_card.dart';
import 'package:pdf_toolkit/app/features/settings/widgets/settings_theme_dialog.dart';
import 'package:pdf_toolkit/app/features/settings/widgets/settings_tile.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Settings Controller Logic', () {
    late SettingsController controller;

    setUp(() {
      Get.reset();
      controller = SettingsController();
      Get.put<SettingsController>(controller);
    });

    tearDown(() {
      Get.reset();
    });

    test('Initial controller state has expected defaults', () {
      expect(controller.currentThemeMode.value, ThemeMode.system);
      expect(controller.themeModeName, 'System');
      expect(controller.notificationsEnabled.value, isTrue);
      expect(controller.defaultCompression.value, isTrue);
      expect(controller.passwordReminder.value, isFalse);
      expect(controller.defaultWatermark.value, isFalse);
      expect(controller.defaultPageFormat.value, 'A4');
      expect(controller.language.value, contains('English'));
      expect(controller.isClearingCache.value, isFalse);
    });

    test('Toggling preferences updates state values correctly', () {
      controller.toggleNotifications(false);
      expect(controller.notificationsEnabled.value, isFalse);

      controller.toggleDefaultCompression(false);
      expect(controller.defaultCompression.value, isFalse);

      controller.togglePasswordReminder(true);
      expect(controller.passwordReminder.value, isTrue);

      controller.toggleDefaultWatermark(true);
      expect(controller.defaultWatermark.value, isTrue);

      controller.setPageFormat('US Letter');
      expect(controller.defaultPageFormat.value, 'US Letter');
    });

    test('ThemeMode updates and formatted name work accurately', () async {
      await controller.setThemeMode(ThemeMode.light);
      expect(controller.currentThemeMode.value, ThemeMode.light);
      expect(controller.themeModeName, 'Light');

      await controller.setThemeMode(ThemeMode.dark);
      expect(controller.currentThemeMode.value, ThemeMode.dark);
      expect(controller.themeModeName, 'Dark');
    });

    test('Storage formatting produces clean strings', () {
      controller.appStorageBytes.value = 512;
      expect(controller.formattedAppStorage, '512 B');

      controller.appStorageBytes.value = 1024 * 500;
      expect(controller.formattedAppStorage, contains('KB'));

      controller.appStorageBytes.value = 1024 * 1024 * 15;
      expect(controller.formattedAppStorage, contains('MB'));

      controller.cacheSizeBytes.value = 1024 * 200;
      expect(controller.formattedCacheSize, contains('KB'));
    });
  });

  group('Settings Widgets', () {
    late SettingsController controller;

    setUp(() {
      Get.reset();
      controller = SettingsController();
      Get.put<SettingsController>(controller);
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('SettingsHeaderBanner displays title and gear icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SettingsHeaderBanner(),
          ),
        ),
      );

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Manage your app and preferences'), findsOneWidget);
      expect(find.byIcon(Icons.settings_rounded), findsOneWidget);
    });

    testWidgets('SettingsPlanCard renders app name and version', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SettingsPlanCard(),
          ),
        ),
      );

      expect(find.text('PDF Toolkit'), findsOneWidget);
      expect(find.text('All-in-one PDF tools • v1.0.0'), findsOneWidget);
    });

    testWidgets('SettingsProBanner returns SizedBox.shrink when Pro is hidden', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SettingsProBanner(),
          ),
        ),
      );

      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('SettingsSectionCard displays header title and children', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SettingsSectionCard(
              title: 'Test Section',
              children: [
                Text('Child Item 1'),
                Text('Child Item 2'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Test Section'), findsOneWidget);
      expect(find.text('Child Item 1'), findsOneWidget);
      expect(find.text('Child Item 2'), findsOneWidget);
    });

    testWidgets('SettingsTile renders icon, title, subtitle, and trailing', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsTile(
              icon: Icons.palette_outlined,
              iconColor: Colors.orange,
              title: 'Appearance',
              subtitle: 'Light, Dark, or System',
              trailing: const Text('System >'),
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Appearance'), findsOneWidget);
      expect(find.text('Light, Dark, or System'), findsOneWidget);
      expect(find.text('System >'), findsOneWidget);
      expect(find.byIcon(Icons.palette_outlined), findsOneWidget);

      await tester.tap(find.text('Appearance'));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('SettingsThemeDialog presents all 3 theme options', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SettingsThemeDialog(),
          ),
        ),
      );

      expect(find.text('App Appearance'), findsOneWidget);
      expect(find.text('System Default'), findsOneWidget);
      expect(find.text('Light Mode'), findsOneWidget);
      expect(find.text('Dark Mode'), findsOneWidget);

      await tester.tap(find.text('Dark Mode'));
      await tester.pump();
      expect(controller.currentThemeMode.value, ThemeMode.dark);
    });

    testWidgets('SettingsAboutDialog renders version and close action', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SettingsAboutDialog(),
          ),
        ),
      );

      expect(find.text('PDF Toolkit'), findsOneWidget);
      expect(find.textContaining('Version 2.0.3'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
      expect(find.textContaining('Zero Data Collection'), findsOneWidget);
    });
  });
}

