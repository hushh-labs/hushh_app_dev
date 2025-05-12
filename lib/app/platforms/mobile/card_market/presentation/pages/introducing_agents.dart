// import 'package:confetti/confetti.dart';
// import 'package:flutter/material.dart';
// import 'package:hushh_app/app/platforms/mobile/card_market/presentation/pages/card_loader_screen.dart';
// import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
// import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
// import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/upload_your_vibe_bottom_sheet.dart';
// import 'package:hushh_app/app/shared/config/routes/routes.dart';
// import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
//
// class IntroducingAssetsArgs {
//   final CardModel cardData;
//   final List<Map> userSelections;
//   final String coins;
//   final String? audioValue;
//   String cardCoins;
//
//   // String coins;
//   IntroducingAssetsArgs(
//       {required this.cardData,
//       required this.coins,
//       this.audioValue,
//       required this.cardCoins,
//       required this.userSelections});
// }
//
// class IntroducingAssetsPage extends StatefulWidget {
//   const IntroducingAssetsPage();
//
//   @override
//   State<IntroducingAssetsPage> createState() => _IntroducingAssetsPageState();
// }
//
// class _IntroducingAssetsPageState extends State<IntroducingAssetsPage> {
//   bool uploadAssetLoading = false;
//   late ConfettiController _controllerCenterRight;
//
//   void dispose() {
//     _controllerCenterRight.dispose();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     _controllerCenterRight =
//         ConfettiController(duration: const Duration(seconds: 1));
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final args =
//         ModalRoute.of(context)!.settings.arguments as IntroducingAssetsArgs;
//     final cardData = args.cardData;
//     final userSelections = args.userSelections;
//     final coins = args.coins;
//     final cardCoins = args.cardCoins;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         elevation: 0,
//         backgroundColor: Colors.white,
//         leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: Container(
//                 width: 40,
//                 height: 40,
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(color: Colors.grey)),
//                 child: const Center(
//                     child: Icon(
//                   Icons.arrow_back_ios_new_sharp,
//                   color: Colors.black,
//                 )))),
//         title: const Padding(
//           padding: EdgeInsets.only(top: 15.0),
//           // Adjust the top padding as needed
//           child: Text(
//             'Introducing Assets',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: 20,
//               fontFamily: 'Figtree',
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 14),
//               const SizedBox(
//                 width: 327,
//                 child: Text(
//                   'Help us understand your vibe and style by uploading photos that resonate your style.',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Color(0xFF363636),
//                     fontSize: 16,
//                     fontFamily: 'Figtree',
//                     fontWeight: FontWeight.w500,
//                     height: 1,
//                     letterSpacing: -0.64,
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 37,
//               ),
//               Container(
//                 width: 362.5,
//                 height: 196,
//                 padding: const EdgeInsets.only(left: 16, right: 16),
//                 clipBehavior: Clip.antiAlias,
//                 decoration: ShapeDecoration(
//                   color: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     side: const BorderSide(
//                       width: 0.50,
//                       strokeAlign: BorderSide.strokeAlignCenter,
//                       color: Color(0xFFD9D9D9),
//                     ),
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   shadows: const [
//                     BoxShadow(
//                       color: Color(0x338C8C8C),
//                       blurRadius: 60,
//                       offset: Offset(0, 4),
//                       spreadRadius: 0,
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     // First Row
//                     const SizedBox(height: 16),
//                     Row(
//                       children: [
//                         // First Column
//                         Column(
//                           mainAxisSize: MainAxisSize.min,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               width: 78,
//                               height: 78,
//                               decoration: ShapeDecoration(
//                                 image: const DecorationImage(
//                                   image:
//                                       AssetImage('assets/Rectangle 6943.png'),
//                                   fit: BoxFit.fill,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(4),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(width: 6),
//                         Column(
//                           mainAxisSize: MainAxisSize.min,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               width: 78,
//                               height: 78,
//                               decoration: ShapeDecoration(
//                                 image: const DecorationImage(
//                                   image:
//                                       AssetImage('assets/Rectangle 6944.png'),
//                                   fit: BoxFit.fill,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(4),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(width: 6),
//                         Column(
//                           mainAxisSize: MainAxisSize.min,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               width: 78,
//                               height: 78,
//                               decoration: ShapeDecoration(
//                                 image: const DecorationImage(
//                                   image:
//                                       AssetImage('assets/Rectangle 6945.png'),
//                                   fit: BoxFit.fill,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(4),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(width: 6),
//                         Column(
//                           mainAxisSize: MainAxisSize.min,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               width: 78,
//                               height: 78,
//                               decoration: ShapeDecoration(
//                                 image: const DecorationImage(
//                                   image:
//                                       AssetImage('assets/Rectangle 6946.png'),
//                                   fit: BoxFit.fill,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(4),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         // ... (previous columns)
//                       ],
//                     ),
//                     const SizedBox(height: 10), // Add spacing between rows
//                     // Second Row (From your previous code)
//                     Row(
//                       children: [
//                         // First column in the second row
//                         Column(
//                           mainAxisSize: MainAxisSize.min,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               width: 78,
//                               height: 78,
//                               decoration: ShapeDecoration(
//                                 image: const DecorationImage(
//                                   image:
//                                       AssetImage('assets/Rectangle 6947.png'),
//                                   fit: BoxFit.fill,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(4),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(width: 6),
//                         Column(
//                           mainAxisSize: MainAxisSize.min,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               width: 78,
//                               height: 78,
//                               decoration: ShapeDecoration(
//                                 image: const DecorationImage(
//                                   image:
//                                       AssetImage('assets/Rectangle 6948.png'),
//                                   fit: BoxFit.fill,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(4),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(width: 6),
//                         Column(
//                           mainAxisSize: MainAxisSize.min,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               width: 78,
//                               height: 78,
//                               decoration: ShapeDecoration(
//                                 image: const DecorationImage(
//                                   image:
//                                       AssetImage('assets/Rectangle 6949.png'),
//                                   fit: BoxFit.fill,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(4),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(width: 6),
//                         Column(
//                           mainAxisSize: MainAxisSize.min,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               width: 78,
//                               height: 78,
//                               decoration: ShapeDecoration(
//                                 image: const DecorationImage(
//                                   image:
//                                       AssetImage('assets/Rectangle 6950.png'),
//                                   fit: BoxFit.fill,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(4),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 16),
//               const SizedBox(
//                 width: 300.54,
//                 child: Text(
//                   'Your wallet value is \$200, you can increase it upto \$250 by uploading assets',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Color(0xFF118CFD),
//                     fontSize: 14,
//                     fontFamily: 'Figtree',
//                     fontWeight: FontWeight.w500,
//                     height: 0,
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 168,
//               ),
//               InkWell(
//                 onTap: () {
//                   // Get.to(() => CardLoaderScreen(
//                   //       cardData: cardData,
//                   //       coins: coins,
//                   //       userSelections: userSelections,
//                   //     ));
//                 },
//                 child: Container(
//                   width: 327.30,
//                   height: 48.63,
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 14.96, vertical: 13.09),
//                   clipBehavior: Clip.antiAlias,
//                   decoration: ShapeDecoration(
//                     gradient: const LinearGradient(
//                       begin: Alignment(-1.00, 0.05),
//                       end: Alignment(1, -0.05),
//                       colors: [Color(0xFFE54D60), Color(0xFFA342FF)],
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(67),
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       InkWell(
//                         onTap: () async {
//                           sl<CardWalletPageBloc>().cardData = cardData;
//                           showModalBottomSheet(
//                             isDismissible: true,
//                             enableDrag: true,
//                             // constraints: BoxConstraints(maxHeight: 49.h),
//                             backgroundColor: Colors.transparent,
//                             context: context,
//                             builder: (_context) {
//                               return UploadYourVibeBottomSheet(
//                                 cardData: cardData,
//                                 context: context,
//                               );
//                             },
//                           );
//                         },
//                         child: Container(
//                           width: 200,
//                           height: 45,
//                           padding: const EdgeInsets.symmetric(horizontal: 20),
//                           decoration: ShapeDecoration(
//                             //color: Color(0xFFF6F6F6),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(5)),
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               uploadAssetLoading
//                                   ? Container(
//                                       width: 25,
//                                       height: 25,
//                                       child: const CircularProgressIndicator(
//                                         color: Colors.white,
//                                       ),
//                                     )
//                                   : const Text(
//                                       'Upload Assets',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 13,
//                                         fontFamily: 'Figtree',
//                                         fontWeight: FontWeight.w700,
//                                         height: 1,
//                                         letterSpacing: 0.20,
//                                       ),
//                                     ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 16,
//               ),
//               InkWell(
//                 onTap: () {
//                   Navigator.pushNamed(
//                       context, AppRoutes.cardMarketPlace.cardLoader,
//                       arguments: CardLoaderScreenArgs(
//                           cardData: cardData,
//                           coins: coins,
//                           cardCoins: cardCoins,
//                           audioValue: args.audioValue,
//                           userSelections: userSelections));
//                 },
//                 child: Container(
//                   width: 327.30,
//                   height: 48.63,
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 14.96, vertical: 13.09),
//                   clipBehavior: Clip.antiAlias,
//                   decoration: ShapeDecoration(
//                     color: const Color(0xFFF6F6F6),
//                     shape: RoundedRectangleBorder(
//                       side:
//                           const BorderSide(width: 1, color: Color(0xFFE54D60)),
//                       borderRadius: BorderRadius.circular(67),
//                     ),
//                   ),
//                   child: const Row(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         'Skip For Now',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: Color(0xFFE54D60),
//                           fontSize: 14,
//                           fontFamily: 'Figtree',
//                           fontWeight: FontWeight.w700,
//                           height: 1,
//                           letterSpacing: 0.20,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
