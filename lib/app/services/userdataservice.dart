import 'package:get/get.dart';
import 'package:mopedsafe/app/models/userdetails.dart';

class UserService extends GetxService {
  Rxn<UserDetails> userDetails = Rxn<UserDetails>();

  Future<void> setUserDetails(UserDetails details) async {
    userDetails.value = details;
    print('username: ${userDetails.value!.name}');
  }
}
