import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/auth_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/components/otp_heading_section.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/components/otp_text_field.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OtpVerificationPageArgs {
  final Function()? onVerifyFunc;
  final OtpVerificationType type;

  OtpVerificationPageArgs({this.onVerifyFunc, required this.type});
}

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage();

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final authController = sl<AuthPageBloc>();
  int countDownForResendStartValue = 60;
  late Timer countDownForResend;
  bool resendValidation = false;

  void countDownForResendFunction() {
    //permission();
    const oneSec = Duration(seconds: 1);
    countDownForResend = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (countDownForResendStartValue == 0) {
          setState(() {
            timer.cancel();
            resendValidation = true;
            countDownForResendStartValue = 60;
          });
        } else {
          setState(() {
            countDownForResendStartValue--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    authController.otpController.clear();
    authController.countdown.start();
    countDownForResendFunction();
    SmsAutoFill().code.listen((event) {
      authController.otpController.text = event;
      setState(() {});
    });
    SmsAutoFill().listenForCode();

    //authController.add(CountDownForResendFunction());
    super.initState();
  }

  @override
  void dispose() {
    authController.countdown.pause();
    countDownForResend.cancel();
    //authController.countDownForResend.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as OtpVerificationPageArgs;
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: const OtpVerificationAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 100.w,
            height: 100.h - kToolbarHeight,
            child: Padding(
              padding: const EdgeInsets.all(20.0).copyWith(top: 12),
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
                              border:
                                  Border.all(color: const Color(0xFFD8DADC))),
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
                  const SizedBox(height: 26 * 3),
                  OtpHeadingSection(
                    otpVerificationType: args.type,
                  ),
                  const Expanded(child: SizedBox()),
                  Expanded(
                    flex: 10,
                    child: OtpTextField(
                      controller: authController.otpController,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5.h),
                      InkWell(
                        onTap: () => authController.add(OnVerifyEvent(
                            authController.otpController.text, context,
                            onVerify: args.onVerifyFunc, type: args.type)),
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [
                              Color(0XFFA342FF),
                              Color(0XFFE54D60),
                            ]),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: BlocBuilder(
                              bloc: authController,
                              builder: (context, state) {
                                return Center(
                                  child: state is PhoneVerifyingState
                                      ? const Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 3,
                                            ),
                                          ),
                                        )
                                      : const Text(
                                          "Verify",
                                          style: TextStyle(
                                              color: Color(0xffFFFFFF),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      if (countDownForResendStartValue.toString() == "60") {
                        countDownForResendFunction();
                        authController.add(OnOtpResendEvent(context,
                            otpVerificationType: args.type));
                      }
                    },
                    child: countDownForResendStartValue.toString().length == 1
                        ? RichText(
                            text: TextSpan(
                              style: context.bodyMedium?.inter?.copyWith(
                                color: Colors.black.withOpacity(0.7),
                              ),
                              children: <TextSpan>[
                                const TextSpan(
                                  text: "Didn't receive?",
                                ),
                                TextSpan(
                                  text: ' Resend',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: countDownForResendStartValue
                                                .toString() ==
                                            "60"
                                        ? TextDecoration.underline
                                        : null,
                                    color: countDownForResendStartValue
                                                .toString() ==
                                            "60"
                                        ? Colors.black
                                        : const Color(0xffA3A3A3),
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      ' in 0$countDownForResendStartValue seconds',
                                ),
                              ],
                            ),
                          )
                        : RichText(
                            text: TextSpan(
                              style: context.bodyMedium?.inter?.copyWith(
                                color: Colors.black.withOpacity(0.7),
                              ),
                              children: <TextSpan>[
                                const TextSpan(
                                  text: "Didn't receive? ",
                                ),
                                TextSpan(
                                  text: 'Resend',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: countDownForResendStartValue
                                                .toString() ==
                                            "60"
                                        ? TextDecoration.underline
                                        : null,
                                    color: countDownForResendStartValue
                                                .toString() ==
                                            "60"
                                        ? Colors.black
                                        : const Color(0xffA3A3A3),
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      ' in $countDownForResendStartValue seconds',
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// @override
// void codeUpdated() {
//   print("code received");
//   authController.otpController.text = code!;
//   setState(() {});
// }
}
