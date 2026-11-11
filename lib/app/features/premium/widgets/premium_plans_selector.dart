import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../premium_controller.dart';
import 'premium_plan_tile.dart';

class PremiumPlansSelector extends StatelessWidget {
  const PremiumPlansSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PremiumController>();

    return Obx(() {
      final selected = controller.selectedPlanId.value;

      return Column(
        children: controller.plans.map((plan) {
          final isSelected = plan.id == selected;
          return PremiumPlanTile(
            plan: plan,
            isSelected: isSelected,
            onTap: () => controller.selectPlan(plan.id),
          );
        }).toList(),
      );
    });
  }
}

