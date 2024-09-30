import 'package:get/get.dart';
import 'package:mopedsafe/app/models/userdetails.dart';
import 'package:mopedsafe/app/services/userdataservice.dart';

class ProfileController extends GetxController {
  Rxn<UserDetails> userDetails = Rxn<UserDetails>();
  RxBool isSubscribed = false.obs;
  @override
  void onInit() {
    userDetails.value = Get.find<UserService>().userDetails.value;
    super.onInit();
  }
}
