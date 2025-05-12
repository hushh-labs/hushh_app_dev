import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/presentation/bloc/card_share_ecosystem_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/chat/presentation/bloc/chat_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/utils/utils_impl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class UserQrScanBottomSheet extends StatefulWidget {
  const UserQrScanBottomSheet({super.key});

  @override
  State<UserQrScanBottomSheet> createState() => _UserQrScanBottomSheetState();
}

class _UserQrScanBottomSheetState extends State<UserQrScanBottomSheet> {
  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   Navigator.pop(context);
    //   Utils.showLoader(context);
    //   int? gIdAsInt = 1;
    //   sl<CardShareEcosystemBloc>()
    //       .add(FetchBrandIdsFromGroupIdEvent(gIdAsInt, context));
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Scan a Hushh QR Code',
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
                bool isScanned = false;
                controller.scannedDataStream.listen((scanData) async {
                  if ((scanData.code?.contains('hushhapp.com') ?? false) &&
                      !isScanned) {
                    isScanned = true;
                    Navigator.pop(context);
                    Utils().showLoader(context);
                    String data = scanData.code!;
                    if (data.contains('gid=')) {
                      RegExp gIdRegExp = RegExp(r"\?gid=([^&]+)");

                      String? gId = gIdRegExp.firstMatch(data)?.group(1);

                      int? gIdAsInt = int.tryParse(gId ?? "");

                      if (gIdAsInt != null) {
                        sl<CardShareEcosystemBloc>().add(
                            FetchBrandIdsFromGroupIdEvent(gIdAsInt, context));
                      }
                    } else if (data.contains('pid=')) {
                      RegExp pIdRegExp = RegExp(r"\?pid=([^&]+)");

                      String? pId = pIdRegExp.firstMatch(data)?.group(1);

                      if (pId != null) {
                        sl<ChatPageBloc>().add(
                            FetchPaymentRequestAndMakePaymentAsUserEvent(
                                pId: pId, context: context));
                      }
                    }
                  } else {}
                });
              },
              overlay: QrScannerOverlayShape(
                  borderColor: const Color(0xFFE54D60),
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
