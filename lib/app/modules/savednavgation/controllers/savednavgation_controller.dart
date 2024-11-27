import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SavednavgationController extends GetxController {
  //TODO: Implement SavednavgationController

  final count = 0.obs;
  LatLng currentPosition = const LatLng(0, 0);
  final panelController = PanelController();
  final showLocationOptions = false.obs;
  final sourcePlaceName = ''.obs;
  final destinationPlaceName = ''.obs;
  final currentLocationController = TextEditingController();
  final destinationLocationController = TextEditingController();
  final placeName = ''.obs;
  final placeRating = 0.0.obs;
  final openNow = ''.obs;
  final closingTime = ''.obs;
  final country = ''.obs;
  final placeImages = <String>[].obs;
  final polylines = RxSet<Polyline>();
  final polylineCoordinates = RxList<LatLng>();
  final markers = RxSet<Marker>();
  final startPoint = Rxn<LatLng>();
  final endPoint = Rxn<LatLng>();
  final getSavedRoutes = Get.arguments['getsavedRoutes'];
  @override
  void onInit() {
    super.onInit();
    decodePolyline();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> updateMap() async {
    polylines.clear();
    polylines.add(Polyline(
      polylineId: const PolylineId('navigation_polyline'),
      points: polylineCoordinates,
      color: Colors.blue,
      width: 5,
    ));

    markers.clear();
    if (startPoint.value != null) {
      markers.add(Marker(
        markerId: const MarkerId('start'),
        position: startPoint.value!,
        infoWindow: const InfoWindow(title: 'Start Point'),
        icon: BitmapDescriptor.defaultMarker,
      ));
    }

    if (endPoint.value != null) {
      markers.add(Marker(
        markerId: const MarkerId('end'),
        position: endPoint.value!,
        infoWindow: const InfoWindow(title: 'End Point'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));
    }
  }

  void decodePolyline() {
    print('pointss ${getSavedRoutes!.value!.data!.results![0]!.points}');
    final points = PolylinePoints()
        .decodePolyline(getSavedRoutes!.value!.data!.results![0]!.points);
    polylineCoordinates.value =
        points.map((point) => LatLng(point.latitude, point.longitude)).toList();

    if (polylineCoordinates.isNotEmpty) {
      startPoint.value = polylineCoordinates.first;
      endPoint.value = polylineCoordinates.last;
      sourcePlaceName.value =
          getSavedRoutes!.value!.data!.results![0]!.startName;
      destinationPlaceName.value =
          getSavedRoutes!.value!.data!.results![0]!.endName;
      updateMap();
    }
  }
}
