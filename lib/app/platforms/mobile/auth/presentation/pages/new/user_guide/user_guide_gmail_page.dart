import 'package:collection/collection.dart';
import 'package:fadingpageview/fadingpageview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/auth_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/sign_up_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/pages/new/user_guide/coin_gmail_page.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/receipt_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/user_coins_elevated_button.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/card_wallet_info/card_wallet_info.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/data/models/receipt_radar_history.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/bloc/receipt_radar_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/pages/receipt_radar_dashboard.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/pages/receipt_radar_utils.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';
import 'package:hushh_app/app/shared/core/components/hushh_secondary_button.dart';
import 'package:hushh_app/app/shared/core/components/receipt_radar_loader_widget.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tuple/tuple.dart';
import 'package:vibration/vibration.dart';

class UserGuideGmailPage extends StatefulWidget {
  final bool fromHome;

  const UserGuideGmailPage({super.key, this.fromHome = false});

  @override
  State<UserGuideGmailPage> createState() => _UserGuideGmailPageState();
}

class _UserGuideGmailPageState extends State<UserGuideGmailPage> {
  bool firstReceiptNotFetchedYet = false;
  List<ReceiptModel>? receipts;
  bool fetchingReceipts = false;

  bool get haveReceiptsOrProcessingReceipts =>
      (receipts != null && receipts!.isNotEmpty) || firstReceiptNotFetchedYet;

  @override
  void initState() {
    if (widget.fromHome) {
      fetchingReceipts = true;
      setState(() {});
      sl<ReceiptRadarUtils>().fetchReceipts(forceFetch: true).then((value) {
        fetchingReceipts = false;
        receipts = value;
        if ((receipts?.isEmpty ?? true) &&
            AppLocalStorage.isReceiptRadarFetchingReceipts) {
          firstReceiptNotFetchedYet = true;
        }
        sl<ReceiptRadarBloc>().receipts = receipts;
        if (mounted) {
          setState(() {});
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return haveReceiptsOrProcessingReceipts
        ? Scaffold(
            floatingActionButton: receipts?.isNotEmpty ?? false
                ? InkWell(
                    onTap: () {
                      final cardData = sl<CardWalletPageBloc>()
                          .preferenceCards
                          .firstWhereOrNull((element) =>
                              element.id == Constants.expenseCardId);
                      if (cardData != null) {
                        Navigator.pushNamed(
                            context, AppRoutes.cardWallet.info.main,
                            arguments:
                                CardWalletInfoPageArgs(cardData: cardData));
                      } else {
                        ToastManager(Toast(
                                title:
                                    'Please add Expense card from card marketplace first'))
                            .show(context);
                      }
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: [
                          Color(0XFFA342FF),
                          Color(0XFFE54D60),
                        ]),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: const Icon(
                        Icons.bar_chart,
                        color: Colors.white,
                      ),
                    ),
                  )
                : null,
            appBar: AppBar(
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Your Receipts'),
                  AppLocalStorage.isReceiptRadarFetchingReceipts
                      ? const Row(
                          children: [
                            Text(
                              'Fetching receipts...',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            SizedBox(width: 4),
                            CupertinoActivityIndicator(
                              radius: 6,
                            )
                          ],
                        )
                      : const SizedBox()
                ],
              ),
              centerTitle: false,
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    Tuple2<String?, String?>? data =
                        await sl<ReceiptRadarUtils>().googleAuth();
                    if (data?.item1 != null) {
                      ToastManager(Toast(
                              title: 'Running receipt radar...',
                              description:
                                  'We are syncing all your receipts in the background and will notify you once the processing is done'))
                          .show(context, alignment: Alignment.bottomRight);
                      sl<ReceiptRadarBloc>().add(UpdateReceiptRadarHistoryEvent(
                          ReceiptRadarHistory(
                              accessToken: data!.item2,
                              email: data.item1!,
                              hushhId: AppLocalStorage.hushhId!)));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0, foregroundColor: const Color(0xFFE51A5E)),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 4),
                      Text('Add new')
                    ],
                  ),
                ),
              ],
            ),
            body: Builder(
              builder: (context) {
                if (receipts?.isNotEmpty ?? false) {
                  return const ReceiptRadarDashboardPage();
                } else if (firstReceiptNotFetchedYet) {
                  return const Center(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [ReceiptRadarLoaderWidget()],
                  ));
                }
                return const SizedBox();
              },
            ),
          )
        : Center(
            child: fetchingReceipts
                ? const CupertinoActivityIndicator()
                : Stack(
                    children: [
                      if (widget.fromHome)
                        const SafeArea(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [UserCoinsElevatedButton()],
                            ),
                          ),
                        ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: sl<AuthPageBloc>().areReceiptsAnalyzing
                            ? const ConnectingGmail()
                            : ConnectGmail(
                                fromHome: widget.fromHome,
                                onAccountSelected: () {
                                  sl<AuthPageBloc>().areReceiptsAnalyzing =
                                      true;
                                  setState(() {});
                                }),
                      ),
                    ],
                  ),
          );
  }
}

