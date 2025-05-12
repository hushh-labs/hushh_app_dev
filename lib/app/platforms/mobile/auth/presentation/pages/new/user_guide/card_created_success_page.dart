import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/components/hover_card.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/preference_card_list_view.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:lottie/lottie.dart';

class CardCreatedSuccessPage extends StatefulWidget {
  const CardCreatedSuccessPage({super.key});

  @override
  State<CardCreatedSuccessPage> createState() => _CardCreatedSuccessPageState();
}

class _CardCreatedSuccessPageState extends State<CardCreatedSuccessPage> {
  late ConfettiController confettiController;

  @override
  void dispose() {
    super.dispose();
    confettiController.dispose();
  }

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    confettiController =
        ConfettiController(duration: const Duration(seconds: 4));
    confettiController.play();
    Future.delayed(const Duration(seconds: 4)).then((value) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hushhIdCard =
        ModalRoute.of(context)?.settings.arguments as CardModel?;
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned.fill(
            child: Transform.scale(
              scale: 1.1,
              child: Lottie.asset('assets/sunburst.json'),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 64),
                  Text(
                    'Card Created 🎉',
                    style: context.headlineLarge?.copyWith(
                        letterSpacing: -1, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 20),
                  AspectRatio(
                    aspectRatio: 1.6,
                    child: HoverCard(
                      builder: (context, hovering) {
                        return hushhIdCard == null
                            ? Image.asset('assets/dummy-card.png')
                            : PreferenceCardWidget(
                                cardData: hushhIdCard,
                                ignore: true,
                                userName: hushhIdCard.name ?? 'dummy',
                              );
                      },
                      depth: 1,
                      depthColor: Colors.transparent,
                      shadow: const BoxShadow(
                          color: Colors.transparent,
                          blurRadius: 30,
                          spreadRadius: -20,
                          offset: Offset(0, 40)),
                    ),
                  ),
                  // HushhLinearGradientButton(
                  //   text: 'Start Now',
                  //   onTap: () => sl<SignUpPageBloc>().userGuideController.next(),
                  //   radius: 6,
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
