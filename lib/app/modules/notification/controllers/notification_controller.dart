import 'package:get/get.dart';

class NotificationController extends GetxController {
  // Observable variables for each switch
  var navigational = true.obs;
  var promotional = true.obs;
  var alerts = true.obs;
  var community = true.obs;

  // Toggle functions for each switch
  void toggleNavigational() => navigational.value = !navigational.value;
  void togglePromotional() => promotional.value = !promotional.value;
  void toggleAlerts() => alerts.value = !alerts.value;
  void toggleCommunity() => community.value = !community.value;
}
