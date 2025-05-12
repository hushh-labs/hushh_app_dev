import 'package:auto_size_text/auto_size_text.dart';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/sign_up_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/pages/new/user_guide/user_guide.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/agent_card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/agent_task_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/agent_card_widget.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/agent_qr_scan_bottom_sheet.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/customer_list_view.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/load_more_button.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/quick_insights_menu.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/task_list_view.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/wallet_app_bar.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/components/animated_refresh_button.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:toastification/toastification.dart';
import 'package:tuple/tuple.dart';

class AgentCardWalletPage extends StatefulWidget {
  const AgentCardWalletPage({super.key});

  @override
  State<AgentCardWalletPage> createState() => _AgentCardWalletPageState();
}

class _AgentCardWalletPageState extends State<AgentCardWalletPage>
    with SingleTickerProviderStateMixin {
  late List<Tuple3<String, String, Function()>> quickInsightsMenu;
  final controller = sl<AgentCardWalletPageBloc>();

  @override
  void initState() {
    controller.tabController = TabController(length: 2, vsync: this);
    quickInsightsMenu = [
      Tuple3(
          "assets/new_customer_icon.png",
          "New Customers",
          () => Navigator.pushNamed(context, AppRoutes.agentDashboard,
              arguments: 2)),
      Tuple3(
          "assets/upcoming_meeting_icon.png",
          "Upcoming Meetings",
          () => Navigator.pushNamed(context, AppRoutes.agentDashboard,
              arguments: 1)),
      Tuple3("assets/lookbook.png", "Lookbook & Products", () {
        Navigator.pushNamed(context, AppRoutes.agentLookbook);
        // sl<HomePageBloc>().add(UpdateHomeScreenIndexEvent(0));
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => const ChatHistory(
        //               newScreen: true,
        //             )));
      }),
      Tuple3("assets/incentive_progress_icon.png", "Incentive Progress", () {
        ToastManager(Toast(title: 'Coming Soon', type: ToastificationType.info))
            .show(context);
      }),
    ];
    controller.add(FetchAgentCardEvent());

    sl<AgentTaskBloc>().add(FetchTasksEvent());
    controller.tabIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: WalletAppBar(setState: setState),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          shape: const CircleBorder(),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [
                  Color(0xFFE54D60),
                  Color(0xFFA342FF),
                ])),
            child: Image.asset('assets/scanner_icon.png'),
          ),
          onPressed: () {
            //sl<AgentCardWalletPageBloc>().add(FetchCardInfoEvent(userUid, brandId, context));
            showModalBottomSheet(
              backgroundColor: Colors.white,
              constraints: BoxConstraints(maxHeight: 70.h),
              context: context,
              isDismissible: true,
              builder: (context) => const AgentQrScanBottomSheet(),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 25.h,
                    child: Stack(
                      children: [
                        if (AppLocalStorage.agent != null)
                          const AgentCardWidget()
                        else
                          const AgentCardWidget().blurred(
                              blur: AppLocalStorage.agent == null ? 4 : 0,
                              borderRadius: BorderRadius.circular(12),
                              colorOpacity:
                                  AppLocalStorage.agent == null ? 0.1 : 0),
                        if (AppLocalStorage.agent == null)
                          Positioned.fill(
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset('assets/lock_3d_icon.png',
                                      width: 64),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Unlock Agent Card',
                                    style: context.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Transform.scale(
                                    scale: .75,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        sl<SignUpPageBloc>()
                                            .add(SignUpInitializeEvent());
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                type: PageTransitionType
                                                    .bottomToTop,
                                                child: const UserGuidePage()));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        foregroundColor:
                                            const Color(0xFFE51A5E),
                                      ),
                                      child: const Text('Complete profile'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  Text(
                    'Quick Insights',
                    style: context.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 2),
                    itemCount: quickInsightsMenu.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final insight = quickInsightsMenu[index];
                      return QuickInsightMenu(quickInsightMenu: insight);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            Row(
              children: [
                SizedBox(
                  width: 65.w,
                  child: TabBar(
                    controller: controller.tabController,
                    indicatorColor: const Color(0xFFe5e8eb),
                    onTap: (index) {
                      if (index == 0 && controller.tabIndex == 0) {
                        Navigator.pushNamed(context, AppRoutes.agentDashboard,
                            arguments: 0);
                      } else if (index == 1 && controller.tabIndex == 1) {
                        Navigator.pushNamed(context, AppRoutes.agentDashboard,
                            arguments: 2);
                      }
                      controller.tabIndex = index;
                    },
                    labelStyle: context.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFE51A5E)),
                    tabs: const [
                      Tab(
                        child: AutoSizeText('Services'),
                      ),
                      Tab(
                        child: AutoSizeText('Customers'),
                      ),
                    ],
                    dividerColor: const Color(0xFFe8d1d6),
                  ),
                ),
                const Spacer(),
                AnimatedRefreshButton(onPressed: () {
                  sl<AgentCardWalletPageBloc>().add(FetchCustomersEvent());
                  sl<AgentTaskBloc>().add(FetchTasksEvent());
                })
              ],
            ),
            Container(
              width: double.infinity,
              height: 265,
              decoration: const BoxDecoration(
                color: Color(0xFFFCF7FA),
              ),
              child: BlocBuilder(
                  bloc: controller,
                  builder: (context, state) {
                    return TabBarView(
                      controller: controller.tabController,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            BlocBuilder(
                                bloc: sl<AgentTaskBloc>(),
                                builder: (context, state) {
                                  return TaskListView(
                                      tasks: sl<AgentTaskBloc>().tasks,
                                      length: (sl<AgentTaskBloc>()
                                                      .tasks
                                                      ?.length ??
                                                  0) >
                                              3
                                          ? 3
                                          : sl<AgentTaskBloc>().tasks?.length);
                                }),
                            if ((sl<AgentTaskBloc>().tasks?.length ?? 0) > 3)
                              LoadMoreButton(onTap: () {
                                Navigator.pushNamed(
                                    context, AppRoutes.agentDashboard,
                                    arguments: 0);
                              })
                          ],
                        ),
                        Align(
                          alignment: (controller.customers?.isNotEmpty ?? false)
                              ? Alignment.topCenter
                              : Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomerListView(
                                  customers: controller.customers,
                                  search: false,
                                  length:
                                      (controller.customers?.length ?? 0) > 3
                                          ? 3
                                          : controller.customers?.length),
                              if ((controller.customers?.length ?? 0) > 3)
                                LoadMoreButton(onTap: () {
                                  Navigator.pushNamed(
                                      context, AppRoutes.agentDashboard,
                                      arguments: 2);
                                })
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
            ),
            // SizedBox(height: 26),
            // Padding(
            //   padding: const EdgeInsets.only(left: 20.0),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         'Trend Alert',
            //         style: context.headlineSmall
            //             ?.copyWith(fontWeight: FontWeight.w700),
            //       ),
            //       SizedBox(height: 16),
            //       SizedBox(
            //         height: 60.h,
            //         child: ListView.builder(
            //           shrinkWrap: true,
            //           itemCount: controller.trends.length,
            //           scrollDirection: Axis.horizontal,
            //           itemBuilder: (context, index) =>
            //               TrendListTile(trend: controller.trends[index]),
            //         ),
            //       ),
            //       SizedBox(height: 32),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
