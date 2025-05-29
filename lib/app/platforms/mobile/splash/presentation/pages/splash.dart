import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/sign_up_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/bloc/card_market_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/agent_card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/pages/agent_home.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/bloc/settings_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/splash/presentation/bloc/splash_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/notification_service.dart';
import 'package:hushh_app/widgets/tracking_permission_dialog.dart';
import 'package:hushh_app/services/tracking_service.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:root_jailbreak_sniffer/rjsniffer.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final controller = sl<SplashPageBloc>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Request App Tracking Transparency permission early in app lifecycle
      await _requestTrackingPermissionIfNeeded();
      sl<SignUpPageBloc>().user = AppLocalStorage.user;
      // bool amICompromised = await Rjsniffer.amICompromised() ?? false;
      //
      // if(amICompromised) {
      //
      // } else if()
      if(AppLocalStorage.isUserInActive) {
        sl<SettingsPageBloc>().add(LogoutEvent(context));
        return;
      } else {
        if(AppLocalStorage.isUserLoggedIn) {
          await AppLocalStorage.setUserActiveState();
        }
      }
      controller.add(InitializeEvent());
      sl<CardMarketBloc>().add(FetchBrandsEvent());
      if (AppLocalStorage.isUserLoggedIn) {
        sl<CardWalletPageBloc>().getInstalledCards();
        sl<SplashPageBloc>().add(UpdateUserRegistrationTokenEvent(
            hushhId: Supabase.instance.client.auth.currentUser?.id));
        await NotificationService().setupFcmListeners(context);
        // sl<ReceiptRadarUtils>().googleAuth(refresh: true).then((value) {
        //   if(value != null) {
        //     sl<ReceiptRadarBloc>().accessToken = value;
        //     sl<ReceiptRadarBloc>().add(InsertReceiptRadarHistoryEvent(
        //         ReceiptRadarHistory(
        //             accessToken: value,
        //             hushhId: AppLocalStorage.hushhId!,
        //             supabaseToken: Supabase.instance.client.auth
        //                 .currentSession!.accessToken)));
        //   }
        // });
        sl<SplashPageBloc>().add(const UpdateUserRegistrationTokenEvent());
        if (sl<HomePageBloc>().isUserFlow) {
          sl<CardWalletPageBloc>().getInstalledCards().then((value) {
            sl<SplashPageBloc>().add(FetchAndLoadAllBrandsInCityEvent(
                installedBrandCards: value.item1));
          });
        } else {
          sl<AgentCardWalletPageBloc>().add(FetchAgentToUpdateLocalAgentEvent());
        }
        if(AppLocalStorage.hushhId !=null)
        sl<HomePageBloc>().getCurrentLocation().then((position) {
          sl<SplashPageBloc>().add(InsertUserAgentNewLocationEvent(
              position, AppLocalStorage.hushhId!));
        });
        sl<CardWalletPageBloc>().add(CardWalletInitializeEvent(context));
      }
    });
  }

  /// Request App Tracking Transparency permission if needed
  Future<void> _requestTrackingPermissionIfNeeded() async {
    if (!kIsWeb) {
      try {
        // Check current tracking status
        final currentStatus = await TrackingService.getTrackingStatus();
        print('🔒 [TRACKING] Current tracking status: $currentStatus');
        
        // Only show dialog if status is not determined
        if (currentStatus == TrackingStatus.notDetermined) {
          print('🔒 [TRACKING] Showing tracking permission dialog...');
          
          // Show custom dialog first, then request system permission
          if (mounted) {
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => TrackingPermissionDialog(
                onAuthorized: () {
                  print('🔒 [TRACKING] User authorized tracking');
                },
                onDenied: () {
                  print('🔒 [TRACKING] User denied tracking');
                },
              ),
            );
          }
        } else {
          print('🔒 [TRACKING] Tracking permission already determined: $currentStatus');
        }
      } catch (e) {
        print('🔒 [TRACKING] Error requesting tracking permission: $e');
      }
    }
  }

  @override
  void dispose() {
    controller.add(DisposeEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer(
          listener: (context, state) async {
            if (state is SplashPageLoadedState) {
              switch (controller.onboardStatus) {
                case UserOnboardStatus.initial:
                case UserOnboardStatus.onboardDone:
                case UserOnboardStatus.signUpForm:
                  if (kIsWeb) {
                    final Uri uri = Uri.base;
                    final Map<String, String> queryParams = uri.queryParameters;
                    debugPrint('$queryParams');
                    if (queryParams.containsKey('uid') &&
                        queryParams.containsKey('data')) {
                      int? cardIdAsInt =
                          int.tryParse(queryParams['data'] ?? '');
                      if (cardIdAsInt != null) {
                        if (queryParams['uid'] != null) {
                          await sl<CardWalletPageBloc>()
                              .getInstalledCards(uid: queryParams['uid']);
                        }
                        sl<AgentCardWalletPageBloc>().add(FetchCardInfoEvent(
                            queryParams['uid'] ?? '', cardIdAsInt, context));
                      }
                    }
                  } else {
                    if(sl<HomePageBloc>().entity == Entity.user) {
                      Navigator.pushReplacementNamed(context, AppRoutes.mainAuth);
                    } else {
                      if(Supabase.instance.client.auth.currentUser != null) {
                        Navigator.pushReplacementNamed(context, AppRoutes.agentHome,
                          arguments: AgentHomePageArgs(tabValue: 1));
                      } else {
                        Navigator.pushReplacementNamed(context, AppRoutes.mainAuth);
                      }
                    }
                    // if(AppLocalStorage.isTutorialWatched) {
                    //   Navigator.pushReplacementNamed(context, AppRoutes.mainAuth);
                    // }else {
                    //   Navigator.pushReplacementNamed(context, AppRoutes.tutorial);
                    // }
                  }
                  break;
                // case UserOnboardStatus.signUpForm:
                //   Navigator.pushReplacementNamed(context, AppRoutes.auth);
                //   break;
                case UserOnboardStatus.loggedIn:
                  print(
                      "sl<HomePageBloc>().entity: ${sl<HomePageBloc>().entity}");
                  if (sl<HomePageBloc>().entity == Entity.user) {
                    Navigator.pushReplacementNamed(context, AppRoutes.home);
                  } else if (sl<HomePageBloc>().entity == Entity.agent) {
                    Navigator.pushReplacementNamed(context, AppRoutes.agentHome,
                        arguments: AgentHomePageArgs(tabValue: 1));
                    // switch (AppLocalStorage.agent!.agentApprovalStatus!) {
                    //   case AgentApprovalStatus.approved:
                    //     Navigator.pushReplacementNamed(
                    //         context, AppRoutes.agentHome,
                    //         arguments: AgentHomePageArgs(tabValue: 1));
                    //     break;
                    //   case AgentApprovalStatus.pending:
                    //   case AgentApprovalStatus.denied:
                    //     Navigator.pushReplacementNamed(
                    //         context, AppRoutes.agentStatus,
                    //         arguments:
                    //             AppLocalStorage.agent!.agentApprovalStatus!);
                    //     break;
                    // }
                  }
                  break;
              }
            }
          },
          bloc: controller,
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!kIsWeb)
                    Transform.scale(
                        scale: 1.5,
                        child: Lottie.asset('assets/splash-anim.json',
                            repeat: false))
                  else
                    Image.asset('assets/splash.gif')
                  // SplashAnimation(),
                  // AnimatedContinueButton(),
                ],
              ),
            );
          }),
    );
  }
}
