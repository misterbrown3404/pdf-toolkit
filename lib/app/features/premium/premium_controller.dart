import 'package:get/get.dart';
import '../../core/services/billing_service.dart';

class PremiumController extends GetxController {
  final BillingService billingService = Get.find<BillingService>();
  final RxString selectedPlan = 'monthly'.obs;
}

