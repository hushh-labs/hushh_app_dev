// import 'package:flutter/material.dart';
// import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/notifications_bloc/bloc.dart';
// import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';
// import 'package:hushh_app/app/shared/core/components/hushh_secondary_button.dart';
// import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
// import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
//
// class SharedPreferenceQA {
//   final String question;
//   final String answer;
//   final String content;
//
//   SharedPreferenceQA(this.question, this.answer, this.content);
// }
//
// class RequestUserDataAccessBottomSheet extends StatefulWidget {
//   final CustomNotification notification;
//
//   const RequestUserDataAccessBottomSheet(
//       {super.key, required this.notification});
//
//   @override
//   State<RequestUserDataAccessBottomSheet> createState() =>
//       _RequestUserDataAccessBottomSheetState();
// }
//
// class _RequestUserDataAccessBottomSheetState
//     extends State<RequestUserDataAccessBottomSheet> {
//   String get brandName => widget.notification.payload?['brand_name'] ?? 'N/A';
//
//   String get cardName => widget.notification.payload?['card_name'] ?? 'N/A';
//
//   String get brandLogo =>
//       widget.notification.payload?['brand_card_logo'] ?? 'N/A';
//
//   String get bidValue =>
//       widget.notification.payload?['bid_value']?.toString() ?? 'N/A';
//
//   String get expiryDate => widget.notification.payload?['expiry_date'] ?? 'N/A';
//
//   String get desc => widget.notification.payload?['incentive'] ?? 'N/A';
//
//   String get dataSummary => widget.notification.payload?['purpose'] ?? 'N/A';
//
//   String? get requestId =>
//       widget.notification.payload?['request_id']?.toString();
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).viewInsets.bottom,
//       ),
//       child: SingleChildScrollView(
//         child: Container(
//           width: double.infinity,
//           margin: const EdgeInsets.all(24),
//           padding: const EdgeInsets.all(16),
//           decoration: const BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.all(Radius.circular(15))),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               CircleAvatar(
//                 radius: 41,
//                 backgroundColor: Colors.black,
//                 child: CircleAvatar(
//                   radius: 40,
//                   backgroundImage: NetworkImage(brandLogo),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 'hi! $brandName is Requesting your $cardName card',
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.monetization_on, color: Colors.amber),
//                   const SizedBox(width: 4),
//                   Text('$bidValue Hushh Coins'),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 desc,
//                 style: const TextStyle(fontSize: 14, color: Colors.black54),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 16),
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.orange[100]?.withOpacity(0.6),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       '💡 What we will be collecting',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       dataSummary,
//                       style:
//                           const TextStyle(fontSize: 14, color: Colors.black54),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 children: [
//                   _infoCard('Expiry Date', expiryDate, Colors.pink[100]!),
//                   const SizedBox(width: 16),
//                   _infoCard('Card Name', cardName, Colors.blue[100]!),
//                 ],
//               ),
//               if (requestId != null) ...[
//                 const SizedBox(height: 20),
//                 HushhLinearGradientButton(
//                   text: 'Accept',
//                   color: Colors.black,
//                   height: 42,
//                   onTap: () {
//                     sl<NotificationsBloc>().add(AcceptDataConsentRequestEvent(
//                       requestId!,
//                       context,
//                     ));
//                   },
//                   radius: 6,
//                 ),
//                 const SizedBox(height: 10),
//                 HushhSecondaryButton(
//                   text: 'Reject',
//                   height: 42,
//                   onTap: () {},
//                   radius: 6,
//                 ),
//               ]
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _infoCard(String title, String value, Color bgColor) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: bgColor.withOpacity(0.5),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         width: 130,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 14,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 14,
//                 color: Colors.black54,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
