// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/auth_bloc/bloc.dart';
// import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/sign_up_bloc/bloc.dart';
// import 'package:hushh_app/app/shared/core/firebase_config/firebase_remote_config_service.dart';
// import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class UserSignUpPage extends StatefulWidget {
//   const UserSignUpPage({Key? key}) : super(key: key);
//
//   @override
//   State<UserSignUpPage> createState() => _UserSignUpPageState();
// }
//
// class _UserSignUpPageState extends State<UserSignUpPage> {
//   final authController = sl<AuthPageBloc>();
//   final signUpController = sl<SignUpPageBloc>();
//
//   @override
//   void initState() {
//     signUpController.add(SignUpInitializeEvent());
//     authController.add(InitializeEvent());
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(
//                 height: 7.h,
//               ),
//               Row(
//                 children: [
//                   InkWell(
//                     onTap: () =>
//                         signUpController.add(OnBackPressedEvent(context)),
//                     child: SvgPicture.asset(
//                       'assets/back.svg',
//                     ),
//                   ),
//                   const SizedBox(width: 94),
//                   // Adjust the spacing between InkWell and Text
//                   const Text(
//                     "Sign up",
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 24,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               TextFormField(
//                 onFieldSubmitted: (e) {
//                   signUpController.firstNameFocusNode.unfocus();
//                   FocusScope.of(context)
//                       .requestFocus(signUpController.lastNameFocusNode);
//                 },
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "First Name*";
//                   }
//                   return null;
//                 },
//                 // autovalidateMode: AutovalidateMode.onUserInteraction,
//                 // textCapitalization: TextCapitalization.words,
//                 keyboardType: TextInputType.name,
//                 focusNode: signUpController.firstNameFocusNode,
//                 controller: signUpController.firstNameController,
//                 decoration: InputDecoration(
//                   isDense: true,
//                   hintText: 'First Name*',
//                   hintStyle: const TextStyle(
//                     fontSize: 14.0,
//                     color: Colors.black,
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(5),
//                     borderSide:
//                         const BorderSide(color: Colors.grey, width: 0.0),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(5),
//                     borderSide:
//                         const BorderSide(color: Colors.grey, width: 0.0),
//                   ),
//                 ),
//               ),
//               TextFormField(
//                 onFieldSubmitted: (e) {
//                   signUpController.lastNameFocusNode.unfocus();
//                   FocusScope.of(context)
//                       .requestFocus(signUpController.emailFocusNode);
//                 },
//                 textCapitalization: TextCapitalization.words,
//                 keyboardType: TextInputType.name,
//                 focusNode: signUpController.lastNameFocusNode,
//                 controller: signUpController.lastNameController,
//                 decoration: InputDecoration(
//                   isDense: true,
//                   hintText: 'Last Name',
//                   hintStyle: const TextStyle(
//                     fontSize: 14.0,
//                     color: Colors.black,
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(5),
//                     borderSide:
//                         const BorderSide(color: Colors.grey, width: 0.0),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(5),
//                     borderSide:
//                         const BorderSide(color: Colors.grey, width: 0.0),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10.h),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   TextFormField(
//                     focusNode: signUpController.dobFocusNode,
//                     onFieldSubmitted: (e) {
//                       signUpController.dobFocusNode.unfocus();
//                       FocusScope.of(context)
//                           .requestFocus(signUpController.emailFocusNode);
//                     },
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return authController.isUser
//                             ? "Please enter your date of birth?"
//                             : "When did you start working in ${signUpController.firstNameController.text}?";
//                       }
//                       return null;
//                     },
//                     // autovalidateMode: AutovalidateMode.onUserInteraction,
//                     controller: signUpController.dobController,
//                     onTap: () => signUpController.add(SelectDateEvent(context)),
//                     readOnly: true,
//                     decoration: InputDecoration(
//                       isDense: true,
//                       hintText: 'Birthday (mm/dd/yyyy)',
//                       hintStyle: const TextStyle(
//                         fontSize: 14.0,
//                         color: Colors.black,
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(5),
//                         borderSide:
//                             const BorderSide(color: Colors.grey, width: 0.0),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(5),
//                         borderSide:
//                             const BorderSide(color: Colors.grey, width: 0.0),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 05,
//                   ),
//                   const Text(
//                     "To sign up, you need to be at least 18.",
//                     style: TextStyle(
//                         color: Color(0xff7B7B7B), fontWeight: FontWeight.w300),
//                   )
//                 ],
//               ),
//               const SizedBox(
//                 height: 40,
//               ),
//               authController.isPhoneLogin
//                   ? Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         TextFormField(
//                           onFieldSubmitted: (e) {
//                             signUpController.emailFocusNode.unfocus();
//                           },
//                           validator: (value) {
//                             if (value!.isNotEmpty) {
//                               if (!RegExp(
//                                       r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+\.([a-zA-Z0-9!#$%&*+/=?^_`{|}~-]+)$')
//                                   .hasMatch(value.trim())) {
//                                 return 'Please enter a valid email';
//                               }
//                             }
//                             return null;
//                           },
//                           // autovalidateMode: AutovalidateMode.onUserInteraction,
//                           // textCapitalization: TextCapitalization.words,
//                           keyboardType: TextInputType.emailAddress,
//                           focusNode: signUpController.emailFocusNode,
//                           controller: signUpController.emailOrPhoneController,
//                           decoration: InputDecoration(
//                             isDense: true,
//                             hintText: 'Email Address*',
//                             hintStyle: const TextStyle(
//                               fontSize: 14.0,
//                               color: Colors.black,
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5),
//                               borderSide: const BorderSide(
//                                   color: Colors.grey, width: 0.0),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5),
//                               borderSide: const BorderSide(
//                                   color: Colors.grey, width: 0.0),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 05,
//                         ),
//                         const Text(
//                           "We’ll email you order confirmations and receipts.",
//                           style: TextStyle(
//                               color: Color(0xff7B7B7B),
//                               fontWeight: FontWeight.w300),
//                         )
//                       ],
//                     )
//                   : Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         BlocBuilder(
//                           bloc: authController,
//                           builder: (context, state) {
//                             return TextFormField(
//                               onFieldSubmitted: (e) {
//                                 signUpController.emailFocusNode.unfocus();
//                               },
//                               validator: (value) {
//                                 if (value!.isEmpty) {
//                                   return 'Please enter a valid phone number';
//                                 }
//                                 return null;
//                               },
//                               // autovalidateMode:
//                               //     AutovalidateMode.onUserInteraction,
//                               // textCapitalization: TextCapitalization.words,
//                               keyboardType: TextInputType.phone,
//                               focusNode: signUpController.emailFocusNode,
//                               controller: signUpController.emailOrPhoneController,
//                               decoration: InputDecoration(
//                                 isDense: true,
//                                 hintText: 'Phone number',
//                                 hintStyle: const TextStyle(
//                                   fontSize: 14.0,
//                                   color: Colors.black,
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(5),
//                                   borderSide: const BorderSide(
//                                       color: Colors.grey, width: 0.0),
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(5),
//                                   borderSide: const BorderSide(
//                                       color: Colors.grey, width: 0.0),
//                                 ),
//                                 prefixIcon: Container(
//                                   margin: const EdgeInsets.only(right: 5),
//                                   padding:
//                                       const EdgeInsets.only(left: 10, right: 5),
//                                   decoration: BoxDecoration(
//                                       border: Border(
//                                           right: BorderSide(
//                                               color: const Color(0xff8391a1)
//                                                   .withOpacity(0.5),
//                                               width: 2))),
//                                   child: InkWell(
//                                     borderRadius: BorderRadius.circular(10),
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: <Widget>[
//                                         if (authController.selectedCountry !=
//                                             null)
//                                           ClipRRect(
//                                             borderRadius:
//                                                 BorderRadius.circular(2),
//                                             child: Image.asset(
//                                               "assets/flags/${authController.selectedCountry!.code.toLowerCase()}.png",
//                                               width: 26,
//                                             ),
//                                           ),
//                                         const SizedBox(
//                                           width: 5,
//                                         ),
//                                         const Icon(
//                                           Icons.keyboard_arrow_down_sharp,
//                                           color: Color(0xff565966),
//                                         ),
//                                       ],
//                                     ),
//                                     onTap: () => authController
//                                         .add(OnCountryUpdateEvent(context)),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                         const SizedBox(
//                           height: 05,
//                         ),
//                         const Text(
//                           "We’ll sms you order confirmations and receipts.",
//                           style: TextStyle(
//                               color: Color(0xff7B7B7B),
//                               fontWeight: FontWeight.w300),
//                         )
//                       ],
//                     ),
//               SizedBox(height: 5.h),
//               Text.rich(TextSpan(
//                   text: 'By entering information, I agree to Hushh’s ',
//                   style: const TextStyle(
//                       fontWeight: FontWeight.w400, fontSize: 16),
//                   children: <InlineSpan>[
//                     TextSpan(
//                       text: 'Terms of Service',
//                       recognizer: TapGestureRecognizer()
//                         ..onTap = () {
//                           launchUrl(Uri.parse(
//                               FirebaseRemoteConfigService().termsOfService));
//                         },
//                       style: const TextStyle(
//                           fontSize: 16,
//                           color: Color(0xff118CFD),
//                           fontWeight: FontWeight.w400,
//                           decoration: TextDecoration.underline),
//                     ),
//                     const TextSpan(
//                       text: ', ',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Color(0xff118CFD),
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                     TextSpan(
//                       text: 'Non-discrimination Policy',
//                       recognizer: TapGestureRecognizer()
//                         ..onTap = () {
//                           launchUrl(Uri.parse(FirebaseRemoteConfigService()
//                               .nonDisclaimerPolicy));
//                         },
//                       style: const TextStyle(
//                           fontSize: 16,
//                           color: Color(0xff118CFD),
//                           fontWeight: FontWeight.w400,
//                           decoration: TextDecoration.underline),
//                     ),
//                     const TextSpan(
//                       text: ' and ',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.black,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                     TextSpan(
//                       text: 'Payments Terms of Service',
//                       recognizer: TapGestureRecognizer()
//                         ..onTap = () {
//                           launchUrl(Uri.parse(FirebaseRemoteConfigService()
//                               .paymentTermsService));
//                         },
//                       style: const TextStyle(
//                           fontSize: 16,
//                           color: Color(0xff118CFD),
//                           fontWeight: FontWeight.w400,
//                           decoration: TextDecoration.underline),
//                     ),
//                     const TextSpan(
//                       text: ' and acknowledge the ',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.black,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                     TextSpan(
//                       text: 'Privacy Policy',
//                       recognizer: TapGestureRecognizer()
//                         ..onTap = () {
//                           launchUrl(Uri.parse(
//                               FirebaseRemoteConfigService().privacyPolicy));
//                         },
//                       style: const TextStyle(
//                           fontSize: 16,
//                           color: Color(0xff118CFD),
//                           fontWeight: FontWeight.w400,
//                           decoration: TextDecoration.underline),
//                     ),
//                     const TextSpan(
//                       text: '.',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                   ])),
//               SizedBox(height: 10.h),
//               InkWell(
//                 onTap: () => signUpController.add(SignUpEvent(context)),
//                 child: Container(
//                   width: double.infinity,
//                   height: 56,
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(colors: [
//                       Color(0XFFA342FF),
//                       Color(0XFFE54D60),
//                     ]),
//                     borderRadius: BorderRadius.circular(7),
//                   ),
//                   child: BlocBuilder(
//                     bloc: signUpController,
//                     builder: (context, state) => Center(
//                       child: state is SigningUpState
//                           ? const Center(
//                               child: Padding(
//                                 padding: EdgeInsets.all(5),
//                                 child: CircularProgressIndicator(
//                                   color: Colors.white,
//                                   strokeWidth: 3,
//                                 ),
//                               ),
//                             )
//                           : const Text(
//                               "Confirm",
//                               style: TextStyle(
//                                   color: Color(0xffFFFFFF),
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w500),
//                             ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
