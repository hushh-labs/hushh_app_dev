// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
// import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/plaid_bloc/bloc.dart';
// import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/card_questions_list_view.dart';
// import 'package:hushh_app/app/shared/core/components/gradient_text.dart';
// import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
// import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:lottie/lottie.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:toastification/toastification.dart';
//
// extension StringCasingExtension on String {
//   String toCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
//
//   String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
// }
//
// class FinanceCardData extends StatefulWidget {
//   FinanceCardData({Key? key}) : super(key: key);
//
//   @override
//   State<FinanceCardData> createState() => _FinanceCardDataState();
// }
//
// class _FinanceCardDataState extends State<FinanceCardData> {
//   final controller = sl<PlaidBloc>();
//   AudioPlayer audioPlayerLoader = AudioPlayer();
//
//   @override
//   void initState() {
//     controller.add(FetchFinanceCardInfoEvent());
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder(
//       bloc: controller,
//       builder: (context, state) {
//         if (state is FetchingFinanceCardState) {
//           return const Center(child: CircularProgressIndicator.adaptive());
//         } else if (state is SuccessFinanceCardState) {
//           return Column(
//             children: [
//               const CardQuestionsListView(),
//               const SizedBox(
//                 height: 20,
//               ),
//               controller.instituteName!.isEmpty || controller.instituteName == null
//                   ? Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         SizedBox(
//                           width: 100.w,
//                           height: 25.h,
//                           child: Lottie.asset("assets/financeload.json"),
//                         ),
//                         const Text(
//                           "We are fetching your finance data in background.\nPlease come back later to view.",
//                           textAlign: TextAlign.center,
//                         ),
//                         SizedBox(
//                           height: 10.h,
//                         )
//                       ],
//                     )
//                   : controller.showFinanceLoader
//                       ? Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             SizedBox(
//                               width: 100.w,
//                               height: 25.h,
//                               child: Lottie.asset("assets/financeload.json"),
//                             ),
//                             const Text(
//                               "We are fetching your finance data in background.\nPlease come back later to view.",
//                               textAlign: TextAlign.center,
//                             ),
//                             SizedBox(
//                               height: 10.h,
//                             )
//                           ],
//                         )
//                       : Column(
//                           children: [
//                             Container(
//                               height: 50,
//                               width: 100.w,
//                               decoration: const BoxDecoration(
//                                 gradient: LinearGradient(
//                                   begin: Alignment(-1.00, 0.05),
//                                   end: Alignment(1, -0.05),
//                                   colors: [
//                                     Color(0xFFA342FF),
//                                     Color(0xFFE54D60),
//                                   ],
//                                 ),
//                               ),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.only(left: 15.0),
//                                     child: Row(
//                                       children: [
//                                         Text(
//                                           "${controller.instituteName} Institution",
//                                           style: const TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.w700,
//                                             fontSize: 14,
//                                           ),
//                                         ),
//                                         const Icon(
//                                           Icons.keyboard_arrow_down_sharp,
//                                           color: Colors.white,
//                                           size: 30,
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                   InkWell(
//                                     onTap: () =>
//                                         ToastManager(Toast(title: 'Adding multiple accounts coming soon!', type: ToastificationType.info))
//                                             .show(context),
//                                     child: const Padding(
//                                       padding: EdgeInsets.only(right: 15.0),
//                                       child: Text(
//                                         "ADD ACCOUNT",
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.w700,
//                                           decoration: TextDecoration.underline,
//                                           decorationColor: Colors.white,
//                                           fontSize: 13,
//                                         ),
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 30,
//                             ),
//                             Container(
//                               width: 100.w,
//                               height: 10.h,
//                               padding: const EdgeInsets.symmetric(horizontal: 20),
//                               child: ListView.builder(
//                                 itemCount: controller.transactionBalance != null ? controller.transactionBalance.length : 0,
//                                 scrollDirection: Axis.horizontal,
//                                 physics: const NeverScrollableScrollPhysics(),
//                                 shrinkWrap: true,
//                                 itemBuilder: (BuildContext context, int index) {
//                                   return Container(
//                                     width: 44.w,
//                                     height: 8.h,
//                                     margin: const EdgeInsets.only(right: 10),
//                                     decoration: BoxDecoration(
//                                       color: index == 0 ? const Color(0xff304FFF) : const Color(0xffFED835),
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children: [
//                                         Text(
//                                           "${controller.transactionBalance[index]['subtype']} balance".toTitleCase(),
//                                           style: TextStyle(
//                                             textBaseline: TextBaseline.alphabetic,
//                                             color: index == 0 ? Colors.white : Colors.black,
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                         Text(
//                                           "\$ ${controller.transactionBalance[index]['balances']['available']}",
//                                           style: TextStyle(
//                                             textBaseline: TextBaseline.alphabetic,
//                                             color: index == 0 ? Colors.white : Colors.black,
//                                             fontSize: 24,
//                                             fontWeight: FontWeight.w700,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 30,
//                             ),
//                             const Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 20),
//                               child: Row(
//                                 children: [
//                                   GradientText(
//                                     'TOP CATEGORIES',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.w700,
//                                       fontSize: 15,
//                                     ),
//                                     gradient: LinearGradient(colors: [
//                                       Color(0xFFA342FF),
//                                       Color(0xFFE54D60),
//                                     ]),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             ListView.builder(
//                                 shrinkWrap: true,
//                                 physics: const NeverScrollableScrollPhysics(),
//                                 itemCount: controller.categories.length,
//                                 itemBuilder: (BuildContext context, int index) {
//                                   return Container(
//                                     padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                                     child: Column(
//                                       children: [
//                                         Row(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 Container(
//                                                   width: 50,
//                                                   height: 50,
//                                                   clipBehavior: Clip.antiAlias,
//                                                   decoration: BoxDecoration(
//                                                     borderRadius: BorderRadius.circular(10),
//                                                     image: DecorationImage(
//                                                       image: NetworkImage(
//                                                         controller.categories[index].categoryImage,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 /*Image.asset(
//                                     'assets/user.png',
//                                     width: 60,
//                                     height: 60,
//                                   ),*/
//                                                 Padding(
//                                                   padding: const EdgeInsets.only(left: 8.0),
//                                                   child: Column(
//                                                     mainAxisAlignment: MainAxisAlignment.start,
//                                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                                     children: [
//                                                       Padding(
//                                                         padding: const EdgeInsets.only(top: 3.0),
//                                                         child: Text(
//                                                           controller.categories[index].categoryName,
//                                                           style: const TextStyle(
//                                                             color: Color(0xff414141),
//                                                             fontWeight: FontWeight.w500,
//                                                             fontSize: 16,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                       Padding(
//                                                         padding: const EdgeInsets.only(top: 3.0),
//                                                         child: Text(
//                                                           "${controller.categories[index].noOfTransactions} transactions detected",
//                                                           style: const TextStyle(
//                                                             color: Color(0xffB8B8B8),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             Padding(
//                                               padding: const EdgeInsets.only(right: 20.0, top: 10),
//                                               child: Text(
//                                                 "${controller.categories[index].amount.toStringAsFixed(2)}",
//                                                 style: const TextStyle(
//                                                   color: Color(0xff414141),
//                                                   fontWeight: FontWeight.w500,
//                                                   fontSize: 16,
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         const Divider(
//                                           color: CupertinoColors.lightBackgroundGray,
//                                         ),
//                                         const SizedBox(
//                                           height: 5,
//                                         )
//                                       ],
//                                     ),
//                                   );
//                                 }),
//                             const Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 20),
//                               child: Row(
//                                 children: [
//                                   GradientText(
//                                     'TRANSACTIONS',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.w700,
//                                       fontSize: 15,
//                                     ),
//                                     gradient: LinearGradient(colors: [
//                                       Color(0xFFA342FF),
//                                       Color(0xFFE54D60),
//                                     ]),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             ListView.builder(
//                                 shrinkWrap: true,
//                                 physics: const NeverScrollableScrollPhysics(),
//                                 itemCount: controller.transactionBody != null ? controller.transactionBody["added"].length : 0,
//                                 itemBuilder: (BuildContext context, int index) {
//                                   return controller.transactionBody["added"][index]['merchant_name'] != null
//                                       ? Container(
//                                           padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                                           child: Column(
//                                             children: [
//                                               Row(
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                 children: [
//                                                   Row(
//                                                     children: [
//                                                       controller.transactionBody["added"][index]['counterparties'][0]["logo_url"] != null
//                                                           ? Container(
//                                                               width: 50,
//                                                               height: 50,
//                                                               clipBehavior: Clip.antiAlias,
//                                                               decoration: BoxDecoration(
//                                                                 borderRadius: BorderRadius.circular(10),
//                                                                 image: DecorationImage(
//                                                                   image: NetworkImage(
//                                                                     controller.transactionBody["added"][index]['counterparties'][0]
//                                                                         ["logo_url"],
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             )
//                                                           : Image.asset(
//                                                               'assets/user.png',
//                                                               width: 60,
//                                                               height: 60,
//                                                             ),
//                                                       Padding(
//                                                         padding: const EdgeInsets.only(left: 8.0),
//                                                         child: Column(
//                                                           mainAxisAlignment: MainAxisAlignment.start,
//                                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                                           children: [
//                                                             Padding(
//                                                               padding: const EdgeInsets.only(top: 3.0),
//                                                               child: Text(
//                                                                 controller.transactionBody["added"][index]['merchant_name'].toString(),
//                                                                 style: const TextStyle(
//                                                                   color: Color(0xff414141),
//                                                                   fontWeight: FontWeight.w500,
//                                                                   fontSize: 16,
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                             Padding(
//                                                               padding: const EdgeInsets.only(top: 3.0),
//                                                               child: Text(
//                                                                 controller.transactionBody["added"][index]['date'].toString(),
//                                                                 style: const TextStyle(
//                                                                   color: Color(0xffB8B8B8),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   Padding(
//                                                     padding: const EdgeInsets.only(right: 20.0, top: 10),
//                                                     child: Text(
//                                                       "${controller.transactionBody["added"][index]['amount']} ${controller.transactionBody["added"][index]['iso_currency_code']}",
//                                                       style: const TextStyle(
//                                                         color: Color(0xff414141),
//                                                         fontWeight: FontWeight.w500,
//                                                         fontSize: 16,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               const Divider(
//                                                 color: CupertinoColors.lightBackgroundGray,
//                                               ),
//                                               const SizedBox(
//                                                 height: 5,
//                                               )
//                                             ],
//                                           ),
//                                         )
//                                       : const SizedBox();
//                                 })
//                           ],
//                         ),
//             ],
//           );
//         } else {
//           return const Center(child: CircularProgressIndicator.adaptive());
//         }
//       },
//     );
//   }
// }
