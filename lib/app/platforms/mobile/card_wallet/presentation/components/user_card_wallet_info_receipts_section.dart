import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/receipt_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/shared_asset.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/shared_assets_receipts_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/bloc/receipt_radar_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/pages/receipt_radar_items.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UserCardWalletInfoReceiptsSection extends StatefulWidget {
  final CardModel cardData;

  const UserCardWalletInfoReceiptsSection({super.key, required this.cardData});

  @override
  State<UserCardWalletInfoReceiptsSection> createState() =>
      _UserCardWalletInfoReceiptsSectionState();
}

class _UserCardWalletInfoReceiptsSectionState
    extends State<UserCardWalletInfoReceiptsSection> {
  final controller = sl<SharedAssetsReceiptsBloc>();
  List<ReceiptModel?> receipts = [];

  List<SharedAsset>? get receiptsSharedAssets => controller.fileDataReceipts;

  @override
  void initState() {
    if (widget.cardData.id == Constants.expenseCardId) {
      receipts = sl<ReceiptRadarBloc>().receipts ?? [];
      receipts.sort((a, b) => sl<ReceiptRadarBloc>().sortReceipts(a!, b!));
    } else {
      receipts = receiptsSharedAssets?.map((e) => e.data).toList() ?? [];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Your Receipts'.toUpperCase(),
                style: context.titleSmall?.copyWith(
                  color: const Color(0xFF737373),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.3,
                ),
              ),
              const Spacer(),
              SvgPicture.asset(
                'assets/chat_card_details.svg',
                width: 24,
              ),
              const SizedBox(width: 12),
              SvgPicture.asset(
                'assets/print_card_details.svg',
                width: 20,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: receipts.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/receipt_placeholder.png',
                            width: 50.w,
                          ),
                          const Text(
                            'Upload Receipts to easily get insights and help manage your expenses better',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Color(0xFF939393)),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: HushhLinearGradientButton(
                              text: 'Upload Receipts',
                              onTap: () {
                                sl<SharedAssetsReceiptsBloc>().add(
                                    ShareImagesVideosEvent(
                                        context, widget.cardData,
                                        startReceiptRadar: true,
                                        pop: false));
                              },
                              height: 46,
                              radius: 5,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: receipts.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      if (receipts[index] == null) return const SizedBox();
                      return ReceiptListTile(
                        receipt: receipts[index]!,
                        padding: EdgeInsets.zero,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
