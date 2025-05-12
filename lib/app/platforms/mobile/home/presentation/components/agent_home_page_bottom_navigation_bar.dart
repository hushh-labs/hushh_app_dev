import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/pages/new/agent_guide/agent_guide_brand_agent_verification.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/agent_card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/assets/icon.dart';
import 'package:hushh_app/app/shared/config/constants/colors.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/components/animated_refresh_button.dart';
import 'package:hushh_app/app/shared/core/components/help_button.dart';
import 'package:hushh_app/app/shared/core/hushh_story_editor/vs_story_designer.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:image_picker/image_picker.dart';

class AgentHomePageBottomNavigationBar extends StatelessWidget {
  final Function() onVerify;

  const AgentHomePageBottomNavigationBar({super.key, required this.onVerify});

  @override
  Widget build(BuildContext context) {
    final controller = sl<HomePageBloc>();
    return BlocBuilder(
        bloc: sl<AgentCardWalletPageBloc>(),
        builder: (context, _) {
          return BlocBuilder(
              bloc: controller,
              builder: (context, state) {
                final tabIndex =
                    state is ActiveScreenUpdatedState ? state.index : 1;
                bool isAgentApprovedForBrand = AppLocalStorage
                        .agent?.agentBrand?.agentToOperateForBrandStatus ==
                    AgentApprovalStatus.approved;
                bool isAgentApprovalPending =
                    AppLocalStorage.agent?.agentApprovalStatus ==
                        AgentApprovalStatus.pending;
                bool isAgentVerificationNotInitiated =
                    AppLocalStorage.agent?.agentApprovalStatus == null;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (AppLocalStorage.hushhId != null &&
                        (isAgentApprovedForBrand ||
                            isAgentApprovalPending ||
                            isAgentVerificationNotInitiated))
                      GestureDetector(
                        onTap: () {
                          if (isAgentApprovedForBrand) {
                            return;
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Scaffold(
                                        body:
                                            AgentGuideBrandAgentVerification(),
                                      )));
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 10,
                                  blurRadius: 20,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(24),
                                  topRight: Radius.circular(24))),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isAgentApprovedForBrand
                                          ? 'Pending Brand Verification'
                                          : 'Pending Agent Verification',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                        isAgentApprovedForBrand
                                            ? AppLocalStorage.agent?.role ==
                                                    AgentRole.Admin
                                                ? 'We are trying to verify you with the brand domain. This can take upto 48 hours'
                                                : 'We are trying to verify you with the brand admins. This can take upto 48 hours'
                                            : isAgentVerificationNotInitiated
                                                ? 'Please verify your agent profile to enable additional features.'
                                                : 'We are trying to verify your profile. This can take upto 48 hours',
                                        style: const TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ),
                              if (!isAgentVerificationNotInitiated)
                                AnimatedRefreshButton(
                                  onPressed: () {},
                                )
                              else
                                const SizedBox(width: 6),
                              if (isAgentVerificationNotInitiated)
                                VerifyButton(onVerify: onVerify)
                              else
                                const HelpButton(),
                            ],
                          ),
                        ),
                      ),
                    BottomNavigationBar(
                      onTap: (int index) async {
                        if(controller.currentIndex == 1 && index == 1) {
                            XFile? result = await ImagePicker().pickImage(
                              imageQuality: 60,
                              maxWidth: 1440,
                              source: ImageSource.gallery,
                            );
                            if(result != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VSStoryDesigner(
                                      centerText: "Start Creating Your Story",
                                      themeType: ThemeType.light,
                                      galleryThumbnailQuality: 250,
                                      onDone: (uri) {
                                        debugPrint(uri);
                                      },
                                      mediaPath: result!.path,
                                    )));
                            }
                        } else {
                          controller
                              .add(UpdateHomeScreenIndexEvent(index, context));
                        }
                      },
                      backgroundColor: Colors.white,
                      currentIndex: tabIndex,
                      selectedItemColor: CustomColors.projectBaseBlue,
                      showSelectedLabels: false,
                      showUnselectedLabels: false,
                      items: [
                        BottomNavigationBarItem(
                          icon: SvgPicture.asset(
                            AppIcons.chatIcon,
                            color: tabIndex == 0
                                ? CustomColors.projectBaseBlue
                                : Colors.black,
                          ),
                          label: "Chat",
                        ),
                        false //tabIndex == 1
                            ? BottomNavigationBarItem(
                          icon: Container(
                            width: 42,
                            height: 42,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Color(0xFFE54D60),
                                Color(0xFFA342FF),
                              ]),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white, // Icon color
                            ),
                          ),
                          label: '',
                        )
                            : BottomNavigationBarItem(
                                icon: SvgPicture.asset(
                                  "assets/wallet_icon.svg",
                                  color: tabIndex == 1
                                      ? CustomColors.projectBaseBlue
                                      : Colors.black,
                                ),
                                label: "Wallet",
                              ),
                        BottomNavigationBarItem(
                          icon: SvgPicture.asset(
                            "assets/settings_icon.svg",
                            color: tabIndex == 2
                                ? CustomColors.projectBaseBlue
                                : Colors.black,
                          ),
                          label: "Settings",
                        ),
                      ],
                      // curve: Curves.easeInBack,
                    ),
                  ],
                );
              });
        });
  }
}
