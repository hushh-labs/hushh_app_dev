import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/auth_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/components/social_button.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/firebase_config/firebase_remote_config_service.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class MainAuthPage extends StatefulWidget {
  const MainAuthPage({super.key});

  @override
  State<MainAuthPage> createState() => _MainAuthPageState();
}

class _MainAuthPageState extends State<MainAuthPage> {
  List<LoginMode> socialMethods = [
    LoginMode.google,
    LoginMode.phone,
  ];

  @override
  void initState() {
    super.initState();
    sl<AuthPageBloc>().add(const InitializeEvent(true));
    if (Platform.isIOS) {
      socialMethods.insert(1, LoginMode.apple);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (_) => sl<AuthPageBloc>().add(OnBackClickedEvent(context)),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  height: 75.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color(0xFFF6223C),
                        Color(0xFFA342FF),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/hushh_s_logo_v1.png',
                                color: Colors.white,
                                width: 33.w,
                                fit: BoxFit.fill,
                                height: 36.w * 1.2,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                sl<HomePageBloc>().isUserFlow?'Hushh 🤫':'Hushh Agent',
                                style: context.displaySmall?.copyWith(
                                    color: Colors.white,
                                    letterSpacing: -1,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Unlock the power of your data',
                                style: context.titleMedium?.inter?.copyWith(
                                    color: Colors.white.withOpacity(0.8),
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                            children: List.generate(
                                socialMethods.length,
                                (index) => SocialButton(
                                        loginMode: socialMethods[index])
                                    .animate(delay: (300 * index).ms)
                                    .fade(duration: 700.ms)
                                    .moveX(duration: 800.ms))),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                // Expanded(
                //   flex: 2,
                //   child: Padding(
                //     padding: const EdgeInsets.only(top: 26),
                //     child: RichText(
                //       text: TextSpan(
                //         text: 'Don’t have an account? ',
                //         style: context.bodyMedium?.inter?.copyWith(
                //           color: Colors.black.withOpacity(0.7),
                //         ),
                //         children: <TextSpan>[
                //           TextSpan(
                //             text: 'Sign up',
                //             style: context.bodyMedium?.inter?.copyWith(
                //                 fontWeight: FontWeight.w600,
                //                 color: Colors.black),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                const Spacer(),
                Text.rich(
                  TextSpan(
                      text: 'By entering information, I agree to Hushh’s ',
                      style: context.labelSmall?.inter?.copyWith(
                        color: Colors.black.withOpacity(0.7),
                      ),
                      children: <InlineSpan>[
                        TextSpan(
                          text: 'Terms of Service',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(Uri.parse(FirebaseRemoteConfigService()
                                  .termsOfService));
                            },
                          style: const TextStyle(color: Color(0xFFE54D60)),
                        ),
                        const TextSpan(
                          text: ', ',
                        ),
                        TextSpan(
                          text: 'Non-discrimination Policy',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(Uri.parse(FirebaseRemoteConfigService()
                                  .nonDisclaimerPolicy));
                            },
                          style: const TextStyle(color: Color(0xFFE54D60)),
                        ),
                        const TextSpan(
                          text: ' and ',
                        ),
                        TextSpan(
                          text: 'Payments Terms of Service',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(Uri.parse(FirebaseRemoteConfigService()
                                  .paymentTermsService));
                            },
                          style: const TextStyle(color: Color(0xFFE54D60)),
                        ),
                        const TextSpan(
                          text: ' and acknowledge the ',
                        ),
                        TextSpan(
                          text: 'Privacy Policy',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(Uri.parse(
                                  FirebaseRemoteConfigService().privacyPolicy));
                            },
                          style: const TextStyle(color: Color(0xFFE54D60)),
                        ),
                        const TextSpan(
                          text: '.',
                        ),
                      ]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
