// import 'package:local_auth/local_auth.dart';
// import 'package:local_auth_android/local_auth_android.dart';
// import 'package:local_auth_ios/local_auth_ios.dart';
//
// class LocalAuth {
//   static final auth = LocalAuthentication();
//
//   static Future<bool> canAuthenticate() async =>
//       await auth.canCheckBiometrics || await auth.isDeviceSupported();
//
//   static Future<bool> authenticate() async {
//     try {
//       if (!await canAuthenticate()) return false;
//
//       return auth.authenticate(
//           localizedReason: "Use face id to authenticate",
//           authMessages: [IOSAuthMessages(), AndroidAuthMessages()],
//           options: const AuthenticationOptions(
//               useErrorDialogs: true, stickyAuth: true));
//     } catch (e) {
//       return false;
//     }
//   }
// }
