import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> getCustomMarker(String key) async {
  ByteData byteData = await rootBundle.load(key);
  ui.Codec codec = await ui.instantiateImageCodec(
    byteData.buffer.asUint8List(),
    targetWidth: 200, // Adjust the width to resize the image
    targetHeight: 200, // Adjust the height to resize the image
  );
  ui.FrameInfo frameInfo = await codec.getNextFrame();
  ByteData? resizedData =
      await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
  return BitmapDescriptor.fromBytes(resizedData!.buffer.asUint8List());
}
