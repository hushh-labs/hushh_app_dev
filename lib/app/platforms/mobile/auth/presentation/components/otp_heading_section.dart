import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/auth_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/sign_up_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class OtpHeadingSection extends StatelessWidget {
  final OtpVerificationType otpVerificationType;

  const OtpHeadingSection({super.key, required this.otpVerificationType});

  @override
  Widget build(BuildContext context) {
    final authController = sl<AuthPageBloc>();
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            otpVerificationType == OtpVerificationType.phone
                ? 'Verify your phone number'
                : 'Verify your Email',
            style: context.headlineMedium
                ?.copyWith(letterSpacing: -1, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: otpVerificationType == OtpVerificationType.phone
                  ? 'We’ve sent an SMS with an activation code to your phone '
                  : authController.shouldVerifyEmail
                      ? 'We’ve sent an OTP with an activation code to your email '
                      : 'We’ve sent an SMS with an activation code to your phone ',
              style: context.bodyMedium?.inter?.copyWith(
                color: Colors.black.withOpacity(0.7),
              ),
              children: <TextSpan>[
                TextSpan(
                  text: otpVerificationType == OtpVerificationType.phone
                      ? authController.phoneNumber
                      : sl<SignUpPageBloc>()
                          .emailOrPhoneController
                          .text
                          .toLowerCase(),
                  style: context.bodyMedium?.inter?.copyWith(
                      fontWeight: FontWeight.w600, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
