import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ChromeExtensionBottomSheet extends StatelessWidget {
  final Function(String?) onScanned;
  const ChromeExtensionBottomSheet({super.key, required this.onScanned});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // InkWell(
              //   onTap: () {
              //     Navigator.of(context).pop();
              //   },
              //   child: const Text(
              //     'Cancel',
              //     style: TextStyle(
              //         color: Color(0xff181941),
              //         fontWeight: FontWeight.w500,
              //         fontSize: 16),
              //   ),
              // ),
              const Text(
                'Scan QR Code',
                style: TextStyle(
                    color: Color(0xff181941),
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
              child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: QRView(
              key: sl<HomePageBloc>().qrKey,
              onQRViewCreated: (QRViewController controller) {
                controller.scannedDataStream.listen((scanData) async {
                  onScanned(scanData.code);
                });
              },
              overlay: QrScannerOverlayShape(
                  borderColor: Colors.red,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: (MediaQuery.of(context).size.width < 400 ||
                          MediaQuery.of(context).size.height < 400)
                      ? 150.0
                      : 300.0),
              onPermissionSet: (QRViewController ctrl, bool p) {
                if (!p) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('no Permission')),
                  );
                }
              },
            ),
          )),
        ],
      ),
    );
  }
}