String desc =
    'Effortlessly organize your receipts, insurance details, and much more—all in one place, updated automatically every day.';

class ConnectGmail extends StatelessWidget {
  final Function() onAccountSelected;
  final bool fromHome;

  const ConnectGmail(
      {super.key, required this.onAccountSelected, required this.fromHome});

  FadingPageViewController get scrollController =>
      sl<SignUpPageBloc>().userGuideController;

  int get totalPages => sl<SignUpPageBloc>().totalPages;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: [
          if (!fromHome)
            Column(
              children: [
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                      '${((scrollController.currentPage / totalPages) * 100).toStringAsFixed(0)}%'),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: scrollController.currentPage / totalPages,
                  color: const Color(0xFF6725F2),
                  borderRadius: BorderRadius.circular(50),
                  minHeight: 10,
                ),
              ],
            ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Lottie.asset(
                    'assets/gmail_anim.json',
                    width: 80.w,
                    animate: true
                  ),
                ),
                Text(
                  'Connect G-mail',
                  style: context.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    desc,
                    style: context.bodyMedium
                        ?.copyWith(color: const Color(0xFF575757)),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20.h)
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HushhLinearGradientButton(
                  text: 'Connect Email',
                  height: 48,
                  color: Colors.black,
                  onTap: () async {
                    Tuple2<String?, String?>? data =
                        await sl<ReceiptRadarUtils>().googleAuth();
                    String? accessToken = data?.item2;
                    String? email = data?.item1;
                    String? hushhId =
                        Supabase.instance.client.auth.currentUser?.id;
                    sl<SignUpPageBloc>().accessToken = accessToken;
                    if (email != null) {
                      sl<ReceiptRadarBloc>().add(UpdateReceiptRadarHistoryEvent(
                          ReceiptRadarHistory(
                              accessToken: accessToken,
                              email: email,
                              hushhId: hushhId!)));
                      onAccountSelected.call();
                    }
                  },
                  radius: 12,
                ),
                if (!fromHome) ...[
                  const SizedBox(height: 16),
                  HushhSecondaryButton(
                    text: 'Connect later',
                    height: 48,
                    onTap: () => scrollController.next(),
                    radius: 12,
                  ),
                ] else ...[
                  const SizedBox(height: 8),
                  Text(
                    'Connect & earn $receiptRadarCoins Hushh coins 🤑',
                    style: context.bodyMedium
                        ?.copyWith(color: const Color(0xFF575757)),
                    textAlign: TextAlign.center,
                  ).animate(delay: 400.ms).fadeIn().moveY(duration: 300.ms)
                ],
                const SizedBox(height: 32)
              ],
            ).animate(delay: 300.ms).fadeIn().moveY(duration: 300.ms),
          )
        ],
      ),
    );
  }
}

class ConnectingGmail extends StatefulWidget {
  const ConnectingGmail({super.key});

  @override
  State<ConnectingGmail> createState() => _ConnectingGmailState();
}

class _ConnectingGmailState extends State<ConnectingGmail> {
  FadingPageViewController get scrollController =>
      sl<SignUpPageBloc>().userGuideController;

  double progressBar = 0.1;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 100), () async {
      progressBar = 0.3;
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 4000));
      Future.delayed(const Duration(milliseconds: 600), () async {
        progressBar = 1;
        setState(() {});
        await Future.delayed(const Duration(milliseconds: 4000));
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.bottomToTop,
                duration: const Duration(milliseconds: 300),
                child: const CoinGmailPage()));
        Future.delayed(const Duration(milliseconds: 50), () {
          AudioPlayer()
            ..setAsset('assets/cha_ching.mp3')
            ..play();
        });
        Future.delayed(const Duration(milliseconds: 500), () async {
          if ((await Vibration.hasVibrator()) ?? false) {
            Vibration.vibrate();
          }
          scrollController.next();
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const double horizontalPadding = 20;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
                child: Lottie.asset(
                    'assets/gmail_anim.json',
                    width: 80.w,
                    animate: true
                )),
            Text(
              'Connect Email',
              style:
                  context.headlineMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                desc,
                style: context.bodyMedium
                    ?.copyWith(color: const Color(0xFF575757)),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 100.w - horizontalPadding * 2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    color: Colors.grey.shade300.withOpacity(0.7)),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(seconds: 4),
                      width: (100.w * progressBar) - horizontalPadding * 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        gradient: const LinearGradient(colors: [
                          Color(0XFFA342FF),
                          Color(0XFFE54D60),
                        ]),
                      ),
                      child: const SizedBox(
                        height: 20.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Analyzing receipts'),
                SizedBox(width: 8),
                CupertinoActivityIndicator(
                  radius: 8,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
