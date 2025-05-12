import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/agent_card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:toastification/toastification.dart';

class AgentQrScanBottomSheet extends StatelessWidget {
  const AgentQrScanBottomSheet({super.key});

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
                    String url = scanData.code!;
                    isScanned = true;
                    RegExp uidRegExp = RegExp(r"\?uid=([^&]+)");
                    RegExp dataRegExp = RegExp(r"&data=([^&]+)");

                    String? userUid = uidRegExp.firstMatch(url)?.group(1);
                    String? cardId = dataRegExp.firstMatch(url)?.group(1);

                    if(userUid == AppLocalStorage.hushhId) {
                      ToastManager(Toast(
                        title: "Invalid Hushh QR",
                        description: "Agent cannot scan their Hushh QR",
                        type: ToastificationType.error
                      )).show(context);
                      Navigator.pop(context);
                      return;
                    }

                    int? cardIdAsInt = int.tryParse(cardId??"");

                    if (userUid != null && cardIdAsInt != null) {
                      sl<AgentCardWalletPageBloc>()
                          .add(FetchCardInfoEvent(userUid, cardIdAsInt, context));
                    }
                  } else {

                  }
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
