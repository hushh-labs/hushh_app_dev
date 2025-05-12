import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/agent_card_wallet/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:toastification/toastification.dart';

class NfcUtils {
  static final NfcUtils _instance = NfcUtils._internal();

  factory NfcUtils() {
    return _instance;
  }

  NfcUtils._internal();

  bool isNfcSupported = false;
  bool lookForNfcTagForWriting = false;

  Future<void> checkForNfcSupport(
      NfcOperation nfcOperation, BuildContext context,
      {String? data}) async {
    NfcManager.instance.isAvailable().then((isAvailable) {
      isNfcSupported = isAvailable;
      if (isAvailable) {
        if (nfcOperation == NfcOperation.write) {
          lookForNfcTagForWriting = true;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Material(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Lottie.asset('assets/nfc_anim_loading.json',
                                width: 40.w),
                            const Text(
                              'Ready to scan!',
                              style: TextStyle(color: Colors.black, fontSize: 20),
                            ),
                            const SizedBox(height: 16)
                          ],
                        ),
                        // You can customize the dialog further if needed
                      ),
                    ],
                  ),
                ),
              );
            },
          ).then((value) {
            if (lookForNfcTagForWriting) {
              NfcManager.instance.stopSession();
              checkForNfcSupport(NfcOperation.read, context);
            }
          });
        }
        NfcManager.instance.startSession(
          onDiscovered: (NfcTag tag) async {
            if (nfcOperation == NfcOperation.read) {
              readFromNfcTag(tag).then((value) {
                parseNfcTagData(value, context);
              });
            } else {
              lookForNfcTagForWriting = false;
              writeToNfcTag(tag, data!).then((value) {
                Navigator.pop(context);
                NfcManager.instance.stopSession();
                checkForNfcSupport(NfcOperation.read, context);
              });
            }
          },
        );
      }
      else if(nfcOperation == NfcOperation.write){
        ToastManager(Toast(
            title: "Unable to access NFC at the moment!",
            description: "Please check NFC is enabled and supported.",
            type: ToastificationType.error))
            .show(context);
      }
      // NfcManager.instance.stopSession();
    });
  }

  Future<String> readFromNfcTag(NfcTag tag) async {
    if (tag.data['cachedMessage']?['records']?.isNotEmpty ?? false) {
      List<int> payload =
          tag.data['cachedMessage']?['records']?[0]['payload'] ?? [];
      return String.fromCharCodes(payload);
    } else {
      throw Exception("ERROR: UNABLE TO READ CONTENT: ${tag.data}");
    }
  }

  void parseNfcTagData(String data, BuildContext context) {
    if (data.contains('hushhapp.com')) {
      String url = data;
      RegExp uidRegExp = RegExp(r"\?uid=([^&]+)");
      RegExp dataRegExp = RegExp(r"&data=([^&]+)");

      String? userUid = uidRegExp.firstMatch(url)?.group(1);
      String? brandId = dataRegExp.firstMatch(url)?.group(1);

      int? brandIdAsInt = int.tryParse(brandId??"");

      if (userUid == AppLocalStorage.hushhId) {
        ToastManager(Toast(
                title: "Invalid data found",
                type: ToastificationType.error))
            .show(context);
        Navigator.pop(context);
        return;
      }

      if (userUid != null && brandIdAsInt != null) {
        Navigator.pop(context);
        sl<AgentCardWalletPageBloc>()
            .add(FetchCardInfoEvent(userUid, brandIdAsInt, context));
      }
    } else {
      throw Exception("ERROR: UNABLE TO PARSE CONTENT: $data");
    }
  }

  Future<void> writeToNfcTag(NfcTag tag, String data) async {
    NdefMessage message = NdefMessage([NdefRecord.createUri(Uri.parse(data))]);
    Ndef.from(tag)?.write(message);
  }
}
