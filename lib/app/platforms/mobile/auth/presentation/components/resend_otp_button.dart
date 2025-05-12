// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/auth_bloc/bloc.dart';
// import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
// import 'package:timer_count_down/timer_count_down.dart';
//
// class ResendOtpButton extends StatelessWidget {
//   const ResendOtpButton({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final authController = sl<AuthPageBloc>();
//     return BlocBuilder<AuthPageBloc, AuthPageState>(
//       bloc: authController,
//       builder: (context, state) {
//         return Center(
//           child: Padding(
//             padding: const EdgeInsets.only(bottom: 8.0),
//             child: Countdown(
//               seconds: authController.resendSeconds,
//               controller: authController.countdown,
//               build: (BuildContext context, double time) => time == 0
//                   ? InkWell(
//                       onTap: () =>
//                           authController.add(OnOtpResendEvent(context)),
//                       child: Text(
//                         "Resend Now",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xffA3A3A3),
//                           fontSize: 15,
//                         ),
//                       ),
//                     )
//                   : RichText(
//                       text: TextSpan(
//                         children: <TextSpan>[
//                           TextSpan(
//                             text: "Didn't receive?",
//                             style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               color: Color(0xffA3A3A3),
//                               fontSize: 15,
//                             ),
//                           ),
//                           TextSpan(
//                             text: ' Resend',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               color: Color(0xffA3A3A3),
//                               fontSize: 15,
//                             ),
//                           ),
//                           TextSpan(
//                             text: ' in $time seconds',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               color: Color(0xffA3A3A3),
//                               fontSize: 15,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//               interval: Duration(milliseconds: 100),
//               onFinished: () {},
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
