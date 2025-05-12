import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/sign_up_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:lottie/lottie.dart';
import 'package:neopop/neopop.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CoinPage extends StatefulWidget {
  final int coins;
  final String id;

  const CoinPage({super.key, required this.coins, required this.id});

  @override
  State<CoinPage> createState() => _CoinPageState();
}

class _CoinPageState extends State<CoinPage> {
  @override
  void initState() {
    sl<SignUpPageBloc>().coinsMap[widget.id] = widget.coins;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: SvgPicture.asset('assets/hushh_coin_shape_0.svg'),
          ),
          Positioned(
            top: 0,
            child: Column(
              children: [
                SizedBox(height: 16.h),
                SvgPicture.asset('assets/hushh_coin_shape_1.svg'),
              ],
            ),
          ),
          SizedBox(
            width: 100.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset('assets/coin_anim.json'),
                SizedBox(height: 7.h)
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${widget.coins} Hushh coins earned',
                    style: context.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                      'You earned ${widget.coins} Hushh coins. Use your coins to unlock new features and send gifts.',
                      textAlign: TextAlign.center,
                      style: context.bodyLarge?.copyWith(
                        color: const Color(0xFF575757),
                      )),
                  SizedBox(height: 6.h),
                  HushhLinearGradientButton(
                    color: Colors.black,
                    onTap: () {
                      if (Platform.isIOS) {
                        HapticFeedback.lightImpact();
                      } else {
                        HapticFeedback.vibrate();
                      }
                      Navigator.pop(context);
                    },
                    height: 48,
                    radius: 12,
                    text: 'Next',
                  ),
                  SizedBox(height: 10.h)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
