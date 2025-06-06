import 'dart:math';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:rxdart/rxdart.dart';

extension MLKitUtils on AnalysisImage {
  InputImage toInputImage() {
    return when(
      nv21: (image) {
        return InputImage.fromBytes(
          bytes: image.bytes,
          metadata: InputImageMetadata(
            rotation: inputImageRotation,
            format: InputImageFormat.nv21,
            size: image.size,
            bytesPerRow: image.planes.first.bytesPerRow,
          ),
        );
      },
      bgra8888: (image) {
        final inputImageData = InputImageMetadata(
          size: size,
          rotation: inputImageRotation,
          format: inputImageFormat,
          bytesPerRow: image.planes.first.bytesPerRow,
        );

        return InputImage.fromBytes(
          bytes: image.bytes,
          metadata: inputImageData,
        );
      },
    )!;
  }

  InputImageRotation get inputImageRotation =>
      InputImageRotation.values.byName(rotation.name);

  InputImageFormat get inputImageFormat {
    switch (format) {
      case InputAnalysisImageFormat.bgra8888:
        return InputImageFormat.bgra8888;
      case InputAnalysisImageFormat.nv21:
        return InputImageFormat.nv21;
      default:
        return InputImageFormat.yuv420;
    }
  }
}

class CustomCameraWithAnalysisPage extends StatefulWidget {
  const CustomCameraWithAnalysisPage({super.key});

  @override
  State<CustomCameraWithAnalysisPage> createState() => _CustomCameraWithAnalysisPageState();
}

class _CustomCameraWithAnalysisPageState extends State<CustomCameraWithAnalysisPage> {
  final _faceDetectionController = BehaviorSubject<FaceDetectionModel>();
  Preview? _preview;

  final options = FaceDetectorOptions(
    enableContours: true,
    enableClassification: true,
  );
  late final faceDetector = FaceDetector(options: options);

  @override
  void deactivate() {
    faceDetector.close();
    super.deactivate();
  }

  @override
  void dispose() {
    _faceDetectionController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CameraAwesomeBuilder.previewOnly(
        previewFit: CameraPreviewFit.contain,
        sensorConfig: SensorConfig.single(
          sensor: Sensor.position(SensorPosition.front),
          aspectRatio: CameraAspectRatios.ratio_1_1,
        ),
        onImageForAnalysis: (img) => _analyzeImage(img),
        imageAnalysisConfig: AnalysisConfig(
          androidOptions: const AndroidAnalysisOptions.nv21(
            width: 250,
          ),
          maxFramesPerSecond: 5,
        ),
        builder: (state, preview) {
          _preview = preview;
          return _MyPreviewDecoratorWidget(
            cameraState: state,
            faceDetectionStream: _faceDetectionController,
            preview: _preview!,
          );
        },
      ),
    );
  }

  Future _analyzeImage(AnalysisImage img) async {
    final inputImage = img.toInputImage();

    try {
      final faces = await faceDetector.processImage(inputImage);
      _faceDetectionController.add(
        FaceDetectionModel(
          faces: faces,
          absoluteImageSize: inputImage.metadata!.size,
          rotation: 0,
          imageRotation: img.inputImageRotation,
          img: img,
        ),
      );
      debugPrint("...sending image resulted with : ${faces.length} faces");
    } catch (error) {
      debugPrint("...sending image resulted error $error");
    }
  }
}

class FaceDetectionModel {
  final List<Face> faces;
  final Size absoluteImageSize;
  final int rotation;
  final InputImageRotation imageRotation;
  final AnalysisImage? img;

  FaceDetectionModel({
    required this.faces,
    required this.absoluteImageSize,
    required this.rotation,
    required this.imageRotation,
    this.img,
  });

  Size get croppedSize => img!.croppedSize;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FaceDetectionModel &&
          runtimeType == other.runtimeType &&
          faces == other.faces &&
          absoluteImageSize == other.absoluteImageSize &&
          rotation == other.rotation &&
          imageRotation == other.imageRotation &&
          croppedSize == other.croppedSize;

  @override
  int get hashCode =>
      faces.hashCode ^
      absoluteImageSize.hashCode ^
      rotation.hashCode ^
      imageRotation.hashCode ^
      croppedSize.hashCode;
}

class _MyPreviewDecoratorWidget extends StatelessWidget {
  final CameraState cameraState;
  final Stream<FaceDetectionModel> faceDetectionStream;
  final Preview preview;

  const _MyPreviewDecoratorWidget({
    required this.cameraState,
    required this.faceDetectionStream,
    required this.preview,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: StreamBuilder(
        stream: cameraState.sensorConfig$,
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return StreamBuilder<FaceDetectionModel>(
              stream: faceDetectionStream,
              builder: (_, faceModelSnapshot) {
                if (!faceModelSnapshot.hasData) return const SizedBox();
                // this is the transformation needed to convert the image to the preview
                // Android mirrors the preview but the analysis image is not
                final canvasTransformation = faceModelSnapshot.data!.img
                    ?.getCanvasTransformation(preview);
                return Transform.scale(
                  scale: 1.4,
                  child: CustomPaint(
                    painter: FaceDetectorPainter(
                      model: faceModelSnapshot.requireData,
                      canvasTransformation: canvasTransformation,
                      preview: preview,
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class FaceDetectorPainter extends CustomPainter {
  final FaceDetectionModel model;
  final CanvasTransformation? canvasTransformation;
  final Preview? preview;

  FaceDetectorPainter({
    required this.model,
    this.canvasTransformation,
    this.preview,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (preview == null || model.img == null) {
      return;
    }
    // We apply the canvas transformation to the canvas so that the barcode
    // rect is drawn in the correct orientation. (Android only)
    if (canvasTransformation != null) {
      canvas.save();
      canvas.applyTransformation(canvasTransformation!, size);
    }
    for (final Face face in model.faces) {
      Map<FaceContourType, Path> paths = {
        for (var fct in FaceContourType.values) fct: Path()
      };
      face.contours.forEach((contourType, faceContour) {
        if (faceContour != null) {
          paths[contourType]!.addPolygon(
              faceContour.points
                  .map(
                    (element) => preview!.convertFromImage(
                      Offset(element.x.toDouble(), element.y.toDouble() + 50.h),
                      model.img!,
                    ),
                  )
                  .toList(),
              true);
          for (var element in faceContour.points) {
            var position = preview!.convertFromImage(
              Offset(element.x.toDouble(), element.y.toDouble() + 50.h),
              model.img!,
            );
            canvas.drawCircle(
              position,
              2,
              Paint()..color = Colors.red,
            );
          }
        }
      });
      paths.removeWhere((key, value) => value.getBounds().isEmpty);
      for (var p in paths.entries) {
        // canvas.drawPath(
        //     p.value,
        //     Paint()
        //       ..color = Colors.orange
        //       ..strokeWidth = 2
        //       ..style = PaintingStyle.stroke);
      }
    }
    // if you want to draw without canvas transformation, use this:
    if (canvasTransformation != null) {
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.model != model;
  }
}

extension InputImageRotationConversion on InputImageRotation {
  double toRadians() {
    final degrees = toDegrees();
    return degrees * 2 * pi / 360;
  }

  int toDegrees() {
    switch (this) {
      case InputImageRotation.rotation0deg:
        return 0;
      case InputImageRotation.rotation90deg:
        return 90;
      case InputImageRotation.rotation180deg:
        return 180;
      case InputImageRotation.rotation270deg:
        return 270;
    }
  }
}
