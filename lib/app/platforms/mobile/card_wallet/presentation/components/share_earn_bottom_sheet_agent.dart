import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/list_tile_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/shared/core/components/hushh_contacts_bottom_sheet.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:share_plus/share_plus.dart';

class ShareAndEarnBottomSheetAgent extends StatelessWidget {
  final File file;

  const ShareAndEarnBottomSheetAgent({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    final list = [
      ListTileModel('Hushh Chat', 'assets/hushh_s_logo.png'),
      ListTileModel('Other', 'assets/share_icon.png'),
    ];
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Hey ${sl<CardWalletPageBloc>().user?.name?.split(" ").first ?? ""}!',
            style: const TextStyle(
                fontFamily: 'Figtree',
                fontSize: 20,
                letterSpacing: -0.4,
                fontWeight: FontWeight.w600),
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
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
                list.length,
                (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: GestureDetector(
                        onTap: () => onTap(context, index, file),
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
                      ),
                    )),
          ),
        ],
      ),
    );
  }

  Future<void> onTap(BuildContext context, int index, File file) async {
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
        XFile xfile = new XFile(file.path);
        await Share.shareXFiles([xfile]);
        break;
    }
  }
}
