// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/agent_sign_up_bloc/bloc.dart';
// import 'package:hushh_app/app/platforms/mobile/auth/presentation/components/agent_sign_up_app_bar.dart';
// import 'package:hushh_app/app/platforms/mobile/auth/presentation/pages/agent_categories.dart';
// import 'package:hushh_app/app/platforms/mobile/auth/presentation/pages/email_verification.dart';
// import 'package:hushh_app/app/platforms/mobile/card_market/presentation/bloc/card_market_bloc/bloc.dart';
// import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
// import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/agent_text_field.dart';
// import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/brand_sign_up_list_view.dart';
// import 'package:hushh_app/app/shared/config/constants/enums.dart';
// import 'package:hushh_app/app/shared/config/constants/personal_domains.dart';
// import 'package:hushh_app/app/shared/config/routes/routes.dart';
// import 'package:hushh_app/app/shared/core/backend_controller/auth_controller/auth_controller_impl.dart';
// import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';
// import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
//
// class AgentSignUpPage extends StatefulWidget {
//   const AgentSignUpPage({super.key});
//
//   @override
//   State<AgentSignUpPage> createState() => _AgentSignUpPageState();
// }
//
// class _AgentSignUpPageState extends State<AgentSignUpPage> {
//   final controller = sl<AgentSignUpPageBloc>();
//
//   @override
//   void initState() {
//     controller.nameController.clear();
//     controller.brandController.clear();
//     controller.emailController.clear();
//     controller.locationController.clear();
//     controller.zipCodeController.clear();
//     controller.descController.clear();
//     controller.selectedBrand = null;
//     controller.agentImage = null;
//     controller.agentImageExt = null;
//     controller.selectedCategories = [];
//     controller.allCategorySections = {};
//     controller.suggestedCategorySections = null;
//     controller.add(FetchCategoriesEvent());
//     sl<CardMarketBloc>().add(FetchCardMarketEvent());
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const AgentSignUpAppBar(),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: BlocBuilder(
//         bloc: controller,
//         builder: (context, state) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: SizedBox(
//               height: 56,
//               child: HushhLinearGradientButton(
//                 text: 'Finish Setup',
//                 enabled: controller.isValidated,
//                 onTap: () {
//                   Navigator.pushNamed(context, AppRoutes.emailVerification,
//                       arguments: EmailVerificationPageArgs(
//                           controller.emailController.text));
//                 },
//               ),
//             ),
//           );
//         }
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: 16),
//               Stack(
//                 children: [
//                   BlocBuilder(
//                       bloc: controller,
//                       builder: (context, state) {
//                         return GestureDetector(
//                           onTap: () {
//                             controller.add(CaptureImageEvent());
//                           },
//                           child: CircleAvatar(
//                             radius: 12.w,
//                             foregroundImage: (controller.agentImage == null
//                                 ? const AssetImage('assets/user.png')
//                                 : MemoryImage(controller.agentImage!)
//                                     as ImageProvider),
//                           ),
//                         );
//                       }),
//                   Positioned(
//                     right: 4,
//                     bottom: 4,
//                     child: Container(
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         gradient: LinearGradient(colors: [
//                           Color(0XFFA342FF),
//                           Color(0XFFE54D60),
//                         ]),
//                       ),
//                       child: const Padding(
//                         padding: EdgeInsets.all(6.0),
//                         child: Icon(
//                           Icons.camera_alt,
//                           size: 18,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//               const SizedBox(height: 24),
//               AgentTextField(
//                   isAuthTextField: true,
//                   controller: controller.nameController,
//                   onChanged: (_) => setState(() {}),
//                   fieldType: CustomFormType.text,
//                   hintText: "Enter name"),
//               AgentTextField(
//                   isAuthTextField: true,
//                   textInputType: TextInputType.emailAddress,
//                   onChanged: (_) => setState(() {}),
//                   controller: controller.emailController,
//                   fieldType: CustomFormType.text,
//                   hintText: "Enter email"),
//               if (personalDomains.any((element) =>
//                   controller.emailController.text.trim().endsWith(element)))
//                 AgentTextField(
//                     isAuthTextField: true,
//                     controller: controller.brandController,
//                     fieldType: CustomFormType.list,
//                     onChanged: (_) => setState(() {}),
//                     onTap: () async {
//                       CardModel? selectedBrand = await showModalBottomSheet(
//                           context: context,
//                           isScrollControlled: true,
//                           constraints: BoxConstraints(maxHeight: 80.h),
//                           builder: (context) => BrandSignUpListView(
//                               brands: (sl<CardMarketBloc>().featuredCard ??
//                                       []) +
//                                   (sl<CardMarketBloc>().brandCardData ?? [])));
//                       if (selectedBrand != null) {
//                         controller.brandController.text =
//                             selectedBrand.brandName;
//                         controller.selectedBrand = selectedBrand;
//                         setState(() {});
//                       }
//                     },
//                     hintText: "Select Brand"),
//               AgentTextField(
//                   isAuthTextField: true,
//                   controller: controller.locationController,
//                   onChanged: (_) => setState(() {}),
//                   fieldType: CustomFormType.text,
//                   hintText: "City, State, Country"),
//               AgentTextField(
//                   isAuthTextField: true,
//                   controller: controller.zipCodeController,
//                   onChanged: (_) => setState(() {}),
//                   textInputType: TextInputType.number,
//                   fieldType: CustomFormType.text,
//                   hintText: "Zipcode"),
//               AgentTextField(
//                   isAuthTextField: true,
//                   maxLines: 4,
//                   controller: controller.descController,
//                   onChanged: (_) => setState(() {}),
//                   fieldType: CustomFormType.text,
//                   hintText: "Add Description"),
//               DefaultTextStyle(
//                 style: const TextStyle(color: Color(0xFF929292)),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text('Categories'),
//                     if (controller.selectedCategories.isNotEmpty)
//                       InkWell(
//                           onTap: () async {
//                             await Navigator.pushNamed(
//                                 context, AppRoutes.agentCategories);
//                             setState(() {});
//                           },
//                           child: const Text(
//                             'Select categories',
//                             style:
//                                 TextStyle(decoration: TextDecoration.underline),
//                           ))
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 12),
//               if (controller.selectedCategories.isNotEmpty)
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Wrap(
//                     spacing: 4.0,
//                     runSpacing: 2.0,
//                     children: List.generate(
//                       controller.selectedCategories.length,
//                       (index) {
//                         final category = controller.selectedCategories[index];
//                         return CustomChip(
//                           label: category.name,
//                           isEnabled:
//                               controller.selectedCategories.contains(category),
//                           onTap: () {
//                             if (controller.selectedCategories
//                                 .contains(category)) {
//                               controller.selectedCategories.remove(category);
//                             } else {
//                               controller.selectedCategories.add(category);
//                             }
//                             setState(() {});
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                 )
//               else
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: InkWell(
//                     onTap: () async {
//                       await Navigator.pushNamed(
//                           context, AppRoutes.agentCategories);
//                       setState(() {});
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 4.0, vertical: 2),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Container(
//                             decoration: const BoxDecoration(
//                               shape: BoxShape.circle,
//                               gradient: LinearGradient(colors: [
//                                 Color(0XFFA342FF),
//                                 Color(0XFFE54D60),
//                               ]),
//                             ),
//                             child: const Padding(
//                               padding: EdgeInsets.all(4.0),
//                               child: Icon(
//                                 Icons.add,
//                                 size: 18,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           const Text('Select categories')
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               const SizedBox(height: 120)
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
