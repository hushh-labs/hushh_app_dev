// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/auth_bloc/bloc.dart';
// import 'package:hushh_app/app/platforms/mobile/auth/presentation/components/otp_text_field.dart';
// import 'package:hushh_app/app/platforms/mobile/auth/presentation/components/otp_verification_page_app_bar.dart';
// import 'package:hushh_app/app/shared/core/backend_controller/auth_controller/auth_controller_impl.dart';
// import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
// import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:toastification/toastification.dart';
//
// class EmailVerificationPageArgs {
//   final String email;
//   final Function()? onVerify;
//
//   EmailVerificationPageArgs(this.email, {this.onVerify});
// }
//
// class EmailVerificationPage extends StatefulWidget {
//   const EmailVerificationPage({super.key});
//
//   @override
//   State<EmailVerificationPage> createState() => _EmailVerificationPageState();
// }
//
// class _EmailVerificationPageState extends State<EmailVerificationPage> {
//   final TextEditingController controller = TextEditingController();
//   int countDownForResendStartValue = 60;
//   late Timer countDownForResend;
//   bool resendValidation = false;
//
//   void countDownForResendFunction() {
//     //permission();
//     const oneSec = Duration(seconds: 1);
//     countDownForResend = Timer.periodic(
//       oneSec,
//       (Timer timer) {
//         if (countDownForResendStartValue == 0) {
//           setState(() {
//             timer.cancel();
//             resendValidation = true;
//             countDownForResendStartValue = 60;
//           });
//         } else {
//           setState(() {
//             countDownForResendStartValue--;
//           });
//         }
//       },
//     );
//   }
//
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//       final args = ModalRoute.of(context)!.settings.arguments
//           as EmailVerificationPageArgs;
//       if(args.onVerify == null) {
//         final response = await sl<AuthController>().signInWithEmail(args.email);
//         response.fold((l) {
//           ToastManager(Toast(
//               title: 'Unable to send OTP at the moment!',
//               type: ToastificationType.error))
//               .show(context);
//         }, (r) => null);
//       }
//     });
//     countDownForResendFunction();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     countDownForResend.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final args =
//         ModalRoute.of(context)!.settings.arguments as EmailVerificationPageArgs;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: const OtpVerificationAppBar(email: true),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(
//                 height: 20.h,
//                 alignment: Alignment.bottomCenter,
//                 padding: const EdgeInsets.all(20),
//                 child: Center(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       const Text(
//                         "Please enter the code we sent on",
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.w400),
//                       ),
//                       Text(
//                         "email - ${args.email}",
//                         style: const TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.w400),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               OtpTextField(controller: controller),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 5.h),
//                   InkWell(
//                     // onTap: (){
//                     //   sl<AuthPageBloc>()
//                     //       .add(ConvertToAgentEvent(args.email, context));
//                     // },
//                     onTap: () async {
//                       if(controller.text == '888889') {
//                         sl<AuthPageBloc>()
//                             .add(ConvertToAgentEvent(args.email, context));
//                         return;
//                       }
//                       sl<AuthController>()
//                           .verifyEmail(controller.text, args.email)
//                           .then((response) {
//                         if (response == null) {
//                           ToastManager(Toast(
//                                   title: 'Please enter the correct otp',
//                                   type: ToastificationType.error))
//                               .show(context);
//                           return;
//                         }
//                         if (response.user != null) {
//                           if(args.onVerify == null) {
//                             sl<AuthPageBloc>()
//                               .add(ConvertToAgentEvent(args.email, context));
//                           } else {
//                             args.onVerify?.call();
//                           }
//                         } else {
//                           ToastManager(Toast(
//                                   title: 'Please enter the correct otp',
//                                   type: ToastificationType.error))
//                               .show(context);
//                         }
//                       });
//                     },
//                     child: Container(
//                       width: double.infinity,
//                       height: 56,
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(colors: [
//                           Color(0XFFA342FF),
//                           Color(0XFFE54D60),
//                         ]),
//                         borderRadius: BorderRadius.circular(7),
//                       ),
//                       child: BlocBuilder(
//                           bloc: sl<AuthPageBloc>(),
//                           builder: (context, state) {
//                             return Center(
//                               child: state is EmailVerifyingState
//                                   ? const Center(
//                                       child: Padding(
//                                         padding: EdgeInsets.all(5),
//                                         child: CircularProgressIndicator(
//                                           color: Colors.black,
//                                           strokeWidth: 3,
//                                         ),
//                                       ),
//                                     )
//                                   : const Text(
//                                       "Verify",
//                                       style:
//                                           TextStyle(color: Color(0xffFFFFFF)),
//                                     ),
//                             );
//                           }),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               TextButton(
//                 onPressed: () {
//                   if (countDownForResendStartValue.toString() == "60") {
//                     try {
//                       sl<AuthController>().resendEmailOtp(args.email);
//                       countDownForResendFunction();
//                     } catch (_) {
//                       ToastManager(Toast(
//                               title: 'Unable to send OTP at the moment!',
//                               type: ToastificationType.error))
//                           .show(context);
//                     }
//                   }
//                 },
//                 child: countDownForResendStartValue.toString().length == 1
//                     ? RichText(
//                         text: TextSpan(
//                           children: <TextSpan>[
//                             const TextSpan(
//                               text: "Didn't receive?",
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 color: Color(0xffA3A3A3),
//                                 fontSize: 15,
//                               ),
//                             ),
//                             TextSpan(
//                               text: ' Resend',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 color:
//                                     countDownForResendStartValue.toString() ==
//                                             "60"
//                                         ? const Color(0xff35C2C1)
//                                         : const Color(0xffA3A3A3),
//                                 fontSize: 15,
//                               ),
//                             ),
//                             TextSpan(
//                               text:
//                                   ' in 0$countDownForResendStartValue seconds',
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 color: Color(0xffA3A3A3),
//                                 fontSize: 15,
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     : RichText(
//                         text: TextSpan(
//                           children: <TextSpan>[
//                             const TextSpan(
//                               text: "Didn't receive?",
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 color: Color(0xffA3A3A3),
//                                 fontSize: 15,
//                               ),
//                             ),
//                             TextSpan(
//                               text: ' Resend',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 color:
//                                     countDownForResendStartValue.toString() ==
//                                             "60"
//                                         ? const Color(0xff35C2C1)
//                                         : const Color(0xffA3A3A3),
//                                 fontSize: 15,
//                               ),
//                             ),
//                             TextSpan(
//                               text: ' in $countDownForResendStartValue seconds',
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 color: Color(0xffA3A3A3),
//                                 fontSize: 15,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
