import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/presentation/bloc/card_share_ecosystem_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/agent_card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class NotificationListenerService {
  static Future<void> listen(NotificationResponse noti) async {
    final currentState = navigatorKey.currentState;

    if (currentState == null) {
      return;
    }

    switch (noti.id) {
      case NotificationsConstants.ASKING_USER_REASON_TO_ENTER_IN_BRAND_STORE:
        int? brandIdAsInt = jsonDecode(noti.payload!)['brandId'];
        String? uid = jsonDecode(noti.payload!)['userId'];
        if (brandIdAsInt != null) {
          if (uid != null) {
            await sl<CardWalletPageBloc>().getInstalledCards(uid: uid);
          }
          sl<CardShareEcosystemBloc>()
              .add(FetchBrandOfferEvent(brandIdAsInt, currentState.context));
        }
        break;
      case NotificationsConstants.INFORMING_AGENT_ABOUT_USER_REQUEST:
        int? cardIdAsInt = jsonDecode(noti.payload!)['cardId'];
        String? uid = jsonDecode(noti.payload!)['userId'];
        String? query = jsonDecode(noti.payload!)['query'];
        if (cardIdAsInt != null) {
          if (uid != null) {
            await sl<CardWalletPageBloc>().getInstalledCards(uid: uid);
          }
          sl<AgentCardWalletPageBloc>().add(FetchCardInfoEvent(
              uid ?? '', cardIdAsInt, currentState.context,
              query: query));
        }
        break;
      default:
        break;
    }
  }
}
