import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/customer_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/user_request.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/agent_card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/plaid_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/shared_assets_receipts_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/card_wallet_info/agent_card_wallet_info_page.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/card_wallet_info/user_card_wallet_info_screen.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/bloc/settings_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';

class CardWalletInfoPageArgs {
  final CardModel cardData;
  final CustomerModel? customer;
  final Toast? toast;
  final bool overrideAccess;
  final UserRequest? userRequest;

  CardWalletInfoPageArgs(
      {required this.cardData,
      this.toast,
      this.customer,
        this.userRequest,
      this.overrideAccess = false});
}

class CardWalletInfoPage extends StatefulWidget {
  const CardWalletInfoPage({Key? key}) : super(key: key);

  @override
  State<CardWalletInfoPage> createState() => _CardWalletInfoPageState();
}

class _CardWalletInfoPageState extends State<CardWalletInfoPage> {
  final controller = sl<CardWalletPageBloc>();
  CustomerModel? customer;

  @override
  void initState() {
    if (AppLocalStorage.agent != null) {
      sl<HomePageBloc>().updateLocation().then((value) {
        setState(() {});
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final args = (ModalRoute.of(context)!.settings.arguments!
          as CardWalletInfoPageArgs);
      final cardData = args.cardData;
      controller.selectedCardWalletInfoTabIndex = 0;
      if (controller.isAgent) {
        controller.add(FetchUpdatedAccessListEvent(cardData.cid!));
      }
      if(controller.isUser) {
        sl<SharedAssetsReceiptsBloc>().add(FetchReceiptsFromReceiptRadarEvent(args.cardData));
        sl<SharedAssetsReceiptsBloc>().add(FetchAllAssetsEvent(args.cardData));
      }
      final toast = args.toast;
      if (toast != null) {
        ToastManager(toast).show(context);
      }

      if(cardData.id == Constants.wishlistCardId) {
        sl<SettingsPageBloc>()
            .add(FetchBrowsedCollectionsBasedOnBrowsingBehaviourEvent(AppLocalStorage.hushhId!));
      } else if(cardData.id == Constants.financeCardId) {
        sl<PlaidBloc>().add(FetchFinanceCardInfoEvent(context));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        (ModalRoute.of(context)!.settings.arguments! as CardWalletInfoPageArgs);
    final cardData = args.cardData;
    controller.cardData = cardData;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        sl<CardWalletPageBloc>()
            .add(CardWalletInitializeEvent(context, refresh: true));
        Navigator.pop(context);
        return true;
      },
      child: BlocBuilder(
        bloc: controller,
        builder: (context, state) {
          customer ??= args.customer;
          if (state is FetchedUpdatedAccessListState) {
            final brand =
                customer!.brand.copyWith(accessList: state.accessList);
            customer = CustomerModel(user: customer!.user, brand: brand);
          }
          return (controller.isUser
              ? UserCardWalletInfoScreen(
                  cardData: cardData,
                )
              : AgentCardWalletInfoPage(
                  customer: customer!,
                  userRequest: args.userRequest,
                  overrideAccess: args.overrideAccess,
                ));
        },
      ),
    );
  }
}
