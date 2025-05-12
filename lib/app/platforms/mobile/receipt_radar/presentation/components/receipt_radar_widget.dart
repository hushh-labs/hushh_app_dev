// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
// import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/receipt_radar/receipt_radar_dashboard.dart';
// import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/receipt_radar/receipt_radar_onboarding.dart';
// import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/receipt_radar/receipt_radar_utils.dart';
//
// class ReceiptRadarWidget extends StatefulWidget {
//   final BrandCardDatumFullData cardData;
//
//   const ReceiptRadarWidget({super.key, required this.cardData});
//
//   @override
//   State<ReceiptRadarWidget> createState() => _ReceiptRadarWidgetState();
// }
//
// class _ReceiptRadarWidgetState extends State<ReceiptRadarWidget> {
//   bool get isReceiptsInLocalStorage =>
//       (Hive.box('hushh_receipts').get(widget.cardData.id) ?? []).isEmpty;
//
//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;
//     return Material(
//       elevation: 6,
//       borderRadius: BorderRadius.circular(11),
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 8, vertical: 22),
//         decoration: ShapeDecoration(
//           color: Color(0xFFF2F2F2),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(11),
//           ),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//                 child: Padding(
//               padding: EdgeInsets.all(!isReceiptsInLocalStorage ? 0 : 20.0),
//               child: Image.asset(
//                 'assets/recipt.gif',
//                 fit: BoxFit.cover,
//               ),
//             )),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ShaderMask(
//                   blendMode: BlendMode.srcIn,
//                   shaderCallback: (bounds) => LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           colors: [Color(0xFFE54D60), Color(0xFFA342FF)])
//                       .createShader(
//                     Rect.fromLTWH(0, 0, bounds.width, bounds.height),
//                   ),
//                   child: Text(
//                     'receipt radar'.toUpperCase(),
//                     style: textTheme.titleSmall?.copyWith(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   'turn your receipts\ninto rewards',
//                   style: textTheme.titleSmall?.copyWith(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 8,
//                 ),
//                 Text(
//                   'convert your data into coins!',
//                   style: textTheme.titleSmall?.copyWith(
//                       fontWeight: FontWeight.bold, color: Colors.grey),
//                 ),
//                 SizedBox(
//                   height: 22,
//                 ),
//                 Row(
//                   children: [
//                     InkWell(
//                       onTap: () async {
//                         Get.to(() => ReceiptRadarOnboarding(
//                               cardData: widget.cardData,
//                             ))?.then((value) {
//                           if (mounted) setState(() {});
//                         });
//                       },
//                       child: Container(
//                         height: 45,
//                         padding: const EdgeInsets.symmetric(horizontal: 20),
//                         decoration: ShapeDecoration(
//                           color: Color(0xFF6257ee),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                         ),
//                         child: Center(
//                           child: Text(
//                             'Start Convert',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 13,
//                               fontFamily: 'Figtree',
//                               fontWeight: FontWeight.w700,
//                               height: 1,
//                               letterSpacing: 0.20,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     if (!isReceiptsInLocalStorage) ...[
//                       SizedBox(width: 8),
//                       InkWell(
//                         onTap: () async {
//                           final receipts =
//                               await ReceiptRadarUtils.fetchReceiptsLocal(
//                                   widget.cardData.id);
//                           Get.to(() => ReceiptRadarDashboard(
//                                 cardData: widget.cardData,
//                                 receipts: receipts,
//                               ));
//                         },
//                         child: Container(
//                           height: 45,
//                           padding: const EdgeInsets.symmetric(horizontal: 20),
//                           decoration: ShapeDecoration(
//                             color: Color(0xFF6257ee),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                           ),
//                           child: Center(
//                             child: Text(
//                               'Dashboard',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 13,
//                                 fontFamily: 'Figtree',
//                                 fontWeight: FontWeight.w700,
//                                 height: 1,
//                                 letterSpacing: 0.20,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ]
//                   ],
//                 )
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
