// Define your Dart models here
class GoogleDIrectionApiResponseRoutesLegsEndLocation {
  double? lat;
  double? lng;

  GoogleDIrectionApiResponseRoutesLegsEndLocation({this.lat, this.lng});
  GoogleDIrectionApiResponseRoutesLegsEndLocation.fromJson(
      Map<String, dynamic> json) {
    lat = json['lat']?.toDouble();
    lng = json['lng']?.toDouble();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}

class GoogleDIrectionApiResponseRoutesLegsDuration {
  String? text;
  int? value;

  GoogleDIrectionApiResponseRoutesLegsDuration({this.text, this.value});
  GoogleDIrectionApiResponseRoutesLegsDuration.fromJson(
      Map<String, dynamic> json) {
    text = json['text']?.toString();
    value = json['value']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['text'] = text;
    data['value'] = value;
    return data;
  }
}

class GoogleDIrectionApiResponseRoutesLegsDistance {
  String? text;
  int? value;

  GoogleDIrectionApiResponseRoutesLegsDistance({this.text, this.value});
  GoogleDIrectionApiResponseRoutesLegsDistance.fromJson(
      Map<String, dynamic> json) {
    text = json['text']?.toString();
    value = json['value']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['text'] = text;
    data['value'] = value;
    return data;
  }
}

class GoogleDIrectionApiResponseRoutesLegsSteps {
  GoogleDIrectionApiResponseRoutesLegsDistance? distance;
  GoogleDIrectionApiResponseRoutesLegsDuration? duration;
  GoogleDIrectionApiResponseRoutesLegsEndLocation? endLocation;
  String? htmlInstructions;
  String? maneuver;
  Map<String, dynamic>? polyline;
  GoogleDIrectionApiResponseRoutesLegsEndLocation? startLocation;
  String? travelMode;

  GoogleDIrectionApiResponseRoutesLegsSteps({
    this.distance,
    this.duration,
    this.endLocation,
    this.htmlInstructions,
    this.maneuver,
    this.polyline,
    this.startLocation,
    this.travelMode,
  });
  GoogleDIrectionApiResponseRoutesLegsSteps.fromJson(
      Map<String, dynamic> json) {
    distance = (json['distance'] != null)
        ? GoogleDIrectionApiResponseRoutesLegsDistance.fromJson(
            json['distance'])
        : null;
    duration = (json['duration'] != null)
        ? GoogleDIrectionApiResponseRoutesLegsDuration.fromJson(
            json['duration'])
        : null;
    endLocation = (json['end_location'] != null)
        ? GoogleDIrectionApiResponseRoutesLegsEndLocation.fromJson(
            json['end_location'])
        : null;
    htmlInstructions = json['html_instructions']?.toString();
    maneuver = json['maneuver']?.toString();
    polyline = json['polyline']?.cast<String, dynamic>();
    startLocation = (json['start_location'] != null)
        ? GoogleDIrectionApiResponseRoutesLegsEndLocation.fromJson(
            json['start_location'])
        : null;
    travelMode = json['travel_mode']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (distance != null) {
      data['distance'] = distance!.toJson();
    }
    if (duration != null) {
      data['duration'] = duration!.toJson();
    }
    if (endLocation != null) {
      data['end_location'] = endLocation!.toJson();
    }
    data['html_instructions'] = htmlInstructions;
    data['maneuver'] = maneuver;
    data['polyline'] = polyline;
    if (startLocation != null) {
      data['start_location'] = startLocation!.toJson();
    }
    data['travel_mode'] = travelMode;
    return data;
  }
}

class GoogleDIrectionApiResponseRoutesLegs {
  GoogleDIrectionApiResponseRoutesLegsDistance? distance;
  GoogleDIrectionApiResponseRoutesLegsDuration? duration;
  String? endAddress;
  GoogleDIrectionApiResponseRoutesLegsEndLocation? endLocation;
  String? startAddress;
  GoogleDIrectionApiResponseRoutesLegsEndLocation? startLocation;
  List<GoogleDIrectionApiResponseRoutesLegsSteps?>? steps;

  GoogleDIrectionApiResponseRoutesLegs({
    this.distance,
    this.duration,
    this.endAddress,
    this.endLocation,
    this.startAddress,
    this.startLocation,
    this.steps,
  });
  GoogleDIrectionApiResponseRoutesLegs.fromJson(Map<String, dynamic> json) {
    distance = (json['distance'] != null)
        ? GoogleDIrectionApiResponseRoutesLegsDistance.fromJson(
            json['distance'])
        : null;
    duration = (json['duration'] != null)
        ? GoogleDIrectionApiResponseRoutesLegsDuration.fromJson(
            json['duration'])
        : null;
    endAddress = json['end_address']?.toString();
    endLocation = (json['end_location'] != null)
        ? GoogleDIrectionApiResponseRoutesLegsEndLocation.fromJson(
            json['end_location'])
        : null;
    startAddress = json['start_address']?.toString();
    startLocation = (json['start_location'] != null)
        ? GoogleDIrectionApiResponseRoutesLegsEndLocation.fromJson(
            json['start_location'])
        : null;
    if (json['steps'] != null) {
      final v = json['steps'];
      final arr0 = <GoogleDIrectionApiResponseRoutesLegsSteps>[];
      v.forEach((v) {
        arr0.add(GoogleDIrectionApiResponseRoutesLegsSteps.fromJson(v));
      });
      steps = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (distance != null) {
      data['distance'] = distance!.toJson();
    }
    if (duration != null) {
      data['duration'] = duration!.toJson();
    }
    data['end_address'] = endAddress;
    if (endLocation != null) {
      data['end_location'] = endLocation!.toJson();
    }
    data['start_address'] = startAddress;
    if (startLocation != null) {
      data['start_location'] = startLocation!.toJson();
    }
    if (steps != null) {
      final v = steps;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['steps'] = arr0;
    }

    return data;
  }
}

class GoogleDIrectionApiResponseRoutesOverviewPolyline {
  String? points;

