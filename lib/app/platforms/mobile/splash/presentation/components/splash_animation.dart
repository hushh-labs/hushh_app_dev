// import 'package:chewie/chewie.dart';
// import 'package:flutter/material.dart';
// import 'package:hushh_app/app/platforms/mobile/splash/presentation/bloc/splash_bloc/bloc.dart';
// import 'package:hushh_app/app/shared/core/components/custom_loader.dart';
// import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
//
// class SplashAnimation extends StatefulWidget {
//   const SplashAnimation({super.key});
//
//   @override
//   State<SplashAnimation> createState() => _SplashAnimationState();
// }
//
// class _SplashAnimationState extends State<SplashAnimation> {
//   final controller = sl<SplashPageBloc>();
//
//   get player => controller.player?.videoPlayerController.value;
//
//   @override
//   Widget build(BuildContext context) {
//     return player != null
//         ? AspectRatio(
//             aspectRatio: player.aspectRatio,
//             child: Chewie(
//               controller: controller.player!,
//             ))
//         : CustomLoader();
//   }
// }
