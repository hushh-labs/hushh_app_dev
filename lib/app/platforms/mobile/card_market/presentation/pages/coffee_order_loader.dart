// import 'package:flutter/material.dart';
// import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
// import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/card_wallet_info/card_wallet_info.dart';
// import 'package:hushh_app/app/shared/config/routes/routes.dart';
// import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
//
// class CoffeeOrderLoaderArgs {
//   String coffeeTemperature;
//   String coffeeSelection;
//   String coffeeSize;
//   String coffeeMilk;
//   String coffeeShots;
//   String coffeeTopping;
//   String coffeeFlavor;
//   CardModel cardData;
//
//   CoffeeOrderLoaderArgs({
//     required this.coffeeTemperature,
//     required this.coffeeSelection,
//     required this.coffeeSize,
//     required this.coffeeMilk,
//     required this.coffeeShots,
//     required this.coffeeTopping,
//     required this.coffeeFlavor,
//     required this.cardData,
//   });
// }
//
// class CoffeeOrderLoader extends StatefulWidget {
//   @override
//   _CoffeeOrderLoaderState createState() => _CoffeeOrderLoaderState();
// }
//
// // ignore: camel_case_types
// class _CoffeeOrderLoaderState extends State<CoffeeOrderLoader>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;
//   String userPhoneNumber = "";
//   bool loadingButton = false;
//
//   uploadData() async {
//     final args =
//         ModalRoute.of(context)!.settings.arguments as CoffeeOrderLoaderArgs;
//     await FirebaseFirestore.instance.collection("Orders").add({
//       "_id": AppLocalStorage.currentUserUid,
//       "coffeeTemperature": args.coffeeTemperature,
//       "coffeeSelection": args.coffeeSelection,
//       "coffeeSize": args.coffeeSize,
//       "coffeeMilk": args.coffeeMilk,
//       "coffeeShots": args.coffeeShots,
//       "coffeeTopping": args.coffeeTopping,
//       "coffeeFlavor": args.coffeeTopping,
//     }).then((_) {
//       Future.delayed(const Duration(seconds: 2), () {
//         Navigator.pushNamedAndRemoveUntil(
//             context, AppRoutes.cardWallet.info.main, (route) => false,
//             arguments: CardWalletInfoPageArgs(
//               cardData: args.cardData,
//             ));
//       });
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       uploadData();
//     });
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 1),
//     )..repeat(reverse: true);
//
//     _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.easeInOut,
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Image.asset(
//               "assets/sephora.gif",
//               width: 250,
//               height: 250,
//             ),
//             SizedBox(height: 50),
//             Text(
//               'You’re one step closer to having a personalized coffee experience.',
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 25),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Dot(animation: _scaleAnimation, delay: 0),
//                 Dot(animation: _scaleAnimation, delay: 0.2),
//                 Dot(animation: _scaleAnimation, delay: 0.4),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class Dot extends StatelessWidget {
//   final Animation<double> animation;
//   final double delay;
//
//   const Dot({
//     Key? key,
//     required this.animation,
//     required this.delay,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: animation,
//       builder: (context, child) {
//         return Transform.scale(
//           scale: animation.value,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 4.0),
//             child: Container(
//               width: 10,
//               height: 10,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
