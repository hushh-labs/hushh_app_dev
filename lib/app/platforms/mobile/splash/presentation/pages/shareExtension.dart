// import 'dart:async';
// import 'dart:collection';
// import 'dart:developer';
//
// import 'package:azlistview/azlistview.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:contacts_service/contacts_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:flutter/material.dart';
// import 'package:flutter_sharing_intent/model/sharing_file.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:hushh_app/app/platforms/mobile/chat/presentation/pages/Chat/chat_history/chat_history_model.dart';
// import 'package:hushh_app/app/platforms/mobile/chat/presentation/pages/Chat/chat_window/chat_window_model.dart';
// import 'package:hushh_app/app/platforms/mobile/home/presentation/pages/home.dart';
// import 'package:hushh_app/app/shared/config/assets/icon.dart';
// import 'package:hushh_app/app/shared/config/constants/colors.dart';
// import 'package:hushh_app/app/shared/config/routes/routes.dart';
// import 'package:hushh_app/app/shared/core/components/loadingoverlay.dart';
// import 'package:hushh_app/app/shared/core/error_handler/firebasecrashlytics.dart';
// import 'package:hushh_app/app/shared/core/local_storage/DbFunctions.dart';
// import 'package:hushh_app/app/shared/core/local_storage/commonutils.dart';
// import 'package:hushh_app/app/shared/core/local_storage/creating_directory.dart';
// import 'package:hushh_app/app/shared/core/local_storage/local_storage_util_keys.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
//
// class ShareExtension extends StatefulWidget {
//   const ShareExtension({Key? key}) : super(key: key);
//
//   @override
//   State<ShareExtension> createState() => _ShareExtensionState();
// }
//
// class _ShareExtensionState extends State<ShareExtension> {
//   late double width;
//   late double height;
//   late Box Caontactbox;
//   bool loading = false;
//   var modified_phone;
//   final RegExp _regExp = RegExp('[^+0-9]');
//   ItemScrollController itemScrollController = ItemScrollController();
//   ItemScrollController itemScrollController1 = ItemScrollController();
//   firebase_storage.FirebaseStorage storageInc =
//       firebase_storage.FirebaseStorage.instanceFor(
//           bucket: "gs://hushone-app.appspot.com");
//   List<AlphabetSearch> dataList = [];
//   List<AlphabetSearch> _rampValues = [];
//   List<int> finalSelectedListindex = [];
//   List finalSelectedList = [];
//   bool circular = false;
//   bool changingCheckbox = false;
//   List<AlphabetSearch> originList = [];
//   var currentUser;
//   List githubLanguageColors = [];
//   List<dynamic> getRegisteredcontacts = [];
//   bool showLoading = false;
//   final fireStore = FirebaseFirestore.instance;
//   bool buttonLoad = false;
//   String avatarUrl = '';
//   String currentUserId = '';
//   double _progress = 0;
//   late DatabaseHandler handler;
//   final auth = FirebaseAuth.instance;
//   List<String> listOfData = [];
//   bool uploading = false;
//   String fileType = '';
//   String url_thumbnail = '';
//   String finalExtensionType = '';
//   List<Message> messageForwardList = [];
//
//   List<AlphabetSearchModel> newService() {
//     githubLanguageColors = getRegisteredcontacts;
//     List<AlphabetSearchModel> list = githubLanguageColors
//         .map((v) => AlphabetSearchModel.fromJson(v))
//         .toList();
//     return list;
//   }
//
//   Future<bool> onWillPop() async {
//     Navigator.pushNamed(context, AppRoutes.home,
//         arguments: HomePageArgs(tabValue: 0));
//     return false;
//   }
//
//   void _search(String text) {
//     try {
//       List<AlphabetSearch> list = originList.where((v) {
//         return v.contactName.toLowerCase().contains(text.toLowerCase());
//       }).toList();
//       _handleList(list);
//     } catch (e, s) {
//       FirebaseCrashLogs.logFatelError(
//           error: e,
//           stackTrace: s,
//           reason:
//               "Exception in _search Method in HushMyImage.dart ${CommonUtils.sharedPreferences.getString(LocalStorageUtilKeys.userPhoneNumber)}");
//     }
//   }
//
//   loadData() async {
//     try {
//       originList = newService().map((v) {
//         AlphabetSearch model = AlphabetSearch.fromJson(v.toJson());
//         String tag = model.contactName.substring(0, 1).toUpperCase();
//         if (RegExp("[A-Z]").hasMatch(tag)) {
//           model.tagIndex = tag;
//         } else {
//           model.tagIndex = "#";
//         }
//         return model;
//       }).toList();
//       _handleList(originList);
//     } catch (e, s) {
//       FirebaseCrashLogs.logFatelError(
//           error: e,
//           stackTrace: s,
//           reason:
//               "Exception in _search Method in HushMyImage.dart ${CommonUtils.sharedPreferences.getString(LocalStorageUtilKeys.userPhoneNumber)}");
//     }
//   }
//
//   permissionHandler() async {
//     try {
//       setState(() {
//         currentUser = CommonUtils.sharedPreferences
//             .getString(LocalStorageUtilKeys.userPhoneNumber);
//       });
//       if (appDir.imageDirectory.isEmpty) {
//         appDir.creatingDirectory();
//       }
//       final PermissionStatus permissionStatus =
//           await Permission.contacts.status;
//       if (permissionStatus == PermissionStatus.granted) {
//         Contactbox = await Hive.openBox('contactList');
//         if (Contactbox.values.isNotEmpty) {
//           if (Contactbox.get('hushRegisteredNumberList') == null) {
//             setState(() {
//               showLoading = true;
//             });
//           } else {
//             getRegisteredcontacts =
//                 await Contactbox.get('hushRegisteredNumberList');
//           }
//
//           if (getRegisteredcontacts.isNotEmpty &&
//               Contactbox.get('hushRegisteredNumberList') != null) {
//             setState(() {
//               showLoading = true;
//             });
//             await loadData();
//           } else {
//             // checkdatabase();
//             testContact();
//           }
//         } else {
//           //  checkdatabase();
//           testContact();
//         }
//       }
//     } catch (e, s) {
//       FirebaseCrashLogs.logFatelError(
//           error: e,
//           stackTrace: s,
//           reason:
//               "Exception in _search Method in HushMyImage.dart ${CommonUtils.sharedPreferences.getString(LocalStorageUtilKeys.userPhoneNumber)}");
//     }
//   }
//
//   testContact() async {
//     try {
//       Contactbox = await Hive.openBox('contactList');
//       List finalContacts = [];
//       var sameUser = CommonUtils.sharedPreferences
//           .getString(LocalStorageUtilKeys.userPhoneNumber);
//       final permissionStatus = await Permission.contacts.request();
//       if (permissionStatus == PermissionStatus.granted) {
//         dynamic nonRegisteredhushuser = await Contactbox.get('phonenumberList');
//         dynamic registeredhushUser =
//             await Contactbox.get('hushRegisteredNumberList');
//         if (nonRegisteredhushuser == null && registeredhushUser == null) {
//           List hushRegisteredNumber = [];
//           List phoneContactNumber = [];
//           var finalNumber;
//           var globalCountryCode = CommonUtils.sharedPreferences
//               .getString(LocalStorageUtilKeys.globalCountryCode);
//           List<Contact> service = await ContactsService.getContacts(
//             withThumbnails: false,
//             androidLocalizedLabels: false,
//             iOSLocalizedLabels: false,
//             orderByGivenName: false,
//             photoHighResolution: false,
//           );
//           if (service.isNotEmpty) {
//             service.forEach((element) async {
//               element.phones!.forEach((phonelement) async {
//                 if (phonelement.value!.isNotEmpty) {
//                   modified_phone = phonelement.value!.replaceAll(_regExp, "");
//                   var check = modified_phone.contains("+");
//                   if (check == true) {
//                     finalNumber = modified_phone;
//                   } else {
//                     var step1 = modified_phone.substring(0, 1);
//                     if (step1 == "0" || step1 == 0) {
//                       final replaced = modified_phone.replaceFirst(
//                           RegExp('0'), globalCountryCode.toString()); //
//                       finalNumber = replaced;
//                     } else {
//                       finalNumber = '$globalCountryCode$modified_phone';
//                     }
//                   }
//                   if (finalNumber != sameUser) {
//                     if (!finalContacts.contains(finalNumber)) {
//                       finalContacts.add(finalNumber);
//                       if (element.phones!.isNotEmpty) {
//                         await fireStore
//                             .collection("HushUsers")
//                             .where("phoneNumber", isEqualTo: finalNumber)
//                             .get()
//                             .then((datas) {
//                           if (datas.docs.isEmpty) {
//                             phoneContactNumber.add({
//                               'phoneNumber': phonelement.value,
//                               'name': element.displayName
//                             });
//                             Contactbox.put(
//                                 'phonenumberList', phoneContactNumber);
//                           } else {
//                             hushRegisteredNumber.add({
//                               'phoneNumber': datas.docs[0]['phoneNumber'],
//                               'contactPhoneNumber': phonelement.value,
//                               'contactName': element.displayName,
//                               'name': datas.docs[0]['name'],
//                               'avatar': datas.docs[0]['avatar'],
//                               'uid': datas.docs[0]['uid']
//                             });
//                             Contactbox.put('hushRegisteredNumberList',
//                                 hushRegisteredNumber);
//                           }
//                         });
//                       }
//                     } else {}
//                   } else {}
//                   List<String> removedplicates =
//                       LinkedHashSet<String>.from(finalContacts).toList();
//                   List<dynamic> nonregisterdhush =
//                       await Contactbox.get('phonenumberList');
//                   List<dynamic> registerdhush =
//                       await Contactbox.get('hushRegisteredNumberList');
//
//                   if (nonregisterdhush.length + registerdhush.length ==
//                       removedplicates.length) {
//                     setState(() {
//                       CommonUtils.sharedPreferences
//                           .setBool(LocalStorageUtilKeys.firstTimeLoad, false);
//
//                       permissionHandler();
//                       showLoading = true;
//                     });
//                   } else {
//                     setState(() {
//                       showLoading = false;
//                     });
//                   }
//                 }
//               });
//             });
//           } else {
//             setState(() {
//               showLoading = true;
//             });
//           }
//         } else {
//           setState(() {
//             showLoading = true;
//           });
//           List hushRegisteredNumber = [];
//           List phoneContactNumber = [];
//           var finalNumber;
//           var globalCountryCode = CommonUtils.sharedPreferences
//               .getString(LocalStorageUtilKeys.globalCountryCode);
//
//           List<Contact> service = await ContactsService.getContacts(
//             withThumbnails: false,
//             androidLocalizedLabels: false,
//             iOSLocalizedLabels: false,
//             orderByGivenName: false,
//             photoHighResolution: false,
//           );
//           service.forEach((element) async {
//             element.phones!.forEach((phonelement) async {
//               if (phonelement.value!.isNotEmpty) {
//                 modified_phone = phonelement.value!.replaceAll(_regExp, "");
//                 var check = modified_phone.contains("+");
//                 if (check == true) {
//                   finalNumber = modified_phone;
//                 } else {
//                   var step1 = modified_phone.substring(0, 1);
//                   if (step1 == "0" || step1 == 0) {
//                     final replaced = modified_phone.replaceFirst(
//                         RegExp('0'), globalCountryCode.toString()); //
//                     finalNumber = replaced;
//                   } else {
//                     finalNumber = '$globalCountryCode$modified_phone';
//                   }
//                 }
//                 if (finalNumber != sameUser) {
//                   if (!finalContacts.contains(finalNumber)) {
//                     finalContacts.add(finalNumber);
//                     if (element.phones!.isNotEmpty) {
//                       await fireStore
//                           .collection("HushUsers")
//                           .where("phoneNumber", isEqualTo: finalNumber)
//                           .get()
//                           .then((datas) {
//                         if (datas.docs.isEmpty) {
//                           phoneContactNumber.add({
//                             'phoneNumber': phonelement.value,
//                             'name': element.displayName
//                           });
//                           Contactbox.put('phonenumberList', phoneContactNumber);
//                         } else {
//                           hushRegisteredNumber.add({
//                             'phoneNumber': datas.docs[0]['phoneNumber'],
//                             'contactPhoneNumber': phonelement.value,
//                             'contactName': element.displayName,
//                             'name': datas.docs[0]['name'],
//                             'avatar': datas.docs[0]['avatar'],
//                             'uid': datas.docs[0]['uid']
//                           });
//                           Contactbox.put(
//                               'hushRegisteredNumberList', hushRegisteredNumber);
//                         }
//                       });
//                     }
//                   } else {}
//                 } else {}
//                 List<String> removedplicates =
//                     LinkedHashSet<String>.from(finalContacts).toList();
//                 List<dynamic> nonregisterdhush =
//                     await Contactbox.get('phonenumberList');
//                 List<dynamic> registerdhush =
//                     await Contactbox.get('hushRegisteredNumberList');
//                 if (nonregisterdhush.length + registerdhush.length ==
//                     removedplicates.length) {
//                   setState(() {
//                     CommonUtils.sharedPreferences
//                         .setBool(LocalStorageUtilKeys.firstTimeLoad, false);
//
//                     permissionHandler();
//                     showLoading = true;
//                   });
//                 } else {
//                   setState(() {
//                     showLoading = false;
//                   });
//                 }
//               }
//             });
//           });
//         }
//       }
//     } catch (e, s) {
//       FirebaseCrashLogs.logFatelError(
//           error: e,
//           stackTrace: s,
//           reason:
//               "Exception in _search Method in HushMyImage.dart${CommonUtils.sharedPreferences.getString(LocalStorageUtilKeys.userPhoneNumber)}");
//     }
//   }
//
//   void _handleList(List<AlphabetSearch> list) {
//     try {
//       _rampValues.clear();
//       // finalSelectedList.clear();
//       dataList.clear();
//       setState(() {
//         loading = true;
//         dataList.addAll(list);
//       });
//       // dataList.addAll(list);
//       log(dataList.toString());
//       // A-Z sort.
//       SuspensionUtil.sortListBySuspensionTag(dataList);
//       // show sus tag.
//       SuspensionUtil.setShowSuspensionStatus(dataList);
//       setState(() {
//         if (list.length == dataList.length) {
//           loading = false;
//         }
//       });
//       if (itemScrollController.isAttached) {
//         itemScrollController.jumpTo(index: 0);
//       }
//       if (itemScrollController1.isAttached) {
//         itemScrollController1.jumpTo(index: 0);
//       }
//     } catch (e, s) {
//       FirebaseCrashLogs.logFatelError(
//           error: e,
//           stackTrace: s,
//           reason:
//               "Exception in _search Method in HushMyImage.dart ${CommonUtils.sharedPreferences.getString(LocalStorageUtilKeys.userPhoneNumber)}");
//     }
//   }
//
//   Widget getListItemTest(BuildContext context, AlphabetSearch model, int index,
//       StateSetter setStater,
//       {double susHeight = 40}) {
//     _rampValues.add(model);
//     return StatefulBuilder(
//       builder: (BuildContext context, StateSetter modelsetState) {
//         // WidgetsBinding.instance!.addPostFrameCallback((_) {});
//         return GestureDetector(
//           onTap: () {},
//           child: Container(
//             decoration: const BoxDecoration(
//                 color: Colors.transparent,
//                 border: Border(
//                     bottom: BorderSide(color: Color(0xffebebf7), width: 1))),
//             height: height / 11.1,
//             width: MediaQuery.of(context).size.width,
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Theme(
//                   data: ThemeData(
//                     unselectedWidgetColor: const Color(0xff616180),
//                   ),
//                   child: Checkbox(
//                     checkColor: CustomColors.whiteColor,
//                     side: MaterialStateBorderSide.resolveWith(
//                       (states) => const BorderSide(
//                           width: 2.0, color: Color(0xff616180)),
//                     ),
//                     fillColor: MaterialStateProperty.resolveWith(
//                         (_) => CustomColors.projectBaseBlue),
//                     shape: const CircleBorder(),
//                     onChanged: (value) {
//                       modelsetState(() {
//                         changingCheckbox = value!;
//                         if (changingCheckbox == false) {
//                           modelsetState(() {
//                             if (finalSelectedListindex.contains(index)) {
//                               finalSelectedListindex.remove(index);
//                               for (int i = 0;
//                                   i < finalSelectedList.length;
//                                   i++) {
//                                 if (finalSelectedList[i].phonenumber ==
//                                     dataList[index].phonenumber) {
//                                   finalSelectedList.removeAt(i);
//                                   setStater(() {
//                                     circular = true;
//                                   });
//                                 }
//                               }
//                               setStater(() {
//                                 circular = true;
//                                 changingCheckbox = true;
//                               });
//                             }
//                           });
//                         } else {
//                           finalSelectedList.add(_rampValues[index]);
//                           finalSelectedListindex.add(index);
//                           setStater(() {
//                             circular = true;
//                           });
//                         }
//                       });
//                       if (finalSelectedList.isEmpty) {
//                         setStater(() {
//                           circular = false;
//                         });
//                       }
//
//                       // field.didChange(field.value);
//                     },
//                     value: finalSelectedListindex.contains(index)
//                         ? changingCheckbox
//                         : false,
//                   ),
//                 ),
//
//                 /*GestureDetector(
//                   onTap: (){
//                     modelsetState((){
//                       _dot=!_dot;
//                     });
//                   },
//                   child: Container(
//                   height: 20,
//                     width: 20,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.transparent,
//                       border: Border.all(color: Colors.black,width: 2)
//                     ),
//                     child: _dot?Center(child: Text(".", style: TextStyle(fontSize: 50),),):SizedBox(),
//                   ),
//                 ),*/
//                 SizedBox(
//                   width: width / 46.8,
//                 ),
//                 Container(
//                   child: CircleAvatar(
//                     radius: 20.0,
//                     child: ClipOval(
//                       child: SizedBox.fromSize(
//                         size: const Size.fromRadius(20),
//                         child: Image.network(
//                           model.avatar,
//                           fit: BoxFit.fill,
//                           errorBuilder: (context, url, error) {
//                             return Image.asset('assets/user.png');
//                           },
//                         ),
//                       ),
//                     ),
//                     backgroundColor: Colors.transparent,
//                   ),
//                 ),
//                 SizedBox(
//                   width: width / 46.8,
//                 ),
//                 Text(
//                   model.contactName,
//                   style: const TextStyle(
//                     color: Color(0xff181941),
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget getListItem(BuildContext context, AlphabetSearch model, int index,
//       {double susHeight = 40}) {
//     return GestureDetector(
//       onTap: () {
//         chatInitiation(model.phonenumber, model.contactName, index, model.uid,
//             model.avatar);
//       },
//       child: Container(
//         decoration: const BoxDecoration(
//             color: Colors.transparent,
//             border:
//                 Border(bottom: BorderSide(color: Color(0xffebebf7), width: 1))),
//         height: height / 11.1,
//         width: MediaQuery.of(context).size.width,
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(
//               child: CircleAvatar(
//                 radius: 20.0,
//                 child: ClipOval(
//                   child: SizedBox.fromSize(
//                     size: const Size.fromRadius(20),
//                     child: Image.network(
//                       model.avatar,
//                       fit: BoxFit.fill,
//                       errorBuilder: (context, url, error) {
//                         return Image.asset('assets/user.png');
//                       },
//                     ),
//                   ),
//                 ),
//                 backgroundColor: Colors.transparent,
//               ),
//             ),
//             SizedBox(
//               width: width / 46.8,
//             ),
//             Text(
//               model.contactName,
//               style: const TextStyle(
//                 color: Color(0xff181941),
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget getSusItem(BuildContext context, String tag, {double susHeight = 30}) {
//     return Container(
//       height: susHeight,
//       width: MediaQuery.of(context).size.width,
//       padding: const EdgeInsets.only(left: 16.0),
//       color: const Color(0xffEBEBF7),
//       alignment: Alignment.centerLeft,
//       child: Text(
//         tag,
//         softWrap: false,
//         style: const TextStyle(
//           fontSize: 14.0,
//           fontWeight: FontWeight.w500,
//           color: Color(0xFF181941),
//         ),
//       ),
//     );
//   }
//
//   docParse() async {
//     User loggedUser = auth.currentUser!;
//     setState(() {
//       currentUserId = loggeduser.hushhId;
//     });
//     /*for (int i = 0; i < widget.file.length; i++) {
//       int messageidlocal = DateTime.now().microsecondsSinceEpoch;
//       var types = lookupMimeType(widget.file[i].type);
//       if (types == null) {
//         await Future.delayed(const Duration(seconds: 1));
//         return showDialog(
//             context: context,
//             // barrierColor: Colors.transparent,
//             // Color(0x00ffffff),
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 // backgroundColor: Colors.transparent,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20)),
//                 content: const Text(
//                   'Format not supported',
//                   style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w500,
//                       color: Color(0xff181941)),
//                   textAlign: TextAlign.center,
//                 ),
//                 actions: <Widget>[
//                   ElevatedButton(
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                       style: ElevatedButton.styleFrom(
//                           primary: const Color(0xffEBEBF7),
//                           onPrimary: const Color(0xff7F7F97),
//                           minimumSize: Size(
//                               MediaQuery.of(context).size.width / 6.03,
//                               MediaQuery.of(context).size.height / 21.36),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30))
//                           // onPrimary:Color(0xffEA4841),
//                           ),
//                       child: const Text("Cancel")),
//                 ],
//               );
//             });
//       } else {
//         var splittedTypes = types.toString().split('/');
//         if (splittedTypes[1] == 'pdf') {
//           setState(() {
//             fileType = 'pdf';
//             finalExtensionType = splittedTypes[1];
//           });
//         } else if (splittedTypes[0] == 'image') {
//           setState(() {
//             fileType = 'image';
//             finalExtensionType = splittedTypes[1];
//           });
//           await File(widget.file[i].thumbnail).copy(
//               "${appDir.imageSentDirectory}/$messageidlocal.$finalExtensionType");
//           await File(widget.file[i].path).copy(
//               "${appDir.thumbnailDirectory}/$messageidlocal.$finalExtensionType");
//           var decodedImage = await decodeImageFromList(
//               File(widget.file[i].path).readAsBytesSync());
//           messageForwardList.add(Message(
//               tagName: '',
//               message_date: messageidlocal.toString(),
//               receiver: '',
//               conversationID: '',
//               senderName: '',
//               imageThumbnail: widget.file[i].path,
//               imageWidth: decodedImage.width.toString(),
//               imageHeight: decodedImage.height.toString(),
//               messageTime: messageidlocal,
//               type: 2,
//               imagePath: '',
//               messageStatus: 1,
//               status: 1,
//               tagMessage: 'intent',
//               tagMessageUid: '',
//               sender: currentUserId,
//               payLoad: "$messageidlocal.$finalExtensionType",
//               messageId: messageidlocal.toString(),
//               progress: 0,
//               cloudStatus: ''));
//         } else if (splittedTypes[0] == 'video' ||
//             splittedTypes[0] == 'videos') {
//           setState(() {
//             fileType = 'video';
//             finalExtensionType = splittedTypes[1];
//           });
//           await File(widget.file[i].path).copy(
//               "${appDir.videoSentDirectory}/$messageidlocal.$finalExtensionType");
//           await File(widget.file[i].path).copy(
//               "${appDir.hushedFileDirectory}/$messageidlocal.$finalExtensionType");
//           String? value = await VideoThumbnail.thumbnailFile(
//               video: widget.file[i].path,
//               quality: 65,
//               thumbnailPath: appDir.thumbnailDirectory,
//               imageFormat: ImageFormat.PNG);
//           messageForwardList.add(Message(
//               tagName: '',
//               message_date: messageidlocal.toString(),
//               receiver: '',
//               conversationID: '',
//               senderName: '',
//               imageThumbnail: value!,
//               imageWidth: '',
//               imageHeight: '',
//               messageTime: messageidlocal,
//               type: 4,
//               imagePath: '',
//               messageStatus: 1,
//               status: 1,
//               tagMessage: '',
//               tagMessageUid: '',
//               sender: currentUserId,
//               payLoad: "$messageidlocal.$finalExtensionType",
//               messageId: messageidlocal.toString(),
//               progress: 0,
//               cloudStatus: ''));
//         } else if (splittedTypes[0] == 'audio') {
//           setState(() {
//             fileType = 'audio';
//             finalExtensionType = splittedTypes[1];
//           });
//         } else {
//           var spl = types.toString().split('.');
//           setState(() {
//             finalExtensionType = spl[spl.length - 1];
//           });
//           if (finalExtensionType == 'presentation') {
//             setState(() {
//               fileType = 'pptx';
//               finalExtensionType = 'pptx';
//             });
//           } else if (finalExtensionType == 'document') {
//             setState(() {
//               fileType = 'docx';
//               finalExtensionType = 'docx';
//             });
//           } else {
//             setState(() {
//               finalExtensionType = spl[spl.length - 1];
//             });
//           }
//         }
//       }
//     }*/
//   }
//
//   chatInitiation(
//       String number, String name, int index, String uid, String avatar) async {
//     Navigator.pushNamed(context, AppRoutes.chatWindow, arguments: {
//       'forward': 'true',
//       'avatar': avatar,
//       'conversationId': '',
//       'toUid': uid,
//       'toName': name,
//       'message': messageForwardList,
//       'userList': '',
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     handler = DatabaseHandler();
//     docParse();
//     permissionHandler();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     width = MediaQuery.of(context).size.width;
//     height = MediaQuery.of(context).size.height;
//     final List<SharedFile> file =
//         ModalRoute.of(context)!.settings.arguments! as List<SharedFile>;
//     return WillPopScope(
//       onWillPop: () async {
//         onWillPop();
//         return true;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: CustomColors.whiteColor,
//           elevation: 5,
//           titleSpacing: 10,
//           centerTitle: false,
//           automaticallyImplyLeading: false,
//           shadowColor: Colors.black12,
//           toolbarHeight: 72,
//           title: const Text(
//             "Share to",
//             style: TextStyle(color: Color(0xff2D2D53), fontSize: 28),
//           ),
//           leading: IconButton(
//             icon: SvgPicture.asset(
//               AppIcons.backArrow_narrow,
//               height: 19.5,
//               width: 16,
//               color: Colors.black,
//             ),
//             onPressed: () {
//               Navigator.pushNamed(context, AppRoutes.home,
//                   arguments: HomePageArgs(tabValue: 1));
//             },
//           ),
//         ),
//         body: ListView(
//           shrinkWrap: true,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: SizedBox(
//                 height: 40,
//                 child: TextField(
//                   autofocus: false,
//                   onChanged: (value) {
//                     setState(() {
//                       _search(value);
//                     });
//                   },
//                   style:
//                       const TextStyle(fontSize: 14.0, color: Color(0xff181941)),
//                   decoration: InputDecoration(
//                     contentPadding: EdgeInsets.zero,
//                     isDense: true,
//                     filled: true,
//                     fillColor: const Color(0xFFf5f5fd),
//                     hintText: 'Search...',
//                     hintStyle: const TextStyle(
//                       fontSize: 14.0,
//                       color: Color(0xFF7f7f97),
//                     ),
//                     prefixIcon: Padding(
//                       padding: const EdgeInsets.all(6),
//                       child: SvgPicture.asset(
//                         'assets/search_new.svg',
//                         color: const Color(0xFF616180),
//                       ),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(
//                         color: Color(0xFFf5f5fd),
//                       ),
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                     border: OutlineInputBorder(
//                       borderSide: const BorderSide(
//                         color: Color(0xFFf5f5fd),
//                       ),
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(
//                         color: Color(0xFFf5f5fd),
//                       ),
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               width: width,
//               height: height * 0.12,
//               decoration: const BoxDecoration(
//                 color: CustomColors.leftGradientprimary,
//                 borderRadius: BorderRadius.all(Radius.circular(10)),
//               ),
//               margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
//               child: Center(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Container(
//                       margin: const EdgeInsets.only(left: 20),
//                       child: Row(
//                         children: [
//                           SvgPicture.asset(
//                             'assets/image_icon.svg',
//                             color: Colors.black,
//                           ),
//                           const Padding(
//                             padding: EdgeInsets.only(left: 8.0),
//                             child: Text(
//                               'Hushh my file',
//                               style: TextStyle(
//                                   fontSize: 18, fontWeight: FontWeight.w500),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     buttonLoad == true
//                         ? Container(
//                             margin: const EdgeInsets.only(right: 20),
//                             width: 15,
//                             height: 15,
//                             child: const CircularProgressIndicator(
//                                 color: Color(0xffAC0D86)),
//                           )
//                         : GestureDetector(
//                             onTap: () {
//                               // LoadingOverlay.of(context).show();
//                               // const CommonWidgets()
//                               //     .getImageLabelManualForShareExtension(file);
//                             },
//                             child: Container(
//                               width: width * 0.20,
//                               height: height / 20.3,
//                               margin: const EdgeInsets.only(right: 20),
//                               decoration: BoxDecoration(
//                                   gradient: const LinearGradient(colors: [
//                                     Color(0xff7A14AB),
//                                     Color(0xffAC0D86),
//                                   ]),
//                                   borderRadius: BorderRadius.circular(30)),
//                               child: const Center(
//                                 child: Text(
//                                   "Start",
//                                   style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w500,
//                                       color: Colors.white),
//                                 ),
//                               ),
//                             ),
//                           ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(
//               width: width,
//               height: height * 0.60,
//               child: AzListView(
//                 itemScrollController: itemScrollController,
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 data: dataList,
//                 itemCount: dataList.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   AlphabetSearch model = dataList[index];
//                   return Container(
//                     padding: const EdgeInsets.only(right: 15, left: 15),
//                     child: getListItem(context, model, index),
//                   );
//                 },
//                 susItemBuilder: (BuildContext context, int index) {
//                   AlphabetSearch model = dataList[index];
//                   return getSusItem(context, model.getSuspensionTag());
//                 },
//                 indexBarItemHeight: 16.5,
//                 indexBarOptions: const IndexBarOptions(
//                   needRebuild: true,
//                   hapticFeedback: true,
//                   textStyle: TextStyle(fontSize: 10, color: Color(0xff7f7f97)),
//                   selectTextStyle: TextStyle(
//                       fontSize: 10,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w500),
//                   selectItemDecoration: BoxDecoration(
//                       shape: BoxShape.circle, color: Color(0xFF333333)),
//                   indexHintAlignment: Alignment.centerRight,
//                   indexHintTextStyle:
//                       TextStyle(fontSize: 24.0, color: Colors.white),
//                   indexHintOffset: Offset(-30, 0),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
