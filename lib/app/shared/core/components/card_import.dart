// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
// import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
//
// class CardImportPage extends StatefulWidget {
//   final String uid;
//   final int cardId;
//
//   const CardImportPage({super.key, required this.uid, required this.cardId});
//
//   @override
//   State<CardImportPage> createState() => _CardImportPageState();
// }
//
// class _CardImportPageState extends State<CardImportPage> {
//   @override
//   void initState() {
//     sl<CardWalletPageBloc>().add(FetchUpdatedAccessListEvent(
//         queryParams['uid'] ?? '', brandIdAsInt, context));
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text('Importing'),
//             SizedBox(width: 4),
//             CupertinoActivityIndicator()
//           ],
//         ),
//       ),
//     );
//   }
// }
