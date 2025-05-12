import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/shared/core/components/custom_qr/colors.dart';
import 'package:hushh_app/app/shared/core/components/custom_qr/options/colors.dart';
import 'package:hushh_app/app/shared/core/components/custom_qr/options/options.dart';
import 'package:hushh_app/app/shared/core/components/custom_qr/options/shapes.dart';
import 'package:hushh_app/app/shared/core/components/custom_qr/qr_painter.dart';
import 'package:hushh_app/app/shared/core/components/custom_qr/shapes/ball_shape.dart';
import 'package:hushh_app/app/shared/core/components/custom_qr/shapes/frame_shape.dart';
import 'package:hushh_app/app/shared/core/components/custom_qr/shapes/pixel_shape.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class QrCodeWidget extends StatelessWidget {
  final CardModel brand;
  final bool gradient;

  const QrCodeWidget({super.key, required this.brand, this.gradient = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(
            "https://hushhapp.com/?uid=${AppLocalStorage.hushhId}&data=${brand.id}");
        if (!gradient) _showQrCodePopup(context);
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        width: gradient ? 80.w : 70.0,
        height: gradient ? 80.w : 70.0,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(4)),
        // child: CustomQrCodeWidget(
        //     data:
        //         "https://hushhapp.com/?uid=${AppLocalStorage.hushhId}&data=${brand.id}"),
        child: PrettyQrView.data(
            data:
                "https://hushhapp.com/?uid=${AppLocalStorage.hushhId}&data=${brand.id}",
            decoration: PrettyQrDecoration(
              shape: PrettyQrSmoothSymbol(
                  roundFactor: 1,
                  color: PrettyQrBrush.gradient(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradient?[
                        Colors.pinkAccent,
                        Colors.blueAccent
                      ]:[Colors.black, Colors.black],
                    ),
                  )),
            )),
      ),
    );
  }

  void _showQrCodePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetAnimationCurve: Curves.elasticIn,
          elevation: 0,
          insetPadding: EdgeInsets.zero,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              color: Colors.transparent,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: QrCodeWidget(
                    brand: brand,
                    gradient: true,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomQrCodeWidget extends StatelessWidget {
  final String data;

  const CustomQrCodeWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: QrPainter(
          data: data,
          options: const QrOptions(
            padding: 0,
              shapes: QrShapes(
                  darkPixel: QrPixelShapeRoundCorners(cornerFraction: .5),
                  frame: QrFrameShapeRoundCorners(cornerFraction: .25),
                  ball: QrBallShapeRoundCorners(cornerFraction: .25)),
              colors: QrColors(
                  dark: QrColorLinearGradient(colors: [
                    // Color(0XFFA342FF),
                    // Color(0XFFE54D60),
                    Colors.pinkAccent,
                    Colors.blueAccent
              ], orientation: GradientOrientation.leftDiagonal)))),
    );
  }
}
