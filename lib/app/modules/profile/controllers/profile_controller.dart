import 'package:get/get.dart';
import 'package:mopedsafe/app/models/userdetails.dart';
import 'package:mopedsafe/app/services/storage.dart'; // Import GetStorageService

class ProfileController extends GetxController {
  Rxn<UserDetails> userDetails = Rxn<UserDetails>();
  RxBool isSubscribed = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserDetails();
  }

  @override
  void onReady() {
    super.onReady();
    _loadUserDetails();
  }

  void _loadUserDetails() {
    // Read the user details from storage
    final storedData = GetStorageService.appstorage.read('userdetails');
    if (storedData != null && storedData is Map<String, dynamic>) {
      // Deserialize the map into a UserDetails object
      userDetails.value = UserDetails.fromJson(storedData);
    } else {
      print("User details not found. Please log in.");
    }
  }
}
