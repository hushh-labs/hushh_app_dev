import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/list_tile_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/brand_card_list_view.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/preference_card_list_view.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/components/hushh_contacts_bottom_sheet.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/nfc_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ShareAndEarnBottomSheet extends StatelessWidget {
  const ShareAndEarnBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final list = [
      ListTileModel('Hushh Chat', 'assets/hushh_s_logo.png'),
      ListTileModel('NFC: share with a Single Tap 🤫', 'assets/nfc_icon.png'),
      ListTileModel('Other', 'assets/share_icon.png')
    ];
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(16),
      height: 45.h,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Column(
        children: [
          SizedBox(
            width: 45.w,
            child: FittedBox(
              alignment: Alignment.topCenter,
              child:
                  sl<CardWalletPageBloc>().isSelectedCardPreferenceCard ?? false
                      ? PreferenceCardWidget(
                          ignore: true,
                          cardData: sl<CardWalletPageBloc>().cardData!,
                          userName: sl<CardWalletPageBloc>().user?.name ?? "",
                        )
                      : BrandCardWidget(
                          ignore: true,
                          brand: sl<CardWalletPageBloc>().cardData!,
                          isDetailsScreen: true,
                        ),
            ),
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'You can manage your cards here and update any necessary information required',
              style: TextStyle(color: Color(0xFF4C4C4C)),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                  list.length,
                  (index) => GestureDetector(
                        onTap: () => onTap(context, index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration:
                              const BoxDecoration(color: Color(0xFFEEEEEE)),
                          child: Row(
                            children: [
                              Image.asset(
                                list[index].leading,
                                width: 26,
                                color: Colors.black,
                                height: 26,
                              ),
                              const SizedBox(width: 12),
                              Text(list[index].title)
                            ],
                          ),
                        ),
                      )),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Future<void> onTap(BuildContext context, int index) async {
    ScreenshotController screenshotController = ScreenshotController();
    final pngBytes = await screenshotController.captureFromWidget(Material(
      child: BrandCardWidget(
        brand: sl<CardWalletPageBloc>().cardData!,
        ignore: true,
        isDetailsScreen: false,
      ),
    ));
    final dir = await getTemporaryDirectory();
    File file = File(
        "${dir.path}/HushhCards_${sl<CardWalletPageBloc>().cardData?.id}.png");
    await file.writeAsBytes(pngBytes);
    Navigator.pop(context);

    switch (index) {
      case 0:
        showModalBottomSheet(
            enableDrag: true,
            isDismissible: true,
            backgroundColor: Colors.white,
            isScrollControlled: true,
            context: context,
            showDragHandle: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            ),
            builder: (context) => HushhContactsBottomSheet(file: file));
        break;
      case 1:
        NfcUtils().checkForNfcSupport(NfcOperation.write, context, data: "https://hushhapp.com/?uid=${AppLocalStorage.hushhId}&data=${sl<CardWalletPageBloc>().cardData!.id}");
        break;
      case 2:
        XFile xfile = XFile(file.path);
        await Share.shareXFiles([xfile]);
        break;
    }
  }
}
