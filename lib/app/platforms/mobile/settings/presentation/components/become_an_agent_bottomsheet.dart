// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:hushh_app/app/shared/config/routes/routes.dart';
// import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';
// import 'package:tuple/tuple.dart';
//
// class BecomeAnAgentBottomSheet extends StatelessWidget {
//   const BecomeAnAgentBottomSheet({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;
//     List<Tuple3<String, String, String>> items = [
//       const Tuple3("assets/user-solid.png", "Own Your Brand: Be the Agent",
//           "Take charge of your brand's journey. Shape your narrative and unlock potential."),
//       const Tuple3("assets/bolt-solid.png", "Brand Power: Self-Representation",
//           "Showcase authenticity, stand out."),
//       const Tuple3(
//           "assets/rectangles-mixed.png",
//           "Brand Control: Your Agent Journey",
//           "Navigate confidently, craft your story."),
//     ];
//
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         children: [
//           Align(
//             alignment: Alignment.centerLeft,
//             child: CupertinoButton(
//               padding: const EdgeInsets.symmetric(horizontal: 5),
//               child: const Text(
//                 'Cancel',
//                 style: TextStyle(color: Color(0xFF007AFF)),
//               ),
//               onPressed: () => Navigator.pop(context),
//             ),
//           ),
//           Expanded(
//             child: Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     'Be your own\nbrand\'s agent',
//                     style: textTheme.headlineLarge
//                         ?.copyWith(fontWeight: FontWeight.w600),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 55),
//                   ListView.separated(
//                     shrinkWrap: true,
//                     itemBuilder: (context, index) =>
//                         CustomListTile(item: items[index]),
//                     separatorBuilder: (context, index) =>
//                         const SizedBox(height: 40),
//                     itemCount: items.length,
//                   )
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 42),
//           HushhLinearGradientButton(
//             text: 'Get Started',
//             onTap: () {
//               Navigator.pushReplacementNamed(context, AppRoutes.agentSignUp);
//             },
//           ),
//           const SizedBox(height: 26)
//         ],
//       ),
//     );
//   }
// }
//
// class CustomListTile extends StatelessWidget {
//   final Tuple3<String, String, String> item;
//
//   const CustomListTile({super.key, required this.item});
//
//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 32.0),
//       child: Row(
//         children: [
//           Image.asset(
//             item.item1,
//             width: 32,
//           ),
//           const SizedBox(width: 20),
//           Expanded(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(item.item2,
//                     style: textTheme.titleMedium?.copyWith(
//                       fontWeight: FontWeight.w600,
//                     )),
//                 const SizedBox(height: 4),
//                 Text(item.item3)
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
