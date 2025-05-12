// import 'package:flutter/material.dart';
// import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
// import 'package:hushh_app/app/shared/config/routes/routes.dart';
// import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
//
// class PlaceCoffeeButton extends StatelessWidget {
//   const PlaceCoffeeButton({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final cardData = sl<CardWalletPageBloc>().cardData!;
//     return cardData.category == "Coffee - Personal"
//         ? Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16).copyWith(top: 20),
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.pushNamed(
//                     context, AppRoutes.cardMarketPlace.coffeeQuestionnaire,
//                     arguments: cardData);
//               },
//               child: Container(
//                 width: double.infinity,
//                 height: 45,
//                 padding: EdgeInsets.symmetric(horizontal: 20),
//                 decoration: ShapeDecoration(
//                   color: Color(0xFF6f4e37),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Icon(Icons.coffee, color: Colors.white),
//                     SizedBox(width: 8),
//                     Text(
//                       'Place a coffee order',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 13,
//                         fontFamily: 'Figtree',
//                         fontWeight: FontWeight.w700,
//                         height: 0.09,
//                         letterSpacing: 0.20,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           )
//         : SizedBox();
//   }
// }
