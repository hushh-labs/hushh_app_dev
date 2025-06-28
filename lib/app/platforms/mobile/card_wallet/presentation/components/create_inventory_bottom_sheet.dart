import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/inventory_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/add_google_sheets_inventory_bottom_sheet.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/add_whatsapp_inventory_bottom_sheet.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:toastification/toastification.dart';

class CreateInventoryBottomSheet extends StatelessWidget {
  const CreateInventoryBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Column(
        children: [
          const SizedBox(height: 16),
          const AutoSizeText(
            'Choose your Inventory Solution',
            maxLines: 1,
            style: TextStyle(
                fontFamily: 'Figtree',
                fontSize: 20,
                letterSpacing: -0.4,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style:
                    TextStyle(color: Color(0xFF4C4C4C), fontFamily: 'Figtree'),
                children: [
                  TextSpan(
                    text:
                        'Choose any of these Inventory Solution that works for you!',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: Row(
                children: [
                  Expanded(
                    child: Opacity(
                      opacity: 0.6,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEEEEEE),
                            elevation: 0,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        onPressed: () {
                          ToastManager(Toast(
                                  title: 'Coming Soon',
                                  type: ToastificationType.info))
                              .show(context);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.network(
                              'https://rpmzykoxqnbozgdoqbpc.supabase.co/storage/v1/object/public/dump/SAP%20S4HANA%20Logo%20(1).png',
                              width: 80,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEEEEEE),
                          elevation: 0,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      onPressed: () {
                        print('📊 [INVENTORY] Google Sheets button clicked');
                        Navigator.pop(context);
                        print('📊 [INVENTORY] Closed inventory solution selection sheet');
                        
                        sl<InventoryBloc>().currentInventoryServer =
                            InventoryServer.gsheets_public_server;
                        print('📊 [INVENTORY] Set inventory server to: gsheets_public_server');
                        
                        showModalBottomSheet(
                          isDismissible: true,
                          enableDrag: true,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) =>
                              const AddGoogleSheetsInventoryBottomSheet(),
                        );
                        print('📊 [INVENTORY] Opened Google Sheets credentials bottom sheet');
                      },
                      child: const AutoSizeText('Google Sheets',
                          maxLines: 1, softWrap: false),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: Center(
              child: Row(
                children: [
                  Expanded(
                    child: Opacity(
                      opacity: 0.6,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEEEEEE),
                            elevation: 0,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        onPressed: () {
                          ToastManager(Toast(
                                  title: 'WhatsApp Integration Coming Soon!',
                                  description: 'We are working on bringing WhatsApp inventory management to you',
                                  type: ToastificationType.info))
                              .show(context);
                        },
                        child: const AutoSizeText(
                          'Whatsapp',
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Opacity(
                      opacity: 0.6,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEEEEEE),
                            elevation: 0,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        onPressed: () {
                          ToastManager(Toast(
                                  title: 'Coming Soon',
                                  type: ToastificationType.info))
                              .show(context);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.network(
                              'https://upload.wikimedia.org/wikipedia/commons/9/96/Zoho-logo.png',
                              width: 46,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
