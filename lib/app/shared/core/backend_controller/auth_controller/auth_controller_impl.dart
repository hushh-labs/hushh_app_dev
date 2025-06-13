import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/auth_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/constants/secrets.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_controller.dart';

class AuthControllerImpl extends AuthController {
  final supabase = Supabase.instance.client;
  final fa.FirebaseAuth _firebaseAuth = fa.FirebaseAuth.instance;

  @override
  User? get currentUser => supabase.auth.currentUser;

  @override
  fa.User? get firebaseCurrentUser => _firebaseAuth.currentUser;

  @override
  Future<AuthResponse> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: Secrets.getIosId(), serverClientId: Secrets.WEB_CLIENT_ID);
    final value = await googleSignIn.isSignedIn();
    final GoogleSignInAccount? googleSignInAccount;
    if (value) {
      await googleSignIn.signOut();
    }
    googleSignInAccount = await googleSignIn.signIn();
    final googleAuth = await googleSignInAccount!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    return supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  @override
  Future<AuthResponse> signInWithApple() async {
    print('🍎 [APPLE_SIGN_IN] Starting Apple Sign-In process...');
    
    try {
      print('🍎 [APPLE_SIGN_IN] Generating nonce...');
      final rawNonce = supabase.auth.generateRawNonce();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();
      print('🍎 [APPLE_SIGN_IN] Nonce generated successfully');
      print('🍎 [APPLE_SIGN_IN] Raw nonce length: ${rawNonce.length}');
      print('🍎 [APPLE_SIGN_IN] Hashed nonce length: ${hashedNonce.length}');

      print('🍎 [APPLE_SIGN_IN] Requesting Apple ID credential...');
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );
      print('🍎 [APPLE_SIGN_IN] Apple ID credential received successfully');
      print('🍎 [APPLE_SIGN_IN] User ID: ${credential.userIdentifier}');
      print('🍎 [APPLE_SIGN_IN] Email: ${credential.email ?? "Not provided"}');
      print('🍎 [APPLE_SIGN_IN] Full Name: ${credential.givenName ?? "Not provided"} ${credential.familyName ?? "Not provided"}');
      print('🍎 [APPLE_SIGN_IN] Authorization Code: ${credential.authorizationCode != null ? "Present" : "Null"}');
      print('🍎 [APPLE_SIGN_IN] Identity Token: ${credential.identityToken != null ? "Present" : "Null"}');

      final idToken = credential.identityToken;
      if (idToken == null) {
        print('🍎 [APPLE_SIGN_IN] ERROR: No ID Token found in credential');
        throw const AuthException(
            'Could not find ID Token from generated credential.');
      }
      
      print('🍎 [APPLE_SIGN_IN] ID Token found, length: ${idToken.length}');
      print('🍎 [APPLE_SIGN_IN] Signing in with Supabase...');
      
      final result = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: idToken,
        nonce: rawNonce,
      );
      
      print('🍎 [APPLE_SIGN_IN] Supabase sign-in successful!');
      print('🍎 [APPLE_SIGN_IN] User ID: ${result.user?.id}');
      print('🍎 [APPLE_SIGN_IN] User Email: ${result.user?.email}');
      print('🍎 [APPLE_SIGN_IN] Session: ${result.session?.accessToken != null ? "Present" : "Null"}');
      
      return result;
      
    } catch (e) {
      print('🍎 [APPLE_SIGN_IN] ERROR: $e');
      print('🍎 [APPLE_SIGN_IN] Error type: ${e.runtimeType}');
      if (e is SignInWithAppleException) {
        print('🍎 [APPLE_SIGN_IN] Apple Sign-In Exception: $e');
        print('🍎 [APPLE_SIGN_IN] Apple Sign-In Exception Details: ${e.toString()}');
      }
      rethrow;
    }
  }

  @override
  Future<void> signInWithPhone(String countryCode, String phoneNumber) async {
    await supabase.auth.signInWithOtp(
        phone: phoneNumber,
        shouldCreateUser: true,
        channel: OtpChannel.sms,
        data: {'country_code': countryCode});
  }

  @override
  Future<AuthResponse> verifyPhone(String otp, String phoneNumber,
      [bool isPhoneChange = false]) async {
    print('📱 [AUTH_CONTROLLER] verifyPhone called');
    print('📱 [AUTH_CONTROLLER] OTP: $otp');
    print('📱 [AUTH_CONTROLLER] Phone: $phoneNumber');
    print('📱 [AUTH_CONTROLLER] isPhoneChange: $isPhoneChange');
    print('📱 [AUTH_CONTROLLER] OTP Type: ${isPhoneChange ? OtpType.phoneChange : OtpType.sms}');
    
    try {
      print('📱 [AUTH_CONTROLLER] Calling Supabase verifyOTP...');
      final result = await supabase.auth.verifyOTP(
          token: otp,
          type: isPhoneChange ? OtpType.phoneChange : OtpType.sms,
          phone: phoneNumber);
      print('📱 [AUTH_CONTROLLER] Supabase verifyOTP successful!');
      print('📱 [AUTH_CONTROLLER] User ID: ${result.user?.id}');
      print('📱 [AUTH_CONTROLLER] Session: ${result.session?.accessToken != null ? "Present" : "Null"}');
      return result;
    } catch (e) {
      print('📱 [AUTH_CONTROLLER] Supabase verifyOTP failed: $e');
      print('📱 [AUTH_CONTROLLER] Error type: ${e.runtimeType}');
      rethrow;
    }
  }

  @override
  Future<ResendResponse> resendOtp(String phoneNumber) async {
    return await supabase.auth.resend(type: OtpType.sms, phone: phoneNumber);
  }

  @override
  Future<void> signInWithPhoneFirebase(
      String phoneNumber, BuildContext context) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (fa.PhoneAuthCredential credential) async {
          await _firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (fa.FirebaseAuthException e) {
          print('Verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          sl<AuthPageBloc>().setVerificationId(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          sl<AuthPageBloc>().setVerificationId(verificationId);
        },
      );
    } catch (e) {
      print('Failed to verify phone number: $e');
    }
  }

  @override
  Future<void> verifyPhoneFirebase(String verificationId, String otp) async {
    try {
      final fa.PhoneAuthCredential credential = fa.PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      await _firebaseAuth.signInWithCredential(credential);
      // Handle successful sign-in
    } catch (e) {
      print('Failed to verify OTP: $e');
    }
  }

  @override
  Future<void> resendOtpFirebase(
      String phoneNumber, BuildContext context) async {
    // Resend OTP by calling signInWithPhone again
    await signInWithPhoneFirebase(phoneNumber, context);
  }

  @override
  Future<void> resendEmailOtp(String email) async {
    print("resending to $email");
    await Supabase.instance.client.auth
        .updateUser(UserAttributes(email: email));
  }

  @override
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  @override
  Future<void> deleteUser() async {
    print('📱 [AUTH_CONTROLLER] Deleting user from Supabase database using RPC...');
    try {
      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) {
        print('📱 [AUTH_CONTROLLER] No current user found, signing out...');
        await supabase.auth.signOut();
        return;
      }
      
      print('📱 [AUTH_CONTROLLER] Current user ID: ${currentUser.id}');
      
      // Use the same RPC function as in settings to delete user account
      final response = await supabase.rpc('delete_user_account',
          params: {'p_user_id': currentUser.id});
      
      print('📱 [AUTH_CONTROLLER] RPC delete_user_account response: $response');
      print('📱 [AUTH_CONTROLLER] User deleted successfully from Supabase database using RPC');
      
      // Sign out after successful deletion
      await supabase.auth.signOut();
      print('📱 [AUTH_CONTROLLER] User signed out after deletion');
      
    } catch (e) {
      print('📱 [AUTH_CONTROLLER] Error deleting user from database: $e');
      // If RPC delete fails, try regular signOut
      await supabase.auth.signOut();
      print('📱 [AUTH_CONTROLLER] Fallback: User signed out instead');
    }
  }

  @override
  Future<Either<ErrorState, void>> signInWithEmail(String email) async {
    try {
      await supabase.auth.signInWithOtp(
        email: email,
        data: {"name": AppLocalStorage.user!.name},
        shouldCreateUser: true,
      );
      return right(null);
    } catch (_) {
      return left(DataHttpError(HttpException.unknown));
    }
  }

  @override
  Future<AuthResponse> verifyEmail(String otp, String email) async {
    return await supabase.auth
        .verifyOTP(token: otp, type: OtpType.emailChange, email: email);
  }
}
