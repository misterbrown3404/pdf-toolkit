import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:pdf_toolkit/app/features/premium/models/premium_plan_model.dart';
import 'package:pdf_toolkit/app/features/premium/premium_controller.dart';
import 'package:pdf_toolkit/app/features/premium/premium_view.dart';
import 'package:pdf_toolkit/app/features/premium/widgets/premium_action_button.dart';
import 'package:pdf_toolkit/app/features/premium/widgets/premium_active_view.dart';
import 'package:pdf_toolkit/app/features/premium/widgets/premium_features_card.dart';
import 'package:pdf_toolkit/app/features/premium/widgets/premium_header_banner.dart';
import 'package:pdf_toolkit/app/features/premium/widgets/premium_plan_tile.dart';
import 'package:pdf_toolkit/app/features/premium/widgets/premium_plans_selector.dart';
import 'package:pdf_toolkit/app/features/premium/widgets/premium_success_view.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PremiumController controller;

  setUp(() {
    Get.reset();
    Get.testMode = true;
    controller = PremiumController();
    Get.put<PremiumController>(controller);
  });

  tearDown(() {
    Get.reset();
  });

  group('Premium Feature Models & Controller Tests', () {
    test('PremiumPlanModel contains default tiers with correct pricing', () {
      final plans = PremiumPlanModel.defaultPlans;
      expect(plans.length, 3);
      expect(plans[0].id, 'monthly');
      expect(plans[0].price, '₦2,500');
      expect(plans[1].id, 'yearly');
      expect(plans[1].savingsBadge, 'Save 40%');
      expect(plans[2].id, 'lifetime');
      expect(plans[2].isLifetime, true);
    });

    test('PremiumController initializes with yearly default and switches plans', () {
      expect(controller.selectedPlanId.value, 'yearly');
      expect(controller.currentSelectedPlan.title, 'Yearly');

      controller.selectPlan('monthly');
      expect(controller.selectedPlanId.value, 'monthly');
      expect(controller.currentSelectedPlan.title, 'Monthly');

      controller.selectPlan('lifetime');
      expect(controller.selectedPlanId.value, 'lifetime');
      expect(controller.currentSelectedPlan.isLifetime, true);
    });

    test('PremiumController purchasePlan sets state and triggers celebration', () async {
      controller.selectPlan('yearly');
      await controller.purchasePlan();

      expect(controller.isSuccessCelebration.value, true);
      expect(controller.isManageSubscription.value, true);
      expect(controller.activePlanName.value, contains('Yearly'));
    });

    test('PremiumController startUsingPremium resets celebration', () {
      controller.isSuccessCelebration.value = true;
      controller.startUsingPremium();
      expect(controller.isSuccessCelebration.value, false);
    });
  });

  group('Premium Feature Widgets Tests', () {
    testWidgets('PremiumHeaderBanner displays title and subtitle', (tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: Scaffold(
            body: PremiumHeaderBanner(),
          ),
        ),
      );

      expect(find.text('Upgrade to\nPremium'), findsOneWidget);
      expect(find.text('Unlock full access to all PDF tools'), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('PremiumFeaturesCard renders all 4 key benefits', (tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: Scaffold(
            body: PremiumFeaturesCard(),
          ),
        ),
      );

      expect(find.text('Unlimited PDF tools'), findsOneWidget);
      expect(find.text('Ad-free experience'), findsOneWidget);
      expect(find.text('Higher file limits'), findsOneWidget);
      expect(find.text('Priority support'), findsOneWidget);
    });

    testWidgets('PremiumPlanTile renders title, price, savings badge, and responds to tap', (tester) async {
      var tapped = false;
      final plan = PremiumPlanModel.defaultPlans[1]; // Yearly

      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: PremiumPlanTile(
              plan: plan,
              isSelected: true,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Yearly'), findsOneWidget);
      expect(find.text('Save 40%'), findsOneWidget);
      expect(find.text('₦18,000'), findsOneWidget);

      await tester.tap(find.byType(PremiumPlanTile));
      expect(tapped, true);
    });

    testWidgets('PremiumPlansSelector renders all 3 pricing plan tiles', (tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: Scaffold(
            body: PremiumPlansSelector(),
          ),
        ),
      );

      expect(find.byType(PremiumPlanTile), findsNWidgets(3));
      expect(find.text('Monthly'), findsOneWidget);
      expect(find.text('Yearly'), findsOneWidget);
      expect(find.text('Lifetime'), findsOneWidget);
    });

    testWidgets('PremiumActionButton renders upgrade button and restore action', (tester) async {
      await tester.pumpWidget(
        const GetMaterialApp(
          home: Scaffold(
            body: PremiumActionButton(),
          ),
        ),
      );

      expect(find.text('Upgrade Now'), findsOneWidget);
      expect(find.text('Restore Purchase'), findsOneWidget);
    });

    testWidgets('PremiumSuccessView renders celebration headline and CTA', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const GetMaterialApp(
          home: Scaffold(
            body: PremiumSuccessView(),
          ),
        ),
      );

      expect(find.text("You're Premium Now! 🎉"), findsOneWidget);
      expect(find.text('Start Using Premium'), findsOneWidget);
      expect(find.text('Premium Plan'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
    });

    testWidgets('PremiumActiveView renders active plan details and Done action', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const GetMaterialApp(
          home: Scaffold(
            body: PremiumActiveView(),
          ),
        ),
      );

      expect(find.text('Premium Active'), findsOneWidget);
      expect(find.text('Your Pro Benefits'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
      expect(find.text('Change Subscription Plan'), findsOneWidget);
    });

    testWidgets('PremiumView renders full paywall screen', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const GetMaterialApp(
          home: PremiumView(),
        ),
      );

      expect(find.byType(PremiumHeaderBanner), findsOneWidget);
      expect(find.byType(PremiumFeaturesCard), findsOneWidget);
      expect(find.byType(PremiumPlansSelector), findsOneWidget);
      expect(find.byType(PremiumActionButton), findsOneWidget);
    });
  });
}
