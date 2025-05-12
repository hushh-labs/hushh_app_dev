// import 'dart:convert';
// import 'dart:typed_data';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:encrypt/encrypt.dart' as Encrypt;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// // import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/gradientLinearProgressIndicator.dart';
// import 'package:hushh_app/app/platforms/mobile/chat/presentation/pages/Chat/chat_window/chat_window_model.dart';
// import 'package:hushh_app/app/platforms/mobile/home/presentation/pages/home.dart';
// import 'package:hushh_app/app/shared/config/constants/colors.dart';
// import 'package:hushh_app/app/shared/config/constants/constants.dart';
// import 'package:hushh_app/app/shared/config/routes/routes.dart';
// import 'package:hushh_app/app/shared/core/local_storage/DbFunctions.dart';
// import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
// import 'package:intl/intl.dart';
// import 'package:lottie/lottie.dart';
//
// class BackupView extends StatefulWidget {
//   @override
//   State<BackupView> createState() => _BackupViewState();
// }
//
// class _BackupViewState extends State<BackupView> {
//   FirebaseFirestore fireStore = FirebaseFirestore.instance;
//   FirebaseAuth auth = FirebaseAuth.instance;
//   int messageCountForBackup = 0;
//   int chatsCountForBackup = 0;
//   bool startBackup = false;
//   bool checkingForBackup = true;
//   int currentLoop = 0;
//
//   restoreBackup() async {
//     setState(() {
//       startBackup = true;
//     });
//     await fireStore
//         .collection("HushRoom")
//         .where("user", arrayContainsAny: [LocalStorage.currentUserUid])
//         .where("firstMessageStatus", isEqualTo: 1)
//         .get()
//         .then((data) {
//           for (int i = 0; i <= data.docs.length; i++) {
//             setState(() {
//               currentLoop = i;
//             });
//             if (i < data.docs.length) {
//               fireStore
//                   .collection("message")
//                   .where("conversationID",
//                       isEqualTo: data.docs[i]['conversationID'])
//                   .orderBy("messageTime", descending: true)
//                   .where("type", isEqualTo: 1)
//                   .get()
//                   .then((data) {
//                 for (int i = 0; i < data.docs.length; i++) {
//                   final Encrypt.Encrypter encrypter = Encrypt.Encrypter(
//                     Encrypt.AES(Encrypt.Key.fromUtf8(Constants.encryptionKey),
//                         mode: Encrypt.AESMode.cbc),
//                   );
//                   final String decrypted = encrypter.decrypt64(
//                     "${data.docs[i]['payLoad']}",
//                     iv: Encrypt.IV(
//                         utf8.encode(Constants.encryptionKey) as Uint8List),
//                   );
//                   DatabaseHandler().insertMessage(Message(
//                     message_date: DateFormat('yyyy-MM-dd').format(
//                         DateTime.fromMicrosecondsSinceEpoch(
//                             data.docs[i]['messageTime'])),
//                     messageId: data.docs[i]['messageId'].toString(),
//                     payLoad: decrypted,
//                     tagName: data.docs[i]['tagName'],
//                     tagMessage: data.docs[i]['tagMessage'],
//                     sender: data.docs[i]['from'],
//                     senderName: data.docs[i]['senderName'],
//                     status: 3,
//                     messageStatus: 1,
//                     tagMessageUid: data.docs[i]['tagMessageUid'] ?? '',
//                     imagePath: data.docs[i]['img_path'],
//                     imageThumbnail: data.docs[i]['thumb_nail'],
//                     messageTime: data.docs[i]['messageTime'],
//                     type: data.docs[i]['type'],
//                     conversationID: data.docs[i]['conversationID'],
//                     receiver: data.docs[i]['to'],
//                     imageHeight: '',
//                     imageWidth: '',
//                     progress: 0,
//                     cloudStatus: '',
//                   ));
//                 }
//                 if (mounted)
//                   setState(() {
//                     startBackup = false;
//                   });
//               });
//             }
//           }
//           Navigator.pushReplacementNamed(context, AppRoutes.home,
//               arguments: HomePageArgs(tabValue: 1));
//         });
//   }
//
//   findBackup() async {
//     setState(() {
//       checkingForBackup = true;
//     });
//     await fireStore
//         .collection("HushRoom")
//         .where("user", arrayContainsAny: [LocalStorage.currentUserUid])
//         .where("firstMessageStatus", isEqualTo: 1)
//         .get()
//         .then((data) {
//           for (int i = 0; i < data.docs.length; i++) {
//             setState(() {
//               chatsCountForBackup = data.docs.length;
//             });
//             fireStore
//                 .collection("message")
//                 .where("conversationID",
//                     isEqualTo: data.docs[i]['conversationID'])
//                 .orderBy("messageTime", descending: true)
//                 .where("type", isEqualTo: 1)
//                 .get()
//                 .then((data) {
//               setState(() {
//                 checkingForBackup = false;
//                 messageCountForBackup =
//                     messageCountForBackup + data.docs.length;
//               });
//             });
//           }
//         });
//   }
//
//   cancelRestore() async {
//     await fireStore
//         .collection("HushRoom")
//         .where("user", arrayContainsAny: [LocalStorage.currentUserUid])
//         .where("firstMessageStatus", isEqualTo: 1)
//         .get()
//         .then((data) {
//           for (int i = 0; i <= data.docs.length; i++) {
//             if (i < data.docs.length) {
//               fireStore
//                   .collection("message")
//                   .where("conversationID",
//                       isEqualTo: data.docs[i]['conversationID'])
//                   .get()
//                   .then((data) {
//                 data.docs.forEach((doc) {
//                   doc.reference.delete();
//                 });
//               });
//             }
//           }
//         });
//     await fireStore
//         .collection("HushRoom")
//         .where("user", arrayContainsAny: [LocalStorage.currentUserUid])
//         .where("firstMessageStatus", isEqualTo: 1)
//         .get()
//         .then((data) {
//           data.docs.forEach((doc) {
//             doc.reference.delete();
//           });
//         });
//     Navigator.pushReplacementNamed(context, AppRoutes.home,
//         arguments: HomePageArgs(tabValue: 1));
//   }
//
//   @override
//   void initState() {
//     findBackup();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: Get.width,
//         height: Get.height,
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Lottie.asset('assets/restore.json'),
//               Text(
//                 "Checking for\nchat backup restore",
//                 style: TextStyle(fontSize: 13, color: const Color(0xff181941)),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               checkingForBackup
//                   ? SizedBox(
//                       width: 10,
//                       height: 10,
//                       child: CircularProgressIndicator(
//                         color: CustomColors.projectBaseBlue,
//                         strokeWidth: 3,
//                       ),
//                     )
//                   : Text(
//                       "We found $chatsCountForBackup chat and $messageCountForBackup messages\nto restore from free backup",
//                       style: TextStyle(
//                           fontSize: 13, color: const Color(0xff181941)),
//                       textAlign: TextAlign.center,
//                     ),
//               SizedBox(
//                 height: 20,
//               ),
//               GradientLinearProgressIndicator(
//                 backgroundColor: Colors.transparent,
//                 value: currentLoop == 0 ? 0 : currentLoop / chatsCountForBackup,
//                 gradient: const LinearGradient(
//                   begin: Alignment.topRight,
//                   end: Alignment.bottomLeft,
//                   colors: [
//                     CustomColors.privateGradientSecondary,
//                     CustomColors.privateGradientPrimary,
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   startBackup
//                       ? Container(
//                           width: Get.height / 20.3,
//                           height: Get.height / 20.3,
//                           decoration: BoxDecoration(
//                             gradient: const LinearGradient(
//                               begin: Alignment.topRight,
//                               end: Alignment.bottomLeft,
//                               colors: [
//                                 CustomColors.privateGradientSecondary,
//                                 CustomColors.privateGradientPrimary,
//                               ],
//                             ),
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           child: const Center(
//                             child: Padding(
//                               padding: EdgeInsets.all(5),
//                               child: CircularProgressIndicator(
//                                 color: Colors.white,
//                                 strokeWidth: 3,
//                               ),
//                             ),
//                           ),
//                         )
//                       : InkWell(
//                           onTap: () {
//                             restoreBackup();
//                           },
//                           child: Container(
//                             width: Get.width / 2.5,
//                             height: Get.height / 20.3,
//                             decoration: BoxDecoration(
//                               gradient: const LinearGradient(
//                                 begin: Alignment.topRight,
//                                 end: Alignment.bottomLeft,
//                                 colors: [
//                                   CustomColors.privateGradientSecondary,
//                                   CustomColors.privateGradientPrimary,
//                                 ],
//                               ),
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                             child: const Center(
//                               child: Text(
//                                 "Restore",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.white,
//                                     fontSize: 14),
//                               ),
//                             ),
//                           ),
//                         ),
//                   InkWell(
//                     onTap: () {
//                       showDialog(
//                           context: context,
//                           // barrierColor: Colors.transparent,
//                           // Color(0x00ffffff),
//                           builder: (BuildContext context) {
//                             return AlertDialog(
//                               // backgroundColor: Colors.transparent,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(20)),
//                               content: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   const Text(
//                                     'Are you sure to cancel restore ?',
//                                     style: TextStyle(
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.w500,
//                                         color: Color(0xff181941)),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                   const Text(
//                                     'You will end up losing chat histories. There will be no option provided to restore it back!',
//                                     style: TextStyle(
//                                         fontSize: 12, color: Color(0xff181941)),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ],
//                               ),
//                               actions: <Widget>[
//                                 ElevatedButton(
//                                     onPressed: () {
//                                       Navigator.pop(context);
//                                     },
//                                     style: ElevatedButton.styleFrom(
//                                         foregroundColor:
//                                             const Color(0xff7F7F97),
//                                         backgroundColor:
//                                             const Color(0xffEBEBF7),
//                                         minimumSize: Size(Get.width / 6.03,
//                                             Get.height / 21.36),
//                                         shape: RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(30))
//                                         // onPrimary:Color(0xffEA4841),
//                                         ),
//                                     child: const Text("Back")),
//                                 const SizedBox(width: 10),
//                                 Padding(
//                                   padding: const EdgeInsets.only(right: 8.0),
//                                   child: ElevatedButton(
//                                       onPressed: () async {
//                                         setState(() {
//                                           checkingForBackup = true;
//                                           Navigator.pop(context);
//                                         });
//                                         cancelRestore();
//                                       },
//                                       style: ElevatedButton.styleFrom(
//                                           foregroundColor:
//                                               const Color(0xff7FFFFFF),
//                                           backgroundColor:
//                                               const Color(0xffEA4841),
//                                           minimumSize: Size(Get.width / 2.58,
//                                               Get.height / 21.36),
//                                           shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(30))
//                                           // onPrimary:Color(0xffEA4841),
//                                           ),
//                                       child: const Text('Cancel restore')),
//                                 ),
//                               ],
//                             );
//                           });
//                     },
//                     child: Container(
//                       width: Get.width / 2.5,
//                       height: Get.height / 20.3,
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                           begin: Alignment.topRight,
//                           end: Alignment.bottomLeft,
//                           colors: [
//                             CustomColors.privateGradientSecondary,
//                             CustomColors.privateGradientPrimary,
//                           ],
//                         ),
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       child: const Center(
//                         child: Text(
//                           "Cancel",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               color: Colors.white,
//                               fontSize: 14),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
