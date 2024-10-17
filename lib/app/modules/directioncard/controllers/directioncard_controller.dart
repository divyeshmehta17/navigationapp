import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart' as google_maps_places;
import 'package:mopedsafe/app/services/dio/api_service.dart';
import 'package:mopedsafe/app/services/storage.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../constants/image_constant.dart';
import '../../../customwidgets/globalcontroller.dart';
import '../../../models/googledirectionapiresponse.dart';
import '../../../models/polylinestrack.dart';
import '../../../models/saveroutes.dart';

class DirectioncardController extends GetxController {
  final polylineCoordinates = RxList<LatLng>();
  final navigationPolylineCoordinates = RxList<LatLng>();
  final startPoint = Rxn<LatLng>();
  final endPoint = Rxn<LatLng>();
  final googledirectionApiResponse = Rxn<GoogleDIrectionApiResponse>();
  final placeImages = <String>[].obs;
  final polylines = RxSet<Polyline>();
  final markers = RxSet<Marker>();
  final showLocationOptions = false.obs;
  final currentPlaceName = ''.obs;
  final placeName = ''.obs;
  final placeRating = 0.0.obs;
  final openNow = ''.obs;
  final closingTime = ''.obs;
  final country = ''.obs;
  final waypointsStr = ''.obs;
  final currentHeading = 0.0.obs;
  Rxn<SaveRoutes> savedRoutes = Rxn();
  final currentLocationController = TextEditingController();
  final destinationLocationController = TextEditingController();
  final globalController = Get.find<GlobalController>();

  final panelController = PanelController();

  late final GoogleMapController? mapController;
  late final StreamSubscription<Position>? positionStreamSubscription;
  final google_maps_places.GoogleMapsPlaces _places;

  LatLng currentPosition = const LatLng(0, 0);

  final getroutes = Get.arguments['getroutes'];
  final placeID = Get.arguments['placeID'];

  DirectioncardController()
      : _places = google_maps_places.GoogleMapsPlaces(
          apiKey: Get.find<GetStorageService>().googleApiKey,
        );

  @override
  void onInit() {
    super.onInit();
    _loadCustomChevronIcon();
    decodePolyline();
    fetchPlaceDetails(placeID);
    updateMap();
    fetchCurrentLocationPlaceName();
    fetchSavedRoutes();
    currentPosition = LatLng(globalController.currentLatitude.value,
        globalController.currentLongitude.value);
  }

  void toggleGetDirection() {
    showLocationOptions.value = !showLocationOptions.value;
  }

  Future<BitmapDescriptor> _getBitmapDescriptorFromAsset(
      String assetPath) async {
    final Completer<BitmapDescriptor> bitmapDescriptor = Completer();
    const ImageConfiguration config = ImageConfiguration(devicePixelRatio: 2.5);
    BitmapDescriptor.asset(config, assetPath).then((icon) {
      bitmapDescriptor.complete(icon);
    });
    return bitmapDescriptor.future;
  }

  Future<void> postSaveRoute(
      {required String points,
      required String type,
      required int time,
      required double distance,
      required String startName,
      required String endName,
      String? placeId,
      required List<GetRoutesDataInstructions> instructions}) async {
    APIManager.postSaveRoutes(
            points: points,
            time: time,
            distance: distance,
            type: type,
            instructions: instructions,
            placeID: placeId,
            startName: startName,
            endName: endName)
        .then((value) {
      savedRoutes.value = SaveRoutes.fromJson(value.data);
      print('saved time ${savedRoutes.value!.data!.time}');
    });
  }

  Future<void> fetchPlaceDetails(String placeId) async {
    final details = await _places.getDetailsByPlaceId(placeId);
    placeName.value = details.result.name;
    placeRating.value = details.result.rating?.toDouble() ?? 0.0;
    country.value = details.result.vicinity.toString();

    final openingHours = details.result.openingHours;
    if (openingHours != null) {
      openNow.value = openingHours.openNow ? 'Open Now' : 'Closed';
      if (openingHours.periods.isNotEmpty) {
        closingTime.value =
            'Closes at ${openingHours.periods.first.close!.time}';
      }
    }

    final photos = details.result.photos;
    if (photos.isNotEmpty) {
      placeImages.value = photos
          .map((photo) => _places.buildPhotoUrl(
                photoReference: photo.photoReference,
                maxWidth: 400,
              ))
          .toList();
    }
  }

