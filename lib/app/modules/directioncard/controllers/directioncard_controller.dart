import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart' as google_maps_places;
import 'package:mopedsafe/app/services/dio/api_service.dart';
import 'package:mopedsafe/app/services/responsive_size.dart';
import 'package:mopedsafe/app/services/storage.dart';
import 'package:mopedsafe/app/services/text_style_util.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../constants/image_constant.dart';
import '../../../customwidgets/globalcontroller.dart';
import '../../../models/googledirectionapiresponse.dart';
import '../../../models/offlineroutes.dart';
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
  final showShareOptions = false.obs;
  final currentPlaceName = ''.obs;
  final placeName = ''.obs;
  final placeRating = 0.0.obs;
  final openNow = ''.obs;
  final closingTime = ''.obs;
  final country = ''.obs;
  final waypointsStr = ''.obs;
  final currentHeading = 0.0.obs;
  Rxn<SaveRoutes> savedRoutes = Rxn();
  Rxn<OfflineRoutesData> saveOfflineRoutes = Rxn();
  final currentLocationController = TextEditingController();
  final destinationLocationController = TextEditingController();
  final globalController = Get.find<GlobalController>();

  final panelController = PanelController();

  late final GoogleMapController? mapController;
  late final StreamSubscription<Position>? positionStreamSubscription;
  final google_maps_places.GoogleMapsPlaces _places;
  Rxn<GetRoutes> getnewroutes = Rxn<GetRoutes>();
  Rx<LatLng> newcurrentPosition = LatLng(0, 0).obs;
  Rx<LatLng> newdestinationPosition = LatLng(0, 0).obs;
  Rx<CameraPosition> currentCameraPosition = const CameraPosition(
    target: LatLng(0, 0),
    zoom: 7,
  ).obs;
  dynamic getroutes;
  dynamic placeID;
  final previousRoute = Get.previousRoute;
  DirectioncardController()
      : _places = google_maps_places.GoogleMapsPlaces(
          apiKey: Get.find<GetStorageService>().googleApiKey,
        );

  @override
  void onInit() {
    super.onInit();
    print('initiiiiiiiiiiiii');
    _loadCustomChevronIcon();
    print('ffffff ${previousRoute}');
    decodePolyline();
    fetchPlaceDetails(placeID);
    updateMap();
    fetchCurrentLocationPlaceName();
    fetchSavedRoutes();
    newcurrentPosition.value = LatLng(globalController.currentLatitude.value,
        globalController.currentLongitude.value);
  }

  @override
  void onClose() {
    print('DirectioncardController is being closed');

    // Check if positionStreamSubscription is not null before cancelling
    positionStreamSubscription?.cancel();
    getroutes = null;
    placeID = null;
    // Dispose of the mapController safely
    mapController?.dispose();

    // Clear the controllers
    currentLocationController.clear();
    destinationLocationController.clear();

    super.onClose();
  }

  void onSourceLocationChanged(LatLng newLocation) async {
    // Update currentPosition with the new location
    newcurrentPosition.value = newLocation;

    // Update the camera position on the map to center the new location
    currentCameraPosition.value =
        CameraPosition(target: newcurrentPosition.value, zoom: 13);

    // Clear existing polyline coordinates and redraw them
    polylineCoordinates.clear();

    // Fetch new polylines from the new current location to the destination
    await getNewPolylines();
    addSourceLocationMarker(newLocation);
  }

  void onDestinationLocationChanged(LatLng newLocation) async {
    // Update the destination position with the new location
    newdestinationPosition.value = newLocation;

    // Add a new destination marker for the updated location

    // Update the camera position on the map to center the new location
    currentCameraPosition.value = CameraPosition(target: newLocation, zoom: 13);

    // Clear existing polyline coordinates and redraw them
    polylineCoordinates.clear();

    // Fetch new polylines from the current source location to the new destination
    await getNewPolylines();
    addDestinationLocationMarker(newLocation);
  }

  void addSourceLocationMarker(LatLng sourceLocation) {
    markers.clear();
    markers.add(Marker(
      markerId: const MarkerId('source_location'),
      position: sourceLocation,
      infoWindow: const InfoWindow(title: 'Source Location'),
      icon: userLocationIcon ??
          BitmapDescriptor.defaultMarker, // Use custom icon if available
    ));
    markers.add(Marker(
      markerId: const MarkerId('end'),
      position: endPoint.value!,
      infoWindow: const InfoWindow(title: 'End Point'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    ));
  }

  void addDestinationLocationMarker(LatLng destinationLocation) {
    markers.clear();
    markers.add(Marker(
      markerId: const MarkerId('source_location'),
      position: startPoint.value!,
      infoWindow: const InfoWindow(title: 'Source Location'),
      icon: userLocationIcon ??
          BitmapDescriptor.defaultMarker, // Use custom icon if available
    ));
    markers.add(Marker(
      markerId: const MarkerId('end'),
      position: destinationLocation,
      infoWindow: const InfoWindow(title: 'End Point'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    ));
  }

  Future<void> getNewPolylines() async {
    try {
      // Fetch new route details from the API
      final response = await APIManager.postGetRoutes(
        sourcelatitude: newcurrentPosition.value.latitude.toString(),
        sourcelongitude: newcurrentPosition.value.longitude.toString(),
        destinationlatitude: newdestinationPosition.value.latitude.toString(),
        destinationlongitude: newdestinationPosition.value.longitude.toString(),
      );

      if (response.statusCode == 200) {
        // Decode polyline and update the map
        final points = PolylinePoints().decodePolyline(response.data['points']);
        polylineCoordinates.value =
            points.map((e) => LatLng(e.latitude, e.longitude)).toList();
        updateMap();
      } else {
        print('Error fetching polylines: ${response.data}');
      }
    } catch (e) {
      print('Error in getNewPolylines: $e');
    }
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
      required List<dynamic> instructions}) async {
    APIManager.postSaveOfflineRoutes(
            points: points,
            time: time,
            distance: distance,
            type: type,
            instructions: instructions,
            placeID: placeId,
            startName: startName,
            endName: endName)
        .then((value) {
      saveOfflineRoutes.value = OfflineRoutesData.fromJson(value.data);
      Get.dialog(AlertDialog(
        content: Text(
          'Route Saved Successfully',
          style: TextStyleUtil.poppins500(fontSize: 14.kh),
        ),
      ));
      print('saveOfflineRoutes ${saveOfflineRoutes.value!}');
    });
  }

  void clearPlaceDetails() {
    print('clearing details ...........');
    //currentPlaceName.value = '';
    // placeRating.value = 0.0;
    // country.value = '';
    // openNow.value = '';
    // closingTime.value = '';
    // placeImages.clear();
    polylineCoordinates.clear(); // Clear previous polyline points
    markers.clear(); // Clear previous markers
    polylines.clear(); // Clear previous polylines
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
    // clearPlaceDetails();
    RxString encodedString = ''.obs;
    print(previousRoute);

    encodedString.value = globalController.directionCardData.value!.points;
    placeID = globalController.directionCardData.value!.placeID;

    final points = PolylinePoints().decodePolyline(encodedString.value);
    polylineCoordinates.value =
        points.map((point) => LatLng(point.latitude, point.longitude)).toList();

    if (polylineCoordinates.isNotEmpty) {
      startPoint.value = polylineCoordinates.first;
      endPoint.value = polylineCoordinates.last;
      fetchAndDisplayDirections(polylineCoordinates);
    }
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

  void clearPolylinesAndMarkers() {
    polylines.clear();
    markers.clear();
    update();
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
}
