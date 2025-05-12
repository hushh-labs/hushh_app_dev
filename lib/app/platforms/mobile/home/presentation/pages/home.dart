import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/pages/new/user_guide/user_guide_gmail_page.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/pages/agent_market_place.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/pages/discover_page.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/user_purchase_requirements_prompt_bottom_sheet.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/card_wallet.dart';
import 'package:hushh_app/app/platforms/mobile/chat/presentation/pages/ai_chat.dart';
import 'package:hushh_app/app/platforms/mobile/chat/presentation/pages/chat.dart';
import 'package:hushh_app/app/platforms/mobile/chat/presentation/pages/chat_history.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/components/home_page_bottom_navigation_bar.dart';
import 'package:hushh_app/app/shared/core/ai_handler/prompt_gen.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/geofence_service.dart';
import 'package:hushh_app/app/shared/core/utils/notification_service.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePageArgs {
  final int tabValue;
  final Toast? toast;

  HomePageArgs({required this.tabValue, this.toast});
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = sl<HomePageBloc>();

  @override
  void dispose() {
    GeofenceService().stopService();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller.updateLocation().then((value) {
      // update user avatar
      if (AppLocalStorage.user?.avatar?.isEmpty ?? true) {
        controller.add(const UpdateUserProfileEvent());
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final args = ModalRoute.of(context)?.settings.arguments as HomePageArgs?;
      int index = args?.tabValue ?? 0;
      controller.add(UpdateHomeScreenIndexEvent(index, context));
      // sl<CardWalletPageBloc>().fetchHushhUsersInContacts(context).then((value) {
      //   sl<CardWalletPageBloc>().foundHushhContacts = value;
      // });
      if (args?.toast != null) {
        ToastManager(args!.toast!).show(context);
      }
    });
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvoked: (_) {
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else if (Platform.isIOS) {
            exit(0);
          }
        },
        child: BlocBuilder(
          bloc: controller,
          builder: (context, state) {
            final tabIndex = controller.currentIndex;
            return [
              const CardWalletPage(),
              const UserGuideGmailPage(fromHome: true),
              const DiscoverPage(),
              // const AgentMarketPlace(),
              const ChatHistory()
            ].elementAt(tabIndex);
          },
        ),
      ),
      bottomNavigationBar: const HomePageBottomNavigationBar(),
    );
  }
}
