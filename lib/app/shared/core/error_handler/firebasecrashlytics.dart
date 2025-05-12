// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
//
// class FirebaseCrashLogs {
//   static FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;
//
// //To log fatel erros
//   static Future logFatelError(
//       {required error, required stackTrace, String? reason}) async {
//     crashlytics.recordError(error, stackTrace, reason: reason, fatal: true);
//   }
//
//   //To log custom messages
//
//   static logMessage(String message) {
//     crashlytics.log(message);
//   }
//
//   //To get logged userid
//
//   static loggedUserId(String userId) {
//     crashlytics.setUserIdentifier(userId);
//   }
// }
