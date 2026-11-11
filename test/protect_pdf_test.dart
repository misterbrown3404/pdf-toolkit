import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:pdf_toolkit/app/features/protect_pdf/models/protect_mode_enum.dart';
import 'package:pdf_toolkit/app/features/protect_pdf/protect_pdf_controller.dart';
import 'package:pdf_toolkit/app/features/protect_pdf/utils/password_strength_calculator.dart';
import 'package:pdf_toolkit/app/features/protect_pdf/widgets/protect_bottom_bar.dart';
import 'package:pdf_toolkit/app/features/protect_pdf/widgets/protect_file_card.dart';
import 'package:pdf_toolkit/app/features/protect_pdf/widgets/protect_header_banner.dart';
import 'package:pdf_toolkit/app/features/protect_pdf/widgets/protect_mode_selector.dart';
import 'package:pdf_toolkit/app/features/protect_pdf/widgets/protect_password_card.dart';
import 'package:pdf_toolkit/app/features/protect_pdf/widgets/protect_permissions_card.dart';
import 'package:pdf_toolkit/app/features/protect_pdf/widgets/protect_success_view.dart';
import 'package:pdf_toolkit/app/features/protect_pdf/widgets/protect_warning_card.dart';
import 'package:pdf_toolkit/app/shared/models/pdf_document_model.dart';

