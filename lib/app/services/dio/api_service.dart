import 'dart:io';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http_parser/http_parser.dart';

import '../../models/polylinestrack.dart';
import 'client.dart';
import 'endpoints.dart';

class APIManager {
  ///Post API
  static Future<Response> postGetRoutes(
      {bool showSnakbar = true,
      required String sourcelatitude,
      required String sourcelongitude,
      required String destinationlatitude,
      required String destinationlongitude}) async {
    return await DioClient(Dio(),
            showSnakbar: showSnakbar, isOverlayLoader: true)
        .post(Endpoints.baseUrl + Endpoints.getRoutes, data: {
      "source": {"latitude": sourcelatitude, "longitude": sourcelongitude},
      "destination": {
        "latitude": destinationlatitude,
        "longitude": destinationlongitude
      }
    });
  }

  static Future<Response> postSaveRoutes(
      {bool showSnakbar = true,
      required String points,
      required String startName,
      required String endName,
      required int time,
      required List<GetRoutesDataInstructions> instructions,
      required double distance,
      String? placeID,
      required String type}) async {
    return await DioClient(Dio(),
            showSnakbar: showSnakbar, isOverlayLoader: true)
        .post(Endpoints.baseUrl + Endpoints.saveRoutes, data: {
      "points": startName, "startName": startName, "endName": endName,
      "instructions": instructions,
      "time": time,
      "distance": distance,
      "type": type,
      "placeId": placeID
      // OFFLINE or SAVED
    });
  }

  static Future<Response> postLogin({bool showSnakbar = false}) async =>
      await DioClient(Dio(), showSnakbar: showSnakbar, isOverlayLoader: false)
          .post(
        Endpoints.baseUrl + Endpoints.login,
      );

  static Future<Response> postSetUserDetails({
    required String phone,
    required String name,
    required String dob,
    required String email,
    String? key,
    String? url,
    required bool isEmailVerified,
    bool showSnakbar = false,
  }) async {
    Map<String, dynamic> body = {
      "phone": phone,
      "profilePic": {"key": key, "url": url},
      "name": name,
      "dob": dob,
      "email": email,
      "isEmailVerified": isEmailVerified,
    };
    return await DioClient(Dio(),
            showSnakbar: showSnakbar, isOverlayLoader: false)
        .post(
      Endpoints.baseUrl + Endpoints.setuserdetails,
      data: body,
    );
  }

  static Future<Response> postuploadProfileImage({
    required File imageFile,
    bool showSnakbar = false,
  }) async {
    String fileName = imageFile.path.split('/').last;
    FormData formData = FormData.fromMap({
      "files": await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
        contentType: MediaType("image", imageFile.path.split('.').last),
      ),
    });

    return await DioClient(Dio(),
            showSnakbar: showSnakbar, isOverlayLoader: true)
        .post(
      Endpoints.baseUrl + Endpoints.setuserprofilepicture,
      data: formData,
      options: Options(
        headers: {
          Headers.contentTypeHeader: "multipart/form-data",
        },
      ),
    );
  }

  static Future<Response> postContactUs(
      {bool showSnakbar = true,
      required String title,
      required String description}) async {
    Map<String, dynamic> body = {"title": title, "description": description};
    return await DioClient(Dio(),
            showSnakbar: showSnakbar, isOverlayLoader: true)
        .post(Endpoints.baseUrl + Endpoints.contactus, data: body);
  }

  static Future<Response> postReportIncident({
    required String typeOfIncident,
    required String key,
    required String url,
    required String type,
    required String addressLine,
    required double latitude,
    required double longitude,
    required String description,
    bool showSnakbar = false,
  }) async {
    Map<String, dynamic> body = {
      "typeOfIncident": typeOfIncident,
      "location": {
        "type": type,
        // [longitude, latitude]
        "coordinates": [longitude, latitude],
        "addressLine": addressLine,
      },
      "description": description,
      "postMedia": [
        {"key": key, "url": url}
      ],
    };
    return await DioClient(Dio(),
            showSnakbar: showSnakbar, isOverlayLoader: false)
        .post(
      Endpoints.baseUrl + Endpoints.createreportincident,
      data: body,
    );
  }

  static Future<Response> postSaveLocation(
      {bool showSnakbar = true,
      required String type,
      required String locationtype,
      required String addressLine,
      required double lat,
      required double lng,
      required String title}) async {
    Map<String, dynamic> body = {
      "type": type,
      "title": title,
      "location": {
        "type": locationtype,
        "coordinates": [lat, lng], // Longitude, Latitude
        "addressLine": addressLine
      }
    };
    return await DioClient(Dio(),
            showSnakbar: showSnakbar, isOverlayLoader: true)
        .post(Endpoints.baseUrl + Endpoints.postsavePlace, data: body);
  }
  //////////getapis

  static Future<Response> getFetchCommunityPost(
      {bool showSnakbar = true,
      required double latitude,
      required double longitude,
      required double distance,
      required int days}) async {
    Map<String, dynamic> queryParameters = {
      "latitude": latitude,
      "longitude": longitude,
      "distance": distance,
      "days": days
    };
    return await DioClient(Dio(),
            showSnakbar: showSnakbar, isOverlayLoader: true)
        .get(Endpoints.baseUrl + Endpoints.fetchcommunitypost,
            queryParameters: queryParameters);
  }

  static Future<Response> getGoogleDirections({
    bool showSnakbar = true,
    required List<LatLng> waypoints,
    required double currentLatitude,
    required double currentLongitude,
    required double destinationLatitude,
    required double destinationLongitude,
    required String waypointsStr,
    required String googleApiKey,
  }) async {
    return await DioClient(Dio(),
            showSnakbar: showSnakbar, isOverlayLoader: true)
        .get(
      'https://maps.googleapis.com/maps/api/directions/json'
      '?origin=${currentLatitude},${currentLongitude}' // Start point
      '&destination=${destinationLatitude},${destinationLongitude}' // End point
      '&waypoints=$waypointsStr' // Formatted waypoints
      '&mode=driving' // Mode of transport
      '&alternatives=true' // Get alternative routes
      '&traffic_model=best_guess' // Best guess for traffic data
      '&departure_time=now' // For live traffic data
      '&key=${googleApiKey}',
    );
  }

  static Future<Response> getFetchSavedRoutes({
    bool showSnakbar = true,
    required String type,
  }) async {
    Map<String, dynamic> queryParameters = {"type": type};
    return await DioClient(Dio(),
            showSnakbar: showSnakbar, isOverlayLoader: true)
        .get(Endpoints.baseUrl + Endpoints.getsavedRoutes,
            queryParameters: queryParameters);
  }

  static Future<Response> getSavedLocation({
    bool showSnakbar = true,
    required String type,
  }) async {
    Map<String, dynamic> queryParameters = {"type": type};
    return await DioClient(Dio(),
            showSnakbar: showSnakbar, isOverlayLoader: true)
        .get(Endpoints.baseUrl + Endpoints.getsavedPlace,
            queryParameters: queryParameters);
  }
}
