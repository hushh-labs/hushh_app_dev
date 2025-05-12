part of 'auth_controller_impl.dart';

abstract class AuthController {
  User? get currentUser;

  fa.User? get firebaseCurrentUser;

  Future<AuthResponse> signInWithGoogle();

  Future<AuthResponse> signInWithApple();

  Future<void> signInWithPhone(String countryCode, String phoneNumber);

  Future<AuthResponse> verifyPhone(String otp, String phoneNumber, [bool isPhoneChange = false]);

  Future<ResendResponse> resendOtp(String phoneNumber);

  Future<void> signInWithPhoneFirebase(String phoneNumber, BuildContext context);

  Future<void> verifyPhoneFirebase(String verificationId, String otp);

  Future<void> resendOtpFirebase(String phoneNumber, BuildContext context);

  Future<void> resendEmailOtp(String email);

  Future<Either<ErrorState, void>> signInWithEmail(String email);

  Future<AuthResponse> verifyEmail(String otp, String email);

  Future<void> signOut();
}