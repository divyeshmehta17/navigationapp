import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mopedsafe/app/models/fetchcommunitypost.dart';
import 'package:mopedsafe/app/services/dio/api_service.dart';

class CommunityController extends GetxController {
  // Observables for state management
  final count = 0.obs;
  RxDouble rangeStart = 0.0.obs;
  RxDouble rangeEnd = 10.0.obs;
  RxList<bool> isSelected = [true, false, false].obs;
  final ImagePicker picker = ImagePicker();
  Rx<XFile?> imageFile = Rx<XFile?>(null);
  RxList<IncidentReport> incidentReports = <IncidentReport>[].obs;
  Rxn<FetchCommunityPost> fetchCommunityPost = Rxn<FetchCommunityPost>();

  // Method to pick an image from a source
  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? selectedImage = await picker.pickImage(source: source);
      imageFile.value = selectedImage;
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  // Method to add a new incident report
  void addIncidentReport(IncidentReport report) {
    incidentReports.add(report);
  }

  // Method to handle button tap event
  void handleButtonTap(int index) {
    isSelected.assignAll(List.generate(isSelected.length, (i) => i == index));
    update(); // Notify GetX to update the UI
  }

  // Method to fetch community posts from API
  Future<void> fetchCommunityPostApi(
      //     {
      //   required double latitude,
      //   required double longitude,
      //   required double distance,
      //   required int days,
      // }
      ) async {
    try {
      await APIManager.getFetchCommunityPost(
              latitude: 40.712776, longitude: -73.947974, distance: 10, days: 1)
          .then((onValue) {
        fetchCommunityPost.value = FetchCommunityPost.fromJson(onValue.data);
        print(fetchCommunityPost.value!.data![0]!.location?.addressLine);
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch community posts: $e');
    }
  }

  @override
  void onInit() {
    fetchCommunityPostApi();
  }
}

// Model class for incident report
class IncidentReport {
  final String type;
  final String location;
  final String dummyName;
  final String details;
  final String imagePath;
  final DateTime time;

  IncidentReport({
    required this.type,
    required this.location,
    required this.details,
    required this.dummyName,
    required this.imagePath,
    required this.time,
  });
}