  void decodePolyline() {
    final savedpoints = Get.arguments['points'];
    final points = PolylinePoints().decodePolyline(savedpoints);
    polylineCoordinates.value =
        points.map((point) => LatLng(point.latitude, point.longitude)).toList();

    if (polylineCoordinates.isNotEmpty) {
      startPoint.value = polylineCoordinates.first;
      endPoint.value = polylineCoordinates.last;
      fetchAndDisplayDirections(polylineCoordinates);
    }
    print('points ${getroutes.data!.points}');
  }

  Future<void> fetchSavedRoutes() async {
    APIManager.getFetchSavedRoutes(type: 'SAVED').then((response) {
      savedRoutes.value = SaveRoutes.fromJson(response.data);
      print('saved routes ${savedRoutes.value!.data!.instructions}');
    });
  }

  Future<void> fetchAndDisplayDirections(List<LatLng> waypoints) async {
    try {
      final directions = await getDirections(waypoints);
      parseDirections(directions);
    } catch (e) {
      print('Error fetching directions: $e');
    }
  }

  Future<Map<String, dynamic>> getDirections(List<LatLng> waypoints) async {
    final reducedWaypoints = reduceWaypoints(waypoints, maxWaypoints: 25);
    waypointsStr.value = formatWaypoints(reducedWaypoints);

    final response = await APIManager.getGoogleDirections(
      waypoints: reducedWaypoints,
      currentLatitude: globalController.currentLatitude.value,
      currentLongitude: globalController.currentLongitude.value,
      destinationLatitude: globalController.destinationLatitude.value,
      destinationLongitude: globalController.destinationLongitude.value,
      waypointsStr: waypointsStr.value,
      googleApiKey: Get.find<GetStorageService>().googleApiKey,
    );
    googledirectionApiResponse.value =
        GoogleDIrectionApiResponse.fromJson(response.data);
    return response.data;
  }

  void parseDirections(Map<String, dynamic> directions) {
    if (directions['status'] == 'OK') {
      final routes = directions['routes'] as List<dynamic>;
      if (routes.isNotEmpty) {
        final steps = routes[0]['legs'][0]['steps'] as List<dynamic>;

        for (var step in steps) {
          final instruction = step['html_instructions'];
          final distance = step['distance']['text'];
          final duration = step['duration']['text'];
          final maneuver = step['maneuver'] ?? 'Continue';

          print(
              'Instruction: $instruction, Distance: $distance, Duration: $duration, Maneuver: $maneuver');
        }
      }
    } else {
      print('Error: ${directions['status']}');
    }
  }

  List<LatLng> reduceWaypoints(List<LatLng> waypoints,
      {int maxWaypoints = 25}) {
    if (waypoints.length <= maxWaypoints) return waypoints;

    final step = (waypoints.length / maxWaypoints).ceil();
    return List.generate(waypoints.length ~/ step, (i) => waypoints[i * step])
      ..add(waypoints.last);
  }

  String formatWaypoints(List<LatLng> waypoints) {
    return waypoints
        .map((point) => '${point.latitude},${point.longitude}')
        .join('|');
  }

  void _loadCustomChevronIcon() async {
    userLocationIcon =
        await _getBitmapDescriptorFromAsset(ImageConstant.pnguserlocation);
    updateMap(); // Update the map with the new marker once loaded
  }

  BitmapDescriptor? userLocationIcon;
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
        icon: userLocationIcon ?? BitmapDescriptor.defaultMarker,
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

  Future<void> fetchCurrentLocationPlaceName() async {
    try {
      final placemarks = await placemarkFromCoordinates(
        globalController.currentLatitude.value,
        globalController.currentLongitude.value,
      );

      if (placemarks.isNotEmpty) {
        currentPlaceName.value = placemarks.first.name ?? 'Unknown Location';
        print('currentplace : $currentPlaceName');
      }
      print('currentplace : $currentPlaceName');
    } catch (e) {
      print("Error fetching place name: $e");
    }
  }

  Rx<CameraPosition> currentCameraPosition = CameraPosition(
    target: LatLng(0, 0), // Initial default position
    zoom: 7,
  ).obs;
  @override
  void onClose() {
    positionStreamSubscription?.cancel();
    mapController?.dispose();
    super.onClose();
  }
}
