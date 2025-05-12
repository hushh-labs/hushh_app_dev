// import 'package:flutter/material.dart';
// import 'package:hushh_app/app/platforms/mobile/splash/presentation/bloc/splash_bloc/bloc.dart';
// import 'package:hushh_app/app/shared/config/routes/routes.dart';
// import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
// import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
//
// class AnimatedContinueButton extends StatelessWidget {
//   const AnimatedContinueButton({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = sl<SplashPageBloc>();
//     return AnimatedContainer(
//       height: controller.visibility,
//       duration: const Duration(seconds: 2),
//       curve: Curves.fastOutSlowIn,
//       child: Column(
//         children: [
//           InkWell(
//             onTap: () {
//               Navigator.pushNamed(context, AppRoutes.userSignUp);
//             },
//             child: AppLocalStorage.isUserLoggedIn
//                 ? SizedBox()
//                 : Container(
//                     width: double.infinity,
//                     height: 48,
//                     margin: EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(colors: const [
//                         Color(0XFFA342FF),
//                         Color(0XFFE54D60),
//                       ]),
//                       borderRadius: BorderRadius.circular(7),
//                     ),
//                     child: Center(
//                       child: Text(
//                         "Continue",
//                         style: TextStyle(
//                             color: Color(0xffFFFFFF),
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16),
//                       ),
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }
