import 'dart:async';
import 'dart:math';

import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/receipt_model.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/bloc/receipt_radar_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/components/receipt_radar_app_bar.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/components/receipt_radar_button.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/pages/receipt_radar_auth_bottomsheet.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/pages/receipt_radar_dashboard.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/pages/receipt_radar_insights/receipt_radar_insights.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/pages/receipt_radar_utils.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ReceiptRadarOnboarding extends StatefulWidget {
  const ReceiptRadarOnboarding({super.key});

  @override
  State<ReceiptRadarOnboarding> createState() => _ReceiptRadarOnboardingState();
}

class _ReceiptRadarOnboardingState extends State<ReceiptRadarOnboarding> {
  int currentIndex = 0;
  late Timer timer;
  List<ReceiptModel>? receipts;
  bool firstReceiptNotFetchedYet = false;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      currentIndex = currentIndex == 0 ? 1 : 0;
      setState(() {});
    });
    sl<ReceiptRadarUtils>().fetchReceipts(forceFetch: true).then((value) {
      receipts = value;
      if ((receipts?.isEmpty ?? true) &&
          AppLocalStorage.isReceiptRadarFetchingReceipts) {
        firstReceiptNotFetchedYet = true;
      }
      sl<ReceiptRadarBloc>().receipts = receipts;
      setState(() {});
      timer.cancel();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  bool get haveReceipts => receipts != null && receipts!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      floatingActionButton: haveReceipts
          ? InkWell(
              onTap: () {
                List<ReceiptModel> receipts =
                    sl<ReceiptRadarBloc>().receipts ?? [];
                final filterReceipts = receipts
                    .where((element) =>
                sl<ReceiptRadarBloc>()
                    .filterBasedReceipts
                    ?.contains(element) ??
                    false)
                    .toList();
                if (filterReceipts.isNotEmpty) {
                  receipts = filterReceipts;
                }
                // Navigator.pushNamed(context, AppRoutes.receiptRadar.insights,
                //     arguments: ReceiptRadarInsightsArgs(
                //         uid: AppLocalStorage.hushhId!, receipts: receipts));
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
                child: Transform.rotate(
                    angle: pi * 0,
                    child: SvgPicture.asset('assets/star-icon.svg',
                        color: Colors.white, width: 34)),
              ),
            )
          : null,
      appBar: haveReceipts
          ? AppBar(
              title: const Text('Your Receipts'),
              actions: [
                ElevatedButton(
                  onPressed: () => showModalBottomSheet(
                      context: context,
                      builder: (context) =>
                          const ReceiptRadarAuthBottomSheet()),
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
              leading: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: SvgPicture.asset('assets/back.svg')),
              ),
            )
          : const ReceiptRadarAppBar(),
      body: Builder(builder: (context) {
        if (haveReceipts) {
          return const ReceiptRadarDashboardPage();
        } else if (firstReceiptNotFetchedYet) {
          return const Center(
              child: Text(
                  'We are still processing your receipts\nplease retry in a while...'));
        } else if (receipts?.isEmpty ?? false) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                Text(
                  'Turn your receipts\ninto rewards',
                  textAlign: TextAlign.center,
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: const Alignment(0, -0.5),
                    child: Column(
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(seconds: 1),
                          child: currentIndex == 0
                              ? Column(
                                  key: const ValueKey<int>(0),
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/receipt_radar_onboard.gif',
                                      width: 60.w,
                                    ),
                                    const SizedBox(height: 16),
                                    const Opacity(
                                      opacity: 0,
                                      child: Text(
                                        '''Link your email account and accept permissions\n\nAutomatically earn points from your receipts''',
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                )
                              : Column(
                                  key: const ValueKey<int>(1),
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      'assets/receipt_radar_mail.gif',
                                      width: 60.w,
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      '''Link your email account and accept permissions\n\nAutomatically earn points from your receipts''',
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                        ),
                        Expanded(
                            child: Center(
                          child: CarouselIndicator(
                            count: 2,
                            index: currentIndex,
                            height: 12,
                            width: 12,
                            cornerRadius: 20,
                            activeColor: Colors.black,
                            color: Colors.grey,
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
                ReceiptRadarButton(
                  text: 'Let’s go',
                  filled: false,
                  onTap: () => showModalBottomSheet(
                      context: context,
                      builder: (context) =>
                          const ReceiptRadarAuthBottomSheet()),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Your data is secured & anonymized',
                  style: TextStyle(color: Color(0xFF737373)),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your data is always anonymous and secure',
                  style: TextStyle(color: Color(0xFF737373)),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
