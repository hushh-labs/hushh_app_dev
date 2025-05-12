import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/agent.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/agent_sign_up_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/bloc/card_market_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/agent_card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/hushh_meet_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/lookbook_product_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/agent_profile_header.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/agent_profile_tabbar.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/lookbooks_list_view.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/products_list_view.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AgentProfile extends StatefulWidget {
  const AgentProfile({super.key});

  @override
  State<AgentProfile> createState() => _AgentProfileState();
}

class _AgentProfileState extends State<AgentProfile>
    with SingleTickerProviderStateMixin {
  final controller = sl<LookBookProductBloc>();

  TabController get tabController =>
      sl<AgentCardWalletPageBloc>().profileTabController;

  bool get isAgent => sl<CardWalletPageBloc>().isAgent;

  @override
  void initState() {
    sl<CardMarketBloc>().add(FetchCardMarketEvent());
    sl<HushhMeetBloc>().meeting = null;
    sl<AgentCardWalletPageBloc>().profileTabController =
        TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AgentModel? agent =
          ModalRoute.of(context)!.settings.arguments as AgentModel?;
      if (agent != null) {
        sl<CardWalletPageBloc>().selectedAgent = agent;
        controller.add(FetchAllProductsEvent(agent.agentBrandId));
        controller.add(FetchLookBooksEvent());
      }
    });
    controller.add(FetchLookBooksEvent());
    if (!isAgent) {
      sl<HushhMeetBloc>().add(FetchMeetInfoAsUserEvent());
    }
    tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AgentModel? agent =
        ModalRoute.of(context)!.settings.arguments as AgentModel?;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: AppLocalStorage.agent?.role == AgentRole.Admin
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16)
                  .copyWith(bottom: 16),
              child: SizedBox(
                height: 56,
                child: HushhLinearGradientButton(
                  text: 'Customize Brand Card',
                  onTap: () {
                    ToastManager(Toast(
                            title: 'Coming soon 🤫',
                            description:
                                'We are working on this feature right now'))
                        .show(context);
                  },
                ),
              ),
            )
          : const SizedBox(),
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverAppBar(
              pinned: true,
              actions: [
                BlocBuilder(
                  bloc: sl<HushhMeetBloc>(),
                  builder: (context, state) {
                    if ((sl<HushhMeetBloc>().meeting?.isActivated ?? false) ||
                        isAgent) {
                      return ElevatedButton(
                        onPressed: () {
                          if (isAgent) {
                            Navigator.pushNamed(
                                context, AppRoutes.agentHushhMeet);
                          } else {
                            Navigator.pushNamed(
                                context, AppRoutes.userHushhMeet);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            foregroundColor: const Color(0xFFE51A5E)),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.videocam_outlined),
                            SizedBox(width: 6),
                            Text('Setup HushhMeet')
                          ],
                        ),
                      );
                    }

                    return const SizedBox();
                  },
                )
              ],
              expandedHeight: topSpacing +
                  imageHeight +
                  (basicInfoVerticalPadding * 2) +
                  (actionButtonsVerticalPadding * 2) +
                  actionButtonHeight +
                  categoriesSpacing +
                  (kChipHeight * 2) +
                  (verticalPadding * 2) +
                  85 +
                  kTextTabBarHeight +
                  kToolbarHeight,
              flexibleSpace: BlocBuilder(
                  bloc: sl<AgentSignUpPageBloc>(),
                  builder: (context, state) {
                    return AgentProfileHeader(
                        agent: agent ?? AppLocalStorage.agent!);
                  }),
              bottom: AgentProfileTabBar(
                onTap: (index) {
                  tabController.animateTo(index);
                  setState(() {});
                },
              ),
              backgroundColor: Colors.white,
            ),
          ];
        },
        body: BlocBuilder(
            bloc: controller,
            builder: (context, state) {
              return TabBarView(
                controller: sl<AgentCardWalletPageBloc>().profileTabController,
                children: [
                  controller.lookbooks != null
                      ? controller.lookbooks!.isNotEmpty
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: LookBooksListView(
                                lookbooks: controller.lookbooks!,
                              ),
                            )
                          : Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Lottie.asset('assets/empty-lookbook.json',
                                      width: 30.w),
                                  const SizedBox(height: 28),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Text(
                                      'Hey! lets create a look book for you. Look books are a collection of your products that you create and share it with potential Users',
                                      style:
                                          TextStyle(color: Color(0xFFA2A2A2)),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            )
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                  controller.inventoryAllProductsResult != null
                      ? controller.inventoryAllProductsResult!.products.isNotEmpty
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: ProductsListView(
                                shouldDismiss: true,
                                onDelete: (product) {
                                  // controller.allProducts!.remove(product);
                                  // controller.add(DeleteProductEvent(
                                  //     product, context, null));
                                },
                                shouldSelectProducts: false,
                                products: controller.inventoryAllProductsResult!.products,
                              ),
                            )
                          : Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Lottie.asset('assets/empty-lookbook.json',
                                      width: 30.w),
                                  const SizedBox(height: 28),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Text(
                                      'Just add your products here and \nwe\'ll take care of the rest!',
                                      style:
                                          TextStyle(color: Color(0xFFA2A2A2)),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            )
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                ],
              );
            }),
      ),
    );
  }
}
