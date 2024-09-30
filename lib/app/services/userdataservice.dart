import 'package:get/get.dart';
import 'package:mopedsafe/app/models/userdetails.dart';

class UserService extends GetxService {
  Rxn<UserDetails> userDetails = Rxn<UserDetails>();

  void setUserDetails(UserDetails details) {
    userDetails.value = details;
    print('username: ${userDetails.value!.name}');
  }
}
