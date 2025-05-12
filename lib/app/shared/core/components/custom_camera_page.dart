import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';

class CustomCameraPage extends StatefulWidget {
  const CustomCameraPage({super.key});

  @override
  State<CustomCameraPage> createState() => _CustomCameraPageState();
}

class _CustomCameraPageState extends State<CustomCameraPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CameraAwesomeBuilder.awesome(
        saveConfig: SaveConfig.video(),
        sensorConfig: SensorConfig.single(
          sensor: Sensor.position(SensorPosition.front),
        ),
        onMediaTap: (mediaCapture) {
          Navigator.pop(context, mediaCapture.captureRequest.path);
        },
      ),
    );
  }
}
