import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/components/verifying_bottomsheet.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/agent_card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/agent_card_wallet.dart';
import 'package:hushh_app/app/platforms/mobile/chat/presentation/pages/chat_history.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/components/agent_home_page_bottom_navigation_bar.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/pages/settings.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AgentHomePageArgs {
  final int tabValue;
  final Toast? toast;

  AgentHomePageArgs({required this.tabValue, this.toast});
}

class AgentHomePage extends StatefulWidget {
  const AgentHomePage({Key? key}) : super(key: key);

  @override
  _AgentHomePageState createState() => _AgentHomePageState();
}

class _AgentHomePageState extends State<AgentHomePage> {
  final controller = sl<HomePageBloc>();

  bool isBottomSheetOpened = false;

  @override
  void initState() {
    super.initState();
    controller.updateLocation();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final args =
          ModalRoute.of(context)?.settings.arguments as AgentHomePageArgs?;
      int index = args?.tabValue ?? 1;
      controller.add(UpdateHomeScreenIndexEvent(index, context));
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
      body: BlocBuilder(
        bloc: controller,
        builder: (context, state) {
          final tabIndex = state is ActiveScreenUpdatedState ? state.index : 1;
          return [
            const ChatHistory(), //ChatHistoryView(),
            const AgentCardWalletPage(),
            const SettingsPage(),
          ].elementAt(tabIndex);
        },
      ),
      bottomNavigationBar: AgentHomePageBottomNavigationBar(
        onVerify: () async {
          Future.delayed(const Duration(seconds: 4), () {
            if (isBottomSheetOpened) {
              Navigator.pop(context);
              sl<AgentCardWalletPageBloc>()
                  .updateStatus(AgentApprovalStatus.approved);
            }
          });
          isBottomSheetOpened = true;
          await showModalBottomSheet(
              context: context,
              isDismissible: false,
              enableDrag: false,
              backgroundColor: Colors.transparent,
              constraints: BoxConstraints(maxHeight: 30.h),
              builder: (context) => const VerifyingBottomSheet());
          isBottomSheetOpened = false;
        },
      ),
    );
  }
}