  GoogleDIrectionApiResponseRoutesOverviewPolyline({this.points});
  GoogleDIrectionApiResponseRoutesOverviewPolyline.fromJson(
      Map<String, dynamic> json) {
    points = json['points']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['points'] = points;
    return data;
  }
}

class GoogleDIrectionApiResponseRoutes {
  GoogleDIrectionApiResponseRoutesBounds? bounds;
  String? copyrights;
  List<GoogleDIrectionApiResponseRoutesLegs?>? legs;
  GoogleDIrectionApiResponseRoutesOverviewPolyline? overviewPolyline;
  String? summary;
  List<int?>? waypointOrder;

  GoogleDIrectionApiResponseRoutes({
    this.bounds,
    this.copyrights,
    this.legs,
    this.overviewPolyline,
    this.summary,
    this.waypointOrder,
  });
  GoogleDIrectionApiResponseRoutes.fromJson(Map<String, dynamic> json) {
    bounds = (json['bounds'] != null)
        ? GoogleDIrectionApiResponseRoutesBounds.fromJson(json['bounds'])
        : null;
    copyrights = json['copyrights']?.toString();
    if (json['legs'] != null) {
      final v = json['legs'];
      final arr0 = <GoogleDIrectionApiResponseRoutesLegs>[];
      v.forEach((v) {
        arr0.add(GoogleDIrectionApiResponseRoutesLegs.fromJson(v));
      });
      legs = arr0;
    }
    overviewPolyline = (json['overview_polyline'] != null)
        ? GoogleDIrectionApiResponseRoutesOverviewPolyline.fromJson(
            json['overview_polyline'])
        : null;
    summary = json['summary']?.toString();

    if (json['waypoint_order'] != null) {
      final v = json['waypoint_order'];
      final arr0 = <int>[];
      v.forEach((v) {
        arr0.add(v.toInt());
      });
      waypointOrder = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (bounds != null) {
      data['bounds'] = bounds!.toJson();
    }
    data['copyrights'] = copyrights;
    if (legs != null) {
      final v = legs;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['legs'] = arr0;
    }
    if (overviewPolyline != null) {
      data['overview_polyline'] = overviewPolyline!.toJson();
    }
    data['summary'] = summary;
    if (waypointOrder != null) {
      final v = waypointOrder;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v);
      });
      data['waypoint_order'] = arr0;
    }
    return data;
  }
}

class GoogleDIrectionApiResponse {
  List<GoogleDIrectionApiResponseRoutes>? routes;

  GoogleDIrectionApiResponse({this.routes});
  GoogleDIrectionApiResponse.fromJson(Map<String, dynamic> json) {
    if (json['routes'] != null) {
      final v = json['routes'];
      final arr0 = <GoogleDIrectionApiResponseRoutes>[];
      v.forEach((v) {
        arr0.add(GoogleDIrectionApiResponseRoutes.fromJson(v));
      });
      routes = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (routes != null) {
      final v = routes;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['routes'] = arr0;
    }
    return data;
  }
}

class GoogleDIrectionApiResponseRoutesBoundsSouthwest {
/*
{
  "lat": 19.2374281,
  "lng": 72.8545303
}
*/

  double? lat;
  double? lng;

  GoogleDIrectionApiResponseRoutesBoundsSouthwest({
    this.lat,
    this.lng,
  });
  GoogleDIrectionApiResponseRoutesBoundsSouthwest.fromJson(
      Map<String, dynamic> json) {
    lat = json['lat']?.toDouble();
    lng = json['lng']?.toDouble();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}

class GoogleDIrectionApiResponseRoutesBoundsNortheast {
/*
{
  "lat": 19.2448091,
  "lng": 72.8600604
}
*/

  double? lat;
  double? lng;

  GoogleDIrectionApiResponseRoutesBoundsNortheast({
    this.lat,
    this.lng,
  });
  GoogleDIrectionApiResponseRoutesBoundsNortheast.fromJson(
      Map<String, dynamic> json) {
    lat = json['lat']?.toDouble();
    lng = json['lng']?.toDouble();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}

class GoogleDIrectionApiResponseRoutesBounds {
/*
{
  "northeast": {
    "lat": 19.2448091,
    "lng": 72.8600604
  },
  "southwest": {
    "lat": 19.2374281,
    "lng": 72.8545303
  }
}
*/

  GoogleDIrectionApiResponseRoutesBoundsNortheast? northeast;
  GoogleDIrectionApiResponseRoutesBoundsSouthwest? southwest;

  GoogleDIrectionApiResponseRoutesBounds({
    this.northeast,
    this.southwest,
  });
  GoogleDIrectionApiResponseRoutesBounds.fromJson(Map<String, dynamic> json) {
    northeast = (json['northeast'] != null)
        ? GoogleDIrectionApiResponseRoutesBoundsNortheast.fromJson(
            json['northeast'])
        : null;
    southwest = (json['southwest'] != null)
        ? GoogleDIrectionApiResponseRoutesBoundsSouthwest.fromJson(
            json['southwest'])
        : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (northeast != null) {
      data['northeast'] = northeast!.toJson();
    }
    if (southwest != null) {
      data['southwest'] = southwest!.toJson();
    }
    return data;
  }
}
