// import 'dart:convert';
// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:http/http.dart' as http;
// import 'package:hushh_app/app/platforms/mobile/settings/presentation/components/carousel_slider/src/image_slider.dart';
// import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
// import 'package:hushh_app/app/platforms/mobile/home/presentation/pages/home.dart';
// import 'package:hushh_app/app/shared/config/assets/icon.dart';
// import 'package:hushh_app/app/shared/config/constants/colors.dart';
// import 'package:hushh_app/app/shared/config/constants/constants.dart';
// import 'package:hushh_app/app/shared/config/routes/routes.dart';
// import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
//
// int currentIndexGlobal = 1;
//
// class NewAgentView extends StatefulWidget {
//   const NewAgentView({super.key});
//
//   @override
//   State<NewAgentView> createState() => _NewAgentViewState();
// }
//
// class _NewAgentViewState extends State<NewAgentView> {
//   PageController controller = PageController();
//   FocusNode categoryFocusNode = FocusNode();
//   Color borderedColor = const Color(0xffEA4841);
//   Color black900 = const Color(0xff181941);
//   Color indigoColor = const Color(0xff2020ED);
//   Color redColor = const Color(0xffEA4841);
//   Color borderColor = const Color(0XFFD7D7E8);
//   FocusNode nameFocusNode = FocusNode();
//   TextEditingController brandNameController = TextEditingController();
//   int _curr = 0;
//   final ImagePicker _picker = ImagePicker();
//   final fireStore = FirebaseFirestore.instance;
//   TextEditingController categoryController = TextEditingController();
//   final auth = FirebaseAuth.instance;
//   BrandCardDatumFullData? brandCardDataDirect;
//   List<String> brandCardDataDirectList = [];
//   List categoryList = [
//     'Please select a category',
//     'Fashion, Dress, Personal',
//     'General preference - Personal',
//     'Health, Life, Property: Insurance',
//     'Culinary, Unwind, Leisure',
//     'Travel, Roam, Explore',
//   ];
//   String brandUrl = "";
//   String logoUrl = "";
//   bool buttonLoad = false;
//   List selectType = ["Choose Photo", "Take Photo"];
//   bool cardView = false;
//   bool submitLoading = false;
//   bool normLoading = false;
//   List<String> cardIds = [
//     "b103d3fd252c0f65841499309b1f088357b7fa74",
//     "b103d3fd252c0f65841499309b1f088357b7fa75",
//     "b103d3fd252c0f65841499309b1f088357b7fa76",
//     "b103d3fd252c0f65841499309b1f088357b7fa77",
//     "b103d3fd252c0f65841499309b1f088357b7fa78",
//     "b103d3fd252c0f65841499309b1f088357b7fa79",
//     "b103d3fd252c0f65841499309b1f088357b7fa80",
//     "b103d3fd252c0f65841499309b1f088357b7fa81",
//     "b103d3fd252c0f65841499309b1f088357b7fa82",
//     "b103d3fd252c0f65841499309b1f088357b7fa83",
//     "b103d3fd252c0f65841499309b1f088357b7fa84",
//     "b103d3fd252c0f65841499309b1f088357b7fa85",
//     "b103d3fd252c0f65841499309b1f088357b7fa86",
//     "b103d3fd252c0f65841499309b1f088357b7fa87",
//     "b103d3fd252c0f65841499309b1f088357b7fa88",
//     "b103d3fd252c0f65841499309b1f088357b7fa89",
//     "b103d3fd252c0f65841499309b1f088357b7fa90",
//     "b103d3fd252c0f65841499309b1f088357b7fa91",
//     "b103d3fd252c0f65841499309b1f088357b7fa92",
//     "b103d3fd252c0f65841499309b1f088357b7fa93",
//     "b103d3fd252c0f65841499309b1f088357b7fa94",
//   ];
//
//   genderSheet(dynamic selectedValue) {
//     return showModalBottomSheet(
//         // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         context: context,
//         backgroundColor: Colors.transparent,
//         builder: (BuildContext context) {
//           return Container(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Card(
//                   color: const Color(0xffFBFBFB),
//                   margin: const EdgeInsets.symmetric(horizontal: 30),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20)),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       ListTile(
//                         shape: const RoundedRectangleBorder(
//                             borderRadius: BorderRadius.vertical(
//                                 top: Radius.circular(20))),
//                         onTap: () {
//                           setState(() {
//                             categoryController.text = selectedValue[0];
//                           });
//                           Navigator.pop(context);
//                         },
//                         title: Center(
//                             child: Text(
//                           selectedValue[0],
//                           style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w500,
//                               color: Color(0xff454567)),
//                         )),
//                       ),
//                       const Divider(
//                         // thickness: 0.0,
//                         height: 0,
//                       ),
//                       ListTile(
//                         onTap: () {
//                           setState(() {
//                             categoryController.text = selectedValue[1];
//                           });
//                           Navigator.pop(context);
//                         },
//                         title: Center(
//                             child: Text(
//                           selectedValue[1],
//                           style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w500,
//                               color: Color(0xff454567)),
//                         )),
//                       ),
//                       const Divider(
//                         // thickness: 0.0,
//                         height: 0,
//                       ),
//                       ListTile(
//                         shape: const RoundedRectangleBorder(
//                             borderRadius: BorderRadius.vertical(
//                                 bottom: Radius.circular(20))),
//                         onTap: () {
//                           setState(() {
//                             categoryController.text = selectedValue[2];
//                           });
//                           Navigator.pop(context);
//                         },
//                         title: Center(
//                             child: Text(
//                           selectedValue[2],
//                           style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w500,
//                               color: Color(0xff454567)),
//                         )),
//                       ),
//                       const Divider(
//                         // thickness: 0.0,
//                         height: 0,
//                       ),
//                       ListTile(
//                         shape: const RoundedRectangleBorder(
//                             borderRadius: BorderRadius.vertical(
//                                 bottom: Radius.circular(20))),
//                         onTap: () {
//                           setState(() {
//                             categoryController.text = selectedValue[3];
//                           });
//                           Navigator.pop(context);
//                         },
//                         title: Center(
//                             child: Text(
//                           selectedValue[3],
//                           style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w500,
//                               color: Color(0xff454567)),
//                         )),
//                       ),
//                       const Divider(
//                         // thickness: 0.0,
//                         height: 0,
//                       ),
//                       ListTile(
//                         shape: const RoundedRectangleBorder(
//                             borderRadius: BorderRadius.vertical(
//                                 bottom: Radius.circular(20))),
//                         onTap: () {
//                           setState(() {
//                             categoryController.text = selectedValue[4];
//                           });
//                           Navigator.pop(context);
//                         },
//                         title: Center(
//                             child: Text(
//                           selectedValue[4],
//                           style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w500,
//                               color: Color(0xff454567)),
//                         )),
//                       ),
//                       const Divider(
//                         // thickness: 0.0,
//                         height: 0,
//                       ),
//                       ListTile(
//                         shape: const RoundedRectangleBorder(
//                             borderRadius: BorderRadius.vertical(
//                                 bottom: Radius.circular(20))),
//                         onTap: () {
//                           setState(() {
//                             categoryController.text = selectedValue[5];
//                           });
//                           Navigator.pop(context);
//                         },
//                         title: Center(
//                             child: Text(
//                           selectedValue[5],
//                           style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w500,
//                               color: Color(0xff454567)),
//                         )),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height / 50,
//                 ),
//                 Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 30),
//                   decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                           begin: Alignment.centerLeft,
//                           end: Alignment.bottomCenter,
//                           colors: [
//                             Color(0xff7A14AB),
//                             Color(0xffAC0D86),
//                           ]),
//                       borderRadius: BorderRadius.circular(20)),
//                   child: ListTile(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20)),
//                     title: const Center(
//                         child: Text(
//                       "Cancel",
//                       style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w500,
//                           color: Color(0xffFFFFFF)),
//                     )),
//                   ),
//                 ),
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height / 23.88,
//                 ),
//                 // Container(
//                 //   padding: EdgeInsets.only(
//                 //     bottom: MediaQuery.of(context).padding.bottom
//                 //   ),
//                 // )
//               ],
//             ),
//           );
//         });
//   }
//
//   _cropImage(filePath) async {
//     CroppedFile? croppedImage = await ImageCropper().cropImage(
//       sourcePath: filePath,
//       cropStyle: CropStyle.rectangle,
//       maxHeight: 600,
//       maxWidth: 600,
//       aspectRatio: const CropAspectRatio(ratioY: 600, ratioX: 600),
//       aspectRatioPresets: [
//         CropAspectRatioPreset.original,
//       ],
//       uiSettings: [
//         AndroidUiSettings(
//             toolbarTitle: 'Cropper',
//             toolbarColor: CustomColors.projectBaseBlue,
//             toolbarWidgetColor: Colors.white,
//             initAspectRatio: CropAspectRatioPreset.original,
//             lockAspectRatio: true),
//         IOSUiSettings(
//           title: 'Cropper',
//         )
//       ],
//       compressQuality: 50,
//     );
//     if (croppedImage != null) {
//       uploadImage(croppedImage);
//     }
//   }
//
//   Future<String> uploadImage(CroppedFile? imageFile) async {
//     setState(() {
//       brandUrl = '';
//       buttonLoad = true;
//     });
//     User loggedUser = auth.currentUser!;
//     FirebaseStorage storage = FirebaseStorage.instance;
//     //await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL()
//     Reference ref =
//         storage.ref().child("user/cardMarket_logo/${loggeduser.hushhId}.png");
//     File uploadingFile = File(imageFile!.path);
//     UploadTask uploadTask = ref.putFile(uploadingFile);
//     //UploadTask uploadTask = ref.putFile(_choosedGender == null ? imageFile : _choosedGender == "Female" ? File("assets/default_female.png") : _choosedGender == "Male" ? File("assets/default_male.png") : imageFile);
//     String url =
//         await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
//     setState(() {
//       brandUrl = url;
//       buttonLoad = false;
//     });
//     return url;
//   }
//
//   Future<String> uploadImage1(imageFile) async {
//     setState(() {
//       logoUrl = '';
//       buttonLoad = true;
//     });
//     User loggedUser = auth.currentUser!;
//     FirebaseStorage storage = FirebaseStorage.instance;
//     //await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL()
//     Reference ref =
//         storage.ref().child("user/brand_logo/${loggeduser.hushhId}.png");
//     File uploadingFile = File(imageFile);
//     UploadTask uploadTask = ref.putFile(uploadingFile);
//     //UploadTask uploadTask = ref.putFile(_choosedGender == null ? imageFile : _choosedGender == "Female" ? File("assets/default_female.png") : _choosedGender == "Male" ? File("assets/default_male.png") : imageFile);
//     String url =
//         await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
//     setState(() {
//       logoUrl = url;
//       buttonLoad = false;
//     });
//     return url;
//   }
//
//   cardMarketApiCall() async {
//     setState(() {
//       normLoading = true;
//     });
//     for (int i = 0; i < 20; i++) {
//       var responseItem = await http.post(
//           Uri.parse('${Constants.baseUrl}/admin/v1/get_card_data'),
//           headers: {
//             "Content-Type": "application/x-www-form-urlencoded"
//           },
//           body: {
//             "card_id": cardIds[i],
//           });
//       if (responseItem.statusCode == 200) {
//         setState(() {
//           var resp = jsonDecode(responseItem.body);
//           print("resp");
//           brandCardDataDirect = BrandCardDatumFullData.fromJson(resp['data']);
//           print("brandCardDataDirect");
//           print(brandCardDataDirect);
//           brandCardDataDirectList.add(brandCardDataDirect!.preview);
//           print("brandCardDataDirectList");
//           print(brandCardDataDirectList);
//         });
//       }
//     }
//     setState(() {
//       normLoading = false;
//     });
//   }
//
//   createNewCard() async {
//     BrandCardDatumFullData? brandCardDataDirect;
//     var responseItem = await http.post(
//         Uri.parse('${Constants.baseUrl}/admin/v1/get_card_data'),
//         headers: {
//           "Content-Type": "application/x-www-form-urlencoded"
//         },
//         body: {
//           "card_id": cardIds[currentIndexGlobal],
//         });
//     if (responseItem.statusCode == 200) {
//       var resp = jsonDecode(responseItem.body);
//       brandCardDataDirect = BrandCardDatumFullData.fromJson(resp['data']);
//     }
//     var responseItem1 = await http.post(
//         Uri.parse('${Constants.baseUrl}/admin/v1/save_card_type'),
//         headers: {
//           "Content-Type": "application/x-www-form-urlencoded"
//         },
//         body: {
//           "brand_name": brandNameController.text,
//           "category": categoryController.text,
//           "type": "1",
//           "image": brandUrl,
//           "preview": brandCardDataDirect!.preview,
//           "color": brandCardDataDirect.color,
//           "banner_image": brandCardDataDirect.bannerImage,
//           "gradient_1_color": brandCardDataDirect.gradient1Color,
//           "gradient_2_color": brandCardDataDirect.gradient2Color,
//           "body_image": brandCardDataDirect.bodyImage,
//           "logo": logoUrl,
//           "brand_name_color": brandCardDataDirect.brandNameColor,
//           "coins_color": brandCardDataDirect.coinsColor,
//           "customer_color": brandCardDataDirect.customerColor,
//           "customer_name_color": brandCardDataDirect.customerNameColor,
//           "card_value": "1",
//           "agent_id": LocalStorage.currentUserUid,
//           "featured": "1"
//         });
//     if (responseItem1.statusCode == 200) {
//       print("responseItem.body");
//       var resp = jsonDecode(responseItem1.body);
//       print(resp);
//       print("aaa");
//       print(resp["card_id"]);
//       await http.post(
//           Uri.parse(
//               '${Constants.baseUrl}/admin/v1/save_survey_questions'),
//           headers: {
//             "Content-Type": "application/x-www-form-urlencoded"
//           },
//           body: {
//             "card_market_id": resp["card_id"],
//             "question": "why are you in ${brandNameController.text} for?",
//             "type": "1",
//           });
//       await http.post(
//           Uri.parse(
//               '${Constants.baseUrl}/admin/v1/save_survey_questions'),
//           headers: {
//             "Content-Type": "application/x-www-form-urlencoded"
//           },
//           body: {
//             "card_market_id": resp["card_id"],
//             "question": "How ${brandNameController.text} agents can help you?",
//             "type": "1",
//           });
//       await http.post(
//           Uri.parse(
//               '${Constants.baseUrl}/admin/v1/save_survey_questions'),
//           headers: {
//             "Content-Type": "application/x-www-form-urlencoded"
//           },
//           body: {
//             "card_market_id": resp["card_id"],
//             "question":
//                 "Are you in ${brandNameController.text} for any occasion?",
//             "type": "1",
//           });
//       await FirebaseFirestore.instance.collection("AgentCardMarket").add({
//         "brand_name": brandNameController.text,
//         "category": categoryController.text,
//         "type": 1,
//         "image": brandUrl,
//         "replica": cardIds[currentIndexGlobal],
//         "logo": logoUrl,
//         "user_id": LocalStorage.currentUserUid,
//       }).then((value) {
//         FirebaseFirestore.instance
//             .collection("AgentCardMarket")
//             .doc(value.id)
//             .update({"id": resp["card_id"]});
//       });
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: const Color(0xFFEEEEEE),
//         elevation: 0,
//         duration: const Duration(milliseconds: 2000),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//         content: const Text(
//           'Card hosted in card market successfully!',
//           textAlign: TextAlign.center,
//           style: TextStyle(color: Colors.black),
//         ),
//         margin: const EdgeInsets.all(120),
//       ));
//       Navigator.pushNamed(context, AppRoutes.home,
//           arguments: HomePageArgs(tabValue: 1));
//     } else {
//       print("responseItem.statusCode");
//       print(responseItem1.statusCode);
//     }
//     setState(() {
//       submitLoading = false;
//     });
//   }
//
//   @override
//   void initState() {
//     cardMarketApiCall();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffFFFFFF),
//       appBar: AppBar(
//           backgroundColor: CustomColors.whiteColor,
//           elevation: 5,
//           leadingWidth: 100.w / 6.69,
//           centerTitle: false,
//           automaticallyImplyLeading: false,
//           shadowColor: Colors.black12,
//           toolbarHeight: 72,
//           title: const Text(
//             "New Brand",
//             style: TextStyle(color: Color(0xff2D2D53), fontSize: 28),
//           ),
//           leading: IconButton(
//             padding: const EdgeInsets.only(left: 1),
//             icon: SvgPicture.asset(
//               AppIcons.backArrow_narrow,
//               height: 19.5,
//               width: 18,
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           )),
//       body: !cardView
//           ? SizedBox(
//               height: 85.h,
//               width: double.infinity,
//               child: ListView(
//                 children: [
//                   SizedBox(height: 5.h),
//                   Padding(
//                     padding: const EdgeInsets.only(right: 20, left: 20),
//                     child: TextFormField(
//                       onFieldSubmitted: (e) {
//                         nameFocusNode.unfocus();
//                         //FocusScope.of(context).requestFocus(gmailFocusNode);
//                       },
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your brand name';
//                         }
//                         return null;
//                       },
//                       autovalidateMode: AutovalidateMode.onUserInteraction,
//                       textCapitalization: TextCapitalization.words,
//                       cursorColor: borderColor,
//                       onChanged: (e) {
//                         //userName = fullNameController.text;
//                       },
//                       style:
//                           TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                       keyboardType: TextInputType.name,
//                       focusNode: nameFocusNode,
//                       decoration: InputDecoration(
//                         contentPadding:
//                             const EdgeInsets.fromLTRB(20, 20, 20, 20),
//                         counterText: '',
//                         hintText: "Brand Name",
//                         errorStyle: TextStyle(
//                             color: redColor,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500),
//                         hintStyle: TextStyle(
//                             color: borderColor,
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30.0),
//                           borderSide:
//                               BorderSide(width: 2.0, color: borderColor),
//                         ),
//                         errorBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30.0),
//                           borderSide: BorderSide(width: 2.0, color: redColor),
//                         ),
//                         focusedErrorBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30.0),
//                           borderSide: BorderSide(width: 2.0, color: redColor),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30.0),
//                           borderSide: BorderSide(
//                             color: indigoColor,
//                             width: 2.0,
//                           ),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30.0),
//                           borderSide: BorderSide(
//                             color: borderColor,
//                             width: 2.0,
//                           ),
//                         ),
//                       ),
//                       controller: brandNameController,
//                     ),
//                   ),
//                   Container(
//                     height: 100.h / 25.37,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(right: 20, left: 20),
//                     child: Container(
//                       child: TextFormField(
//                         style: TextStyle(
//                             fontSize: 14, fontWeight: FontWeight.bold),
//                         controller: categoryController,
//                         //initialValue: 'Please select an option',
//                         onTap: () {
//                           genderSheet(categoryList);
//                         },
//                         readOnly: true,
//                         focusNode: categoryFocusNode,
//                         /*onChanged: (e) {
//                           userName = genderController.text;
//                         },*/
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         validator: (value) {
//                           if (value == null ||
//                               value == 'Please select a category') {
//                             return 'Please select your category';
//                           }
//                           return null;
//                         },
//                         decoration: InputDecoration(
//                           suffixIcon: Padding(
//                             padding: const EdgeInsets.only(right: 10),
//                             child: Icon(
//                               Icons.keyboard_arrow_down,
//                               size: 40,
//                               color: indigoColor,
//                             ),
//                           ),
//                           contentPadding:
//                               const EdgeInsets.fromLTRB(20, 20, 20, 20),
//                           hintText: 'Category',
//                           errorStyle: TextStyle(
//                               color: redColor,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(30.0),
//                             borderSide: BorderSide(
//                               color: borderColor,
//                               width: 2.0,
//                             ),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(30.0),
//                             borderSide: BorderSide(
//                               color: borderColor,
//                               width: 2.0,
//                             ),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(30.0),
//                             borderSide: BorderSide(
//                               color: indigoColor,
//                               width: 2.0,
//                             ),
//                           ),
//                           focusedErrorBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(30.0),
//                             borderSide: BorderSide(width: 2.0, color: redColor),
//                           ),
//                           errorBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(30.0),
//                             borderSide: BorderSide(width: 2.0, color: redColor),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding:
//                         const EdgeInsets.only(right: 10, left: 20, top: 20),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Select you brand image:",
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             Text(
//                               "This image is used in card market to host your brand card. \nSuitable size is 240 x 240:",
//                               style:
//                                   TextStyle(fontSize: 11, color: Colors.black),
//                             ),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             InkWell(
//                               onTap: () async {
//                                 XFile? image = await _picker.pickImage(
//                                     source: ImageSource.gallery);
//                                 await _cropImage(image!.path);
//                               },
//                               child: Container(
//                                 width: 75,
//                                 height: 75,
//                                 decoration: BoxDecoration(
//                                   border: Border.all(color: Color(0XFFD7D7E8)),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Center(
//                                   child: SvgPicture.asset(
//                                     AppIcons.fileUploadIcon,
//                                     color: Color(0XFFD7D7E8),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Preview:",
//                               style:
//                                   TextStyle(fontSize: 10, color: Colors.black),
//                             ),
//                             SizedBox(
//                               height: 5,
//                             ),
//                             SizedBox(
//                                 width: 75,
//                                 child: brandUrl.isEmpty
//                                     ? Image.network(
//                                         'https://firebasestorage.googleapis.com/v0/b/hushone-app.appspot.com/o/wallet_brand_logos%2FNicholas.png?alt=media&token=5aa8e49d-8ee7-4efd-829c-45523bce6801')
//                                     : Image.network(brandUrl)),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding:
//                         const EdgeInsets.only(right: 10, left: 20, top: 20),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Select you logo image:",
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             Text(
//                               "This image is used in your brand card to display your logo. \nTransparent background is suitable:",
//                               style:
//                                   TextStyle(fontSize: 11, color: Colors.black),
//                             ),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             InkWell(
//                               onTap: () async {
//                                 XFile? image = await _picker.pickImage(
//                                     source: ImageSource.gallery);
//                                 await uploadImage1(image!.path);
//                               },
//                               child: Container(
//                                   width: 75,
//                                   height: 75,
//                                   decoration: BoxDecoration(
//                                     border:
//                                         Border.all(color: Color(0XFFD7D7E8)),
//                                     borderRadius: BorderRadius.circular(5),
//                                   ),
//                                   child: Center(
//                                       child: SvgPicture.asset(
//                                     AppIcons.fileUploadIcon,
//                                     color: Color(0XFFD7D7E8),
//                                   ))),
//                             ),
//                           ],
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Preview:",
//                               style:
//                                   TextStyle(fontSize: 10, color: Colors.black),
//                             ),
//                             SizedBox(
//                               height: 5,
//                             ),
//                             SizedBox(
//                               width: 75,
//                               height: 75,
//                               child: Center(
//                                   child: logoUrl.isEmpty
//                                       ? Image.network(
//                                           'https://firebasestorage.googleapis.com/v0/b/hushone-app.appspot.com/o/wallet_brand_banners%2FNicholas_Kirkwood_logo_carbon_neutral_made_in_europe_timeless%201.png?alt=media&token=0e56498c-eebd-45ad-a641-5a5dc8db31fe')
//                                       : Image.network(logoUrl)),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     height: 15.h,
//                   ),
//                   Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 30),
//                     decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                             begin: Alignment.centerLeft,
//                             end: Alignment.bottomCenter,
//                             colors: [
//                               Color(0xff7A14AB),
//                               Color(0xffAC0D86),
//                             ]),
//                         borderRadius: BorderRadius.circular(20)),
//                     child: ListTile(
//                       onTap: () {
//                         if (brandNameController.text.isNotEmpty) {
//                           if (categoryController.text.isNotEmpty) {
//                             if (categoryController.text !=
//                                 'Please select a category') {
//                               if (brandUrl.isNotEmpty) {
//                                 if (logoUrl.isNotEmpty) {
//                                   setState(() {
//                                     cardView = true;
//                                   });
//                                 } else {
//                                   ScaffoldMessenger.of(context)
//                                       .showSnackBar(SnackBar(
//                                     behavior: SnackBarBehavior.floating,
//                                     backgroundColor: const Color(0xFFEEEEEE),
//                                     elevation: 0,
//                                     duration:
//                                         const Duration(milliseconds: 1500),
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(24)),
//                                     content: const Text(
//                                       'Please upload the logo image',
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(color: Colors.black),
//                                     ),
//                                     margin: const EdgeInsets.all(120),
//                                   ));
//                                 }
//                               } else {
//                                 ScaffoldMessenger.of(context)
//                                     .showSnackBar(SnackBar(
//                                   behavior: SnackBarBehavior.floating,
//                                   backgroundColor: const Color(0xFFEEEEEE),
//                                   elevation: 0,
//                                   duration: const Duration(milliseconds: 1500),
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(24)),
//                                   content: const Text(
//                                     'Please upload the brand image',
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(color: Colors.black),
//                                   ),
//                                   margin: const EdgeInsets.all(120),
//                                 ));
//                               }
//                             } else {
//                               ScaffoldMessenger.of(context)
//                                   .showSnackBar(SnackBar(
//                                 behavior: SnackBarBehavior.floating,
//                                 backgroundColor: const Color(0xFFEEEEEE),
//                                 elevation: 0,
//                                 duration: const Duration(milliseconds: 1500),
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(24)),
//                                 content: const Text(
//                                   'Please select the category',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(color: Colors.black),
//                                 ),
//                                 margin: const EdgeInsets.all(120),
//                               ));
//                             }
//                           } else {
//                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                               behavior: SnackBarBehavior.floating,
//                               backgroundColor: const Color(0xFFEEEEEE),
//                               elevation: 0,
//                               duration: const Duration(milliseconds: 1500),
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(24)),
//                               content: const Text(
//                                 'Please enter your category',
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(color: Colors.black),
//                               ),
//                               margin: const EdgeInsets.all(120),
//                             ));
//                           }
//                         } else {
//                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                             behavior: SnackBarBehavior.floating,
//                             backgroundColor: const Color(0xFFEEEEEE),
//                             elevation: 0,
//                             duration: const Duration(milliseconds: 1500),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(24)),
//                             content: const Text(
//                               'Please enter your brand name',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(color: Colors.black),
//                             ),
//                             margin: const EdgeInsets.all(120),
//                           ));
//                         }
//                       },
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20)),
//                       title: const Center(
//                           child: Text(
//                         "Next",
//                         style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w500,
//                             color: Color(0xffFFFFFF)),
//                       )),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           : SizedBox(
//               height: 85.h,
//               width: double.infinity,
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding:
//                           const EdgeInsets.only(right: 10, left: 20, top: 20),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Select any card:",
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 15,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           Text(
//                             "Select any of the card below to replicate the properties\nfor your own brand card",
//                             style: TextStyle(fontSize: 11, color: Colors.black),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Center(
//                       child: normLoading
//                           ? Center(child: CircularProgressIndicator.adaptive())
//                           : FanCarouselImageSlider(
//                               imagesLink: brandCardDataDirectList,
//                               isAssets: false,
//                               autoPlay: false,
//                               showIndicator: false,
//                               sliderHeight: 465,
//                               imageRadius: 20,
//                               isClickable: false,
//                               currentItemShadow: const [
//                                 BoxShadow(
//                                     offset: Offset(1, 1),
//                                     color: Colors.white,
//                                     blurRadius: 10),
//                                 BoxShadow(
//                                     offset: Offset(-1, -1),
//                                     color: Colors.white,
//                                     blurRadius: 10),
//                               ],
//                             ),
//                     ),
//                     Container(height: 15.h),
//                     Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 30),
//                       decoration: BoxDecoration(
//                           gradient: const LinearGradient(
//                               begin: Alignment.centerLeft,
//                               end: Alignment.bottomCenter,
//                               colors: [
//                                 Color(0xff7A14AB),
//                                 Color(0xffAC0D86),
//                               ]),
//                           borderRadius: BorderRadius.circular(20)),
//                       child: ListTile(
//                         onTap: () async {
//                           if (submitLoading == false) {
//                             setState(() {
//                               submitLoading = true;
//                             });
//                             await createNewCard();
//                           }
//                         },
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20)),
//                         title: Center(
//                             child: submitLoading
//                                 ? CircularProgressIndicator(
//                                     color: Colors.white,
//                                   )
//                                 : Text(
//                                     "Submit",
//                                     style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w500,
//                                         color: Color(0xffFFFFFF)),
//                                   )),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }
