import 'app_exception.dart';

class BillingException extends AppException {
  BillingException(super.message, {super.code, super.details});
}

