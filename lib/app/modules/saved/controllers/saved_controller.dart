import 'package:get/get.dart';
import 'package:mopedsafe/app/models/saveroutes.dart';
import 'package:mopedsafe/app/services/dio/api_service.dart';

import '../../../models/getsavedroutes.dart';
import '../../../models/polylinestrack.dart';

class SavedController extends GetxController {
  Rxn<SaveRoutes> savedRoutes = Rxn();
  Rxn<GetSavedRoutes> getsavedRoutes = Rxn();

  @override
  void onInit() {
    fetchSavedRoutes();
  }

  Future<void> postSaveRoute(
      String points,
      String type,
      int time,
      String startName,
      String endName,
      double distance,
      List<GetRoutesDataInstructions> instructions) async {
    APIManager.postSaveRoutes(
            points: points,
            time: time,
            distance: distance,
            type: type,
            instructions: instructions,
            startName: startName,
            endName: endName)
        .then((value) {
      savedRoutes.value = SaveRoutes.fromJson(value.data);
      print('saved time ${savedRoutes.value!.data!.time}');
    });
  }

  Future<void> fetchSavedRoutes() async {
    await APIManager.getFetchSavedRoutes(type: 'SAVED').then((response) {
      getsavedRoutes.value = GetSavedRoutes.fromJson(response.data);
    });
  }
}
