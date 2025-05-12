import 'dart:typed_data';

import 'package:latlong2/latlong.dart';

class LocationParser {
  final String locationWkbString;

  LocationParser(this.locationWkbString);

  LatLng parse() {
    // Convert the hex string to a Uint8List (byte array)
    Uint8List wkbBytes = Uint8List.fromList(hexToBytes(locationWkbString));

    // Check endianness (first byte)
    bool isLittleEndian = wkbBytes[0] == 1;

    // Extract geometry type (bytes 1 to 4), skipping endianness byte
    int geomType = _readInt32(wkbBytes.sublist(1, 5), isLittleEndian);
    if (geomType != 1) {
      throw Exception('The WKB does not represent a point geometry');
    }

    // Extract coordinates (longitude and latitude)
    double longitude = _readDouble(wkbBytes.sublist(9, 17), isLittleEndian);
    double latitude = _readDouble(wkbBytes.sublist(17, 25), isLittleEndian);

    return LatLng(latitude, longitude);
  }

  List<int> hexToBytes(String hex) {
    List<int> bytes = [];
    for (int i = 0; i < hex.length; i += 2) {
      bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }
    return bytes;
  }

  int _readInt32(List<int> bytes, bool littleEndian) {
    ByteData data = ByteData.sublistView(Uint8List.fromList(bytes));
    return littleEndian
        ? data.getInt32(0, Endian.little)
        : data.getInt32(0, Endian.big);
  }

  double _readDouble(List<int> bytes, bool littleEndian) {
    ByteData data = ByteData.sublistView(Uint8List.fromList(bytes));
    return littleEndian
        ? data.getFloat64(0, Endian.little)
        : data.getFloat64(0, Endian.big);
  }
}
