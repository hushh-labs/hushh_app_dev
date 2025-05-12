import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_google_maps_webservices/geocoding.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:flutter_google_maps_webservices/src/core.dart' as ws;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';
import 'package:hushh_app/app/shared/core/components/map_picker.dart';
import 'package:latlong2/latlong.dart' as ll;

class CustomMapPicker extends StatefulWidget {
  final ll.LatLng latLng;

  const CustomMapPicker({super.key, required this.latLng});

  @override
  State<CustomMapPicker> createState() => _CustomMapPickerState();
}

class _CustomMapPickerState extends State<CustomMapPicker> {
  final _controller = Completer<GoogleMapController>();
  MapPickerController mapPickerController = MapPickerController();

  late CameraPosition cameraPosition;

  String currentLocation = "";

  @override
  void initState() {
    cameraPosition = CameraPosition(
      target: LatLng(widget.latLng.latitude, widget.latLng.longitude),
      zoom: 14.4746,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FutureBuilder(
          future: fetchPlaceName(),
          builder: (context, data) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: HushhLinearGradientButton(
                onTap: () {
                  Navigator.pop(
                      context,
                      ll.LatLng(cameraPosition.target.latitude,
                          cameraPosition.target.longitude));
                },
                text: '${data.data}',
                icon: Icons.arrow_forward,
                trailing: true,
              ),
            );
          }),
      body: MapPicker(
        iconWidget: SvgPicture.asset('assets/location.svg',
            color: Colors.black, height: 42),
        mapPickerController: mapPickerController,
        child: GoogleMap(
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          mapType: MapType.normal,
          initialCameraPosition: cameraPosition,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          onCameraMoveStarted: () {
            mapPickerController.mapMoving!();
            currentLocation = "checking ...";
          },
          onCameraMove: (cameraPosition) {
            this.cameraPosition = cameraPosition;
          },
          onCameraIdle: () async {
            mapPickerController.mapFinishedMoving!();
            List<Placemark> placemarks = await placemarkFromCoordinates(
              cameraPosition.target.latitude,
              cameraPosition.target.longitude,
            );

            currentLocation =
                '${placemarks.first.name}, ${placemarks.first.administrativeArea}, ${placemarks.first.country}';
            setState(() {});
          },
        ),
      ),
    );
  }

  Future<String?> fetchPlaceName() async {
    final places = GoogleMapsGeocoding(
        apiKey: "AIzaSyDXF2S8JQVT5nV8ROMvYUVDqLIA0oHt3sk");
    final result = await places.searchByLocation(
      ws.Location(
          lat: cameraPosition.target.latitude,
          lng: cameraPosition.target.longitude),
    );
    if (result.status == "OK") {
      return (result.results.first.formattedAddress);
    } else {
      throw Exception(result.errorMessage);
    }
  }
}
