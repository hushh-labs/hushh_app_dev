import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class Locator {
  static Future<Position?> getCurrentLocation() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Position position = await Geolocator.getCurrentPosition();
      return position;
    }
    return null;
  }
}

class RealTimeLocator {
  late StreamSubscription<Position> _positionStreamSubscription;

  RealTimeLocator() {
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      ),
    ).listen((Position position) {
      getName(position);
    });
  }

  Future<String?> getName(Position position) async {
    List<Placemark> placeMarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placeMarks.isNotEmpty) {
      Placemark placeMark = placeMarks.first;
      return placeMark.name;
    }

    return null;
  }

  void dispose() {
    _positionStreamSubscription.cancel();
  }
}
