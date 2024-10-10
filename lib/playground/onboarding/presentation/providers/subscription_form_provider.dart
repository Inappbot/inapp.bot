import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubscriptionForm {
  String email = '';
  String name = '';
}

final subscriptionFormProvider = StateProvider<SubscriptionForm>((ref) {
  return SubscriptionForm();
});
