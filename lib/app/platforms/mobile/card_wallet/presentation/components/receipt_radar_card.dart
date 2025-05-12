import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/receipts_fetching_banner.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/backend_controller/db_controller/db_tables.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:local_auth_crypto/local_auth_crypto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReceiptRadarCard extends StatefulWidget {
  const ReceiptRadarCard({super.key});

  @override
  State<ReceiptRadarCard> createState() => _ReceiptRadarCardState();
}

class _ReceiptRadarCardState extends State<ReceiptRadarCard> {
  final stream = Supabase.instance.client
      .from(DbTables.receiptRadarHistory)
      .stream(primaryKey: ['id']);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamBuilder(
          stream: stream,
          builder: (context, state) {
            Map<String, dynamic>? row = state.data
                ?.where((element) =>
                    element['id'].toString() == AppLocalStorage.receiptRadarSessionId)
                .firstOrNull;
            if(row?['status'] == 'completed') {
              AppLocalStorage.setSessionIdForReceiptRadar(null);
            }
            if ((row != null && AppLocalStorage.isReceiptRadarFetchingReceipts)) {
              return Column(
                children: [
                  ReceiptsFetchingBanner(count: row['total_receipts'] ?? 0),
                  const SizedBox(height: 16),
                ],
              );
            }
            return const SizedBox();
          },
        ),
        InkWell(
          onTap: () async {
            open() async {
              Navigator.pushNamed(context, AppRoutes.receiptRadar.onboarding);
            }

            final localAuthCrypto = LocalAuthCrypto.instance;
            String? encryptedToken = AppLocalStorage.receiptRadarEncryptedToken;
            if (encryptedToken != null) {
              final promptInfo = BiometricPromptInfo(
                title: 'Unlock Receipt Radar',
                subtitle: 'Please scan biometric to access your receipts',
                negativeButton: 'CANCEL',
              );
              try {
                final plainText = await localAuthCrypto.authenticate(
                    promptInfo, encryptedToken);
                if (plainText != null) {
                  open();
                }
              } catch (_) {}
            } else {
              open();
            }
          },
          child: Card(
            margin: EdgeInsets.zero,
            color: Colors.white,
            elevation: 5,
            child: Column(
              children: [
                Image.asset(
                  'assets/receipt_radar_card.png',
                  width: double.infinity,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/receipt_radar_list_tile_icon.png',
                        width: 68,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Receipt Radar',
                            style: context.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'End the search\nNever lose a receipt again.',
                            style: context.bodySmall?.copyWith(
                                color: const Color(0xFFA0A0A0),
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IgnorePointer(
                        ignoring: true,
                        child: ElevatedButton(
                          onPressed: () async {},
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xFFEEEEEF),
                            foregroundColor: Colors.blue,
                          ),
                          child: const Text('Use'),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
