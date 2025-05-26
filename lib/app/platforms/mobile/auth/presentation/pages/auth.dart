// app/platforms/mobile/auth/presentation/pages/auth.dart
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/auth_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/components/country_code_text_field.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/components/or_separator_widget.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/components/phone_number_text_field.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/components/sign_in_with_apple_button.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/components/sign_in_with_google_button.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/components/sign_in_with_phone_button.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:sms_autofill/sms_autofill.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // SmsAutoFill().hint.then((value) {
    //   print(value);
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 70.h,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFD8DADC))),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_back_ios_new_sharp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SvgPicture.asset('assets/star-icon.svg')
              ],
            ),
            const SizedBox(height: 26),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Log in to your account',
                style: context.headlineMedium
                    ?.copyWith(letterSpacing: -1, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Welcome! Please enter your phone number. We\'ll send you an OTP to verify.',
                style: context.bodyMedium?.inter?.copyWith(
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
            ),
            const SizedBox(height: 26),
            const CountryCodeTextField(),
            const SizedBox(height: 8),
            const PhoneNumberTextField(),
            const Spacer(),
            const SignInWithPhoneButton(),
            // SizedBox(height: 16),
            // const OrSeparatorWidget(),
            // SizedBox(height: 16),
            // Row(
            //   children: [
            //     if (Platform.isIOS) const SignInWithAppleButton(),
            //     const SignInWithGoogleButton(),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
