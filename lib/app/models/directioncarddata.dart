class DirectioncardData {
  final String name;
  final double rating;
  final String points;
  final String status;
  final String closingTime;
  final double distance;
  final String location;
  final List<String> imageUrls;
  final String placeID;
  final List<DirectionInstruction>? instructions; // Add this field

  DirectioncardData({
    required this.name,
    required this.rating,
    required this.status,
    required this.points,
    required this.closingTime,
    required this.distance,
    required this.location,
    required this.imageUrls,
    required this.placeID,
     this.instructions, // Initialize this field
  });

  factory DirectioncardData.fromJson(Map<String, dynamic> json) {
    return DirectioncardData(
      name: json['name'],
      points: json['points'],
      rating: json['rating'].toDouble(),
      status: json['status'],
      closingTime: json['closingTime'],
      distance: json['distance'].toDouble(),
      location: json['location'],
      imageUrls: List<String>.from(json['imageUrls']),
      placeID: json['placeID'],
      instructions: (json['instructions'] as List<dynamic>)
          .map((e) => DirectionInstruction.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'rating': rating,
      'status': status,
      'closingTime': closingTime,
      'distance': distance,
      'location': location,
      'imageUrls': imageUrls,
      'placeID': placeID,
      'points': points,
      'instructions': instructions!
          .map((e) => e.toJson())
          .toList(), // Serialize instructions
    };
  }
}

class DirectionInstruction {
  final String streetRef;
  final double distance;
  final double heading;
  final int sign;
  final List<int> interval;
  final String text;
  final int time;
  final String streetName;

  DirectionInstruction({
    required this.streetRef,
    required this.distance,
    required this.heading,
    required this.sign,
    required this.interval,
    required this.text,
    required this.time,
    required this.streetName,
  });

  /// Factory constructor to map data from `GetRoutesDataInstructions`
  factory DirectionInstruction.fromGetRoutesDataInstructions(
      Map<String, dynamic> data) {
    return DirectionInstruction(
      streetRef: data['street_ref'] ?? '',
      distance: data['distance'] ?? 0.0,
      heading: data['heading'] ?? 0.0,
      sign: data['sign'] ?? 0,
      interval: List<int>.from(data['interval'] ?? []),
      text: data['text'] ?? '',
      time: data['time'] ?? 0,
      streetName: data['street_name'] ?? '',
    );
  }

  factory DirectionInstruction.fromJson(Map<String, dynamic> json) {
    return DirectionInstruction(
      streetRef: json['street_ref'] ?? '',
      distance: json['distance'] ?? 0.0,
      heading: json['heading'] ?? 0.0,
      sign: json['sign'] ?? 0,
      interval: List<int>.from(json['interval'] ?? []),
      text: json['text'] ?? '',
      time: json['time'] ?? 0,
      streetName: json['street_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street_ref': streetRef,
      'distance': distance,
      'heading': heading,
      'sign': sign,
      'interval': interval,
      'text': text,
      'time': time,
      'street_name': streetName,
    };
  }
}