void main() {
  group('Protect & Unlock PDF Feature Tests', () {
    test('PasswordStrengthCalculator accurately scores passwords', () {
      final empty = PasswordStrengthCalculator.calculate('');
      expect(empty.score, 0);
      expect(empty.label, '');

      final weak = PasswordStrengthCalculator.calculate('abc');
      expect(weak.score, 1);
      expect(weak.label, 'Weak strength');

      final medium = PasswordStrengthCalculator.calculate('pass1234');
      expect(medium.score, 2);
      expect(medium.label, 'Medium strength');

      final strong = PasswordStrengthCalculator.calculate('Secret@9876!');
      expect(strong.score, 3);
      expect(strong.label, 'Strong password');
    });

    testWidgets('ProtectHeaderBanner renders correct titles for protect and unlock modes', (tester) async {
      bool backTapped = false;

      // 1. Protect mode
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProtectHeaderBanner(
              mode: ProtectMode.protect,
              onBack: () => backTapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Protect PDF'), findsOneWidget);
      expect(find.text('Add a password to keep your PDF safe and private.'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pump();
      expect(backTapped, isTrue);

      // 2. Unlock mode
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProtectHeaderBanner(
              mode: ProtectMode.unlock,
            ),
          ),
        ),
      );

      expect(find.text('Unlock PDF'), findsOneWidget);
      expect(find.text('Remove password protection from your secured PDF.'), findsOneWidget);
    });

    testWidgets('ProtectModeSelector allows switching between protect and unlock', (tester) async {
      ProtectMode currentMode = ProtectMode.protect;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => ProtectModeSelector(
                currentMode: currentMode,
                onModeChanged: (newMode) => setState(() => currentMode = newMode),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Protect PDF'), findsOneWidget);
      expect(find.text('Unlock PDF'), findsOneWidget);

      await tester.tap(find.text('Unlock PDF'));
      await tester.pump();
      expect(currentMode, ProtectMode.unlock);
    });

    testWidgets('ProtectFileCard handles empty state and selected file state', (tester) async {
      bool pickTapped = false;
      bool clearTapped = false;

      // 1. Empty state
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProtectFileCard(
              selectedPdf: null,
              mode: ProtectMode.protect,
              onPickPdf: () => pickTapped = true,
              onClearPdf: () => clearTapped = true,
              onSelectRecent: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Select PDF to Protect'), findsOneWidget);
      expect(find.text('Choose PDF Document'), findsOneWidget);

      await tester.tap(find.text('Choose PDF Document'));
      await tester.pump();
      expect(pickTapped, isTrue);

      // 2. Selected document state
      final pdf = PdfDocumentModel(
        id: '1',
        name: 'Project_Proposal.pdf',
        path: '/tmp/Project_Proposal.pdf',
        sizeInBytes: 2516582,
        pageCount: 1,
        modifiedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProtectFileCard(
              selectedPdf: pdf,
              mode: ProtectMode.protect,
              onPickPdf: () {},
              onClearPdf: () => clearTapped = true,
              onSelectRecent: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Project_Proposal.pdf'), findsOneWidget);
      expect(find.text('1 page • 2.40 MB'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pump();
      expect(clearTapped, isTrue);
    });

    testWidgets('ProtectPasswordCard renders inputs, strength bar, and match indicator', (tester) async {
      final p1Ctrl = TextEditingController(text: 'secret123');
      final p2Ctrl = TextEditingController(text: 'secret123');
      final strength = PasswordStrengthCalculator.calculate('secret123');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProtectPasswordCard(
              mode: ProtectMode.protect,
              passwordController: p1Ctrl,
              confirmPasswordController: p2Ctrl,
              isPasswordObscured: true,
              isConfirmPasswordObscured: true,
              onTogglePasswordVisibility: () {},
              onToggleConfirmPasswordVisibility: () {},
              strength: strength,
              passwordsMatch: true,
              onPasswordChanged: (_) {},
              onConfirmPasswordChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Set Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.text('Medium strength'), findsOneWidget);
      expect(find.text('Passwords match'), findsOneWidget);
    });

    testWidgets('ProtectWarningCard renders alert message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProtectWarningCard(),
          ),
        ),
      );

      expect(find.text('Important'), findsOneWidget);
      expect(find.text('If you forget this password, you may not be able to open the PDF later.'), findsOneWidget);
    });

    testWidgets('ProtectPermissionsCard renders AES badge and toggles', (tester) async {
      bool printVal = true;
      bool copyVal = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => ProtectPermissionsCard(
                allowPrinting: printVal,
                allowCopying: copyVal,
                onPrintingChanged: (v) => setState(() => printVal = v),
                onCopyingChanged: (v) => setState(() => copyVal = v),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Security & Permissions'), findsOneWidget);
      expect(find.text('AES-256 Bit'), findsOneWidget);
      expect(find.text('Allow Printing'), findsOneWidget);
      expect(find.text('Allow Copying Content'), findsOneWidget);
    });

    testWidgets('ProtectBottomBar displays correct state and responds to tap', (tester) async {
      bool actionTapped = false;

      // Valid state
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProtectBottomBar(
              mode: ProtectMode.protect,
              hasSelectedPdf: true,
              isFormValid: true,
              isProcessing: false,
              onAction: () => actionTapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Protect PDF'), findsOneWidget);
      await tester.tap(find.text('Protect PDF'));
      await tester.pump();
      expect(actionTapped, isTrue);
    });

    testWidgets('ProtectSuccessView renders success summary and action buttons', (tester) async {
      final controller = Get.put(ProtectPdfController());
      controller.generatedPdfPath.value = '/tmp/Project_Proposal_(Protected).pdf';
      controller.generatedPdfSize.value = 2516582; // 2.40 MB
      controller.generatedPdfPages.value = 1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProtectSuccessView(controller: controller),
          ),
        ),
      );

      expect(find.text('PDF Protected!'), findsOneWidget);
      expect(find.text('Project_Proposal_(Protected).pdf'), findsOneWidget);
      expect(find.text('1 page • 2.40 MB'), findsOneWidget);
      expect(find.text('Password Protected'), findsOneWidget);
      expect(find.text('Open PDF'), findsOneWidget);
      expect(find.text('Share PDF'), findsOneWidget);
      expect(find.text('Protect Another PDF'), findsOneWidget);
      expect(find.text('Back to Home'), findsOneWidget);

      Get.delete<ProtectPdfController>();
    });

    test('ProtectPdfController manages modes, inputs, validations and reset', () {
      final controller = Get.put(ProtectPdfController());
      final pdf = PdfDocumentModel(
        id: 'p_1',
        name: 'Report.pdf',
        path: '/tmp/Report.pdf',
        sizeInBytes: 1048576,
        pageCount: 4,
        modifiedAt: DateTime.now(),
      );

      controller.selectRecentPdf(pdf);
      expect(controller.selectedPdf.value, isNotNull);
      expect(controller.isFormValid, isFalse);

      controller.passwordController.text = 'Password123';
      controller.updatePassword('Password123');
      expect(controller.strength.value.score, 2);

      controller.confirmPasswordController.text = 'Password123';
      controller.updateConfirmPassword('Password123');
      expect(controller.passwordsMatch.value, isTrue);
      expect(controller.isFormValid, isTrue);

      controller.setMode(ProtectMode.unlock);
      expect(controller.mode.value, ProtectMode.unlock);
      expect(controller.passwordController.text, isEmpty);

      controller.reset();
      expect(controller.isSuccess.value, isFalse);
      expect(controller.generatedPdfPath.value, isEmpty);

      controller.clearPdf();
      expect(controller.selectedPdf.value, isNull);

      Get.delete<ProtectPdfController>();
    });
  });
}
