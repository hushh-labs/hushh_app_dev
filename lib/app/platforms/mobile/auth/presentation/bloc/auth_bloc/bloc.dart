// app/platforms/mobile/auth/presentation/bloc/auth_bloc/bloc.dart
import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hushh_app/app/platforms/mobile/auth/data/models/countriesModel.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/temp_user.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/user.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/fetch_agents_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/fetch_user_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/insert_agent_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/update_user_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/sign_up_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/pages/new/user_guide/user_guide.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/pages/otp_verification.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/pages/agent_home.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/config/constants/country_masks.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/backend_controller/auth_controller/auth_controller_impl.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:page_transition/page_transition.dart';

// import 'package:sms_autofill/sms_autofill.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:toastification/toastification.dart';

part 'events.dart';

part 'states.dart';

class AuthPageBloc extends Bloc<AuthPageEvent, AuthPageState> {
  final FetchUserUseCase fetchUserUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final InsertAgentUseCase insertAgentUseCase;
  final FetchAgentsUseCase fetchAgentUseCase;

  AuthPageBloc(
    this.fetchUserUseCase,
    this.updateUserUseCase,
    this.insertAgentUseCase,
    this.fetchAgentUseCase,
  ) : super(AuthPageInitialState()) {
    on<AuthenticateWithPhoneEvent>(authenticateWithPhoneEvent);
    on<AuthenticateWithGoogleEvent>(authenticateWithGoogleEvent);
    on<AuthenticateWithAppleEvent>(authenticateWithAppleEvent);
    on<InitializeEvent>(initializeEvent);
    on<DisposeEvent>(disposeEvent);
    on<OnBackClickedEvent>(onBackClickedEvent);
    on<OnPhoneUpdateEvent>(onPhoneUpdateEvent);
    on<OnCountryUpdateEvent>(onCountryUpdateEvent);
    on<OnVerifyEvent>(onVerifyEvent);
    on<OnOtpResendEvent>(onOtpResendEvent);
    on<AuthPageCodeSentEvent>(authPageCodeSentEvent);
    on<PhoneVerificationFailedEvent>(phoneVerificationFailedEvent);
    on<CountDownForResendFunction>(countDownForResendFunction);
  }

  final auth = sl<AuthController>();
  bool exitApp = false;
  late List<Country> _countryList;
  late List<Country> filteredCountries;
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  FocusNode focusNode = FocusNode();
  var phoneNumberWithoutCountryCode = "";
  Country? selectedCountry;
  TextInputFormatter? formatter;
  String? email;
  int resendSeconds = 60;
  CountdownController countdown = CountdownController(autoStart: false);
  int countDownForResendStartValue = 60;
  late Timer countDownForResend;
  bool resendValidation = false;
  String? firebaseVerificationId;

  bool areReceiptsAnalyzing = false;

  void setVerificationId(String id) {
    firebaseVerificationId = id;
  }

  String get phoneNumber =>
      "+${selectedCountry!.dialCode}${phoneController.text}"
          .replaceAll(' ', '')
          .replaceAll('-', '')
          .replaceAll('(', '')
          .replaceAll(')', '');

  String get phoneNumberWithoutCode => phoneController.text
      .replaceAll(' ', '')
      .replaceAll('-', '')
      .replaceAll('(', '')
      .replaceAll(')', '');

  bool get isPhoneLogin {
    return AppLocalStorage.tempUser?.email == null;
  }

  bool get shouldVerifyEmail => sl<SignUpPageBloc>()
      .emailOrPhoneController
      .text
      .toLowerCase()
      .contains('@');

  bool get isUser => sl<HomePageBloc>().entity == Entity.user;

  Future<void> _handleNewUser(BuildContext context) async {
    print('🚀 [AUTH_BLOC] Handling new user - user authenticated in Supabase but not in app database');
    print('🚀 [AUTH_BLOC] Deleting user completely from Supabase database for fresh signup...');
    
    try {
      // Delete the user completely from Supabase database
      await auth.deleteUser();
      print('🚀 [AUTH_BLOC] User deleted completely from Supabase database successfully');
      
      // Navigate back to auth page to start fresh signup process
      print('🚀 [AUTH_BLOC] Navigating back to auth page for fresh signup...');
      Navigator.of(context).popUntil((route) => route.isFirst);
      
    } catch (e) {
      print('🚀 [AUTH_BLOC] Error deleting user: $e');
      // Even if delete fails, navigate back to start fresh
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  Future<void> _navigateToSignUpForNewUser(BuildContext context) async {
    print('🍎 [AUTH_BLOC] Navigating to signup for new Apple user...');
    
    // Create temp user for Apple Sign-In without email
    final tempUser = TempUserModel(
        avatar: null,
        countryCode: selectedCountry?.dialCode,
        name: null,
        phoneNumber: null,
        email: null);
    AppLocalStorage.updateTempUser(tempUser);
    
    sl<SignUpPageBloc>().add(SignUpInitializeEvent());
    AppLocalStorage.updateUserOnboardingStatus(UserOnboardStatus.signUpForm);
    
    if (sl<HomePageBloc>().entity == Entity.user) {
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.bottomToTop,
              child: const UserGuidePage()));
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.agentHome,
          arguments: AgentHomePageArgs(tabValue: 1));
    }
  }

  Future<void> _showAppleEmailDialog(BuildContext context) async {
    print('🍎 [AUTH_BLOC] Showing Apple-style email dialog...');
    
    final TextEditingController emailController = TextEditingController();
    String? enteredEmail;
    
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          title: Column(
            children: [
              Icon(
                Icons.apple,
                size: 64,
                color: Colors.black,
              ),
              SizedBox(height: 16),
              Text(
                'Complete Your Sign In',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'To complete your Apple Sign-In, please provide your email address.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFF007AFF), width: 2),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          actions: [
            Column(
              children: [
                Divider(height: 1, color: Colors.grey.shade300),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // Sign out and go back to auth
                          auth.signOut();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xFF007AFF),
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 44,
                      color: Colors.grey.shade300,
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          final emailText = emailController.text.trim();
                          if (emailText.isNotEmpty && emailText.contains('@')) {
                            enteredEmail = emailText;
                            Navigator.of(context).pop(emailText);
                          } else {
                            // Show error
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please enter a valid email address'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        ),
                        child: Text(
                          'Continue',
                          style: TextStyle(
                            color: Color(0xFF007AFF),
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
          actionsPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.fromLTRB(24, 20, 24, 0),
          titlePadding: EdgeInsets.fromLTRB(24, 24, 24, 0),
        );
      },
    );
    
    if (enteredEmail != null) {
      print('🍎 [AUTH_BLOC] User entered email: $enteredEmail');
      email = enteredEmail;
      
      // Now check if user exists with this email
      final result = await fetchUserUseCase(email: enteredEmail);
      result.fold((l) {
        print('🍎 [AUTH_BLOC] FetchUserUseCase failed: $l');
        print('🍎 [AUTH_BLOC] User not found in database, proceeding to signup...');
        _navigateToSignUpForNewUser(context);
      }, (user) {
        print('🍎 [AUTH_BLOC] FetchUserUseCase result: $user');
        if (user != null) {
          print('🍎 [AUTH_BLOC] Existing user found, navigating to sign up...');
          _navigateToSignUp(context, user: user);
        } else {
          print('🍎 [AUTH_BLOC] User is null, proceeding to signup...');
          _navigateToSignUpForNewUser(context);
        }
      });
    }
  }

  Future<void> _navigateToSignUp(context, {required UserModel user}) async {
    bool isNewUser = user.onboardStatus == OnboardStatus.authenticated;
    final tempUser = TempUserModel(
        avatar: user.avatar,
        countryCode: user.countryCode,
        name: user.name,
        phoneNumber:
            user.phoneNumber?.trim().isEmpty ?? true ? null : user.phoneNumber,
        email: user.email);
    AppLocalStorage.updateTempUser(tempUser);
    if (isNewUser) {
      sl<SignUpPageBloc>().add(SignUpInitializeEvent());
      AppLocalStorage.updateUserOnboardingStatus(UserOnboardStatus.signUpForm);
      if (sl<HomePageBloc>().entity == Entity.user) {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.bottomToTop,
                child: const UserGuidePage()));
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.agentHome,
            arguments: AgentHomePageArgs(tabValue: 1));
      }
      return;
    }

    AppLocalStorage.updateHushhId(user.hushhId!);

    final result = await fetchAgentUseCase(uid: user.hushhId);
    result.fold((l) => null, (r) {
      AppLocalStorage.updateUserOnboardingStatus(UserOnboardStatus.loggedIn);
      sl<CardWalletPageBloc>().add(CardWalletInitializeEvent(context));
      AppLocalStorage.updateUser(user);
      sl<SignUpPageBloc>().user = user;
      if (r.isNotEmpty) {
        if (isUser) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
          return;
        }
        AppLocalStorage.updateAgent(r.first);
        Navigator.pushReplacementNamed(context, AppRoutes.agentHome,
            arguments: AgentHomePageArgs(tabValue: 1));
        // switch (AppLocalStorage.agent!.agentApprovalStatus!) {
        //   case AgentApprovalStatus.approved:
        //     Navigator.pushReplacementNamed(context, AppRoutes.agentHome,
        //         arguments: AgentHomePageArgs(tabValue: 1));
        //     break;
        //   case AgentApprovalStatus.pending:
        //   case AgentApprovalStatus.denied:
        //     Navigator.pushReplacementNamed(context, AppRoutes.agentStatus,
        //         arguments: AppLocalStorage.agent!.agentApprovalStatus!);
        //     break;
        // }
      } else {
        if (isUser) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        } else {
          // this is where user is a Hushh User but need to register as Agent too
          sl<SignUpPageBloc>().add(SignUpInitializeEvent());
          AppLocalStorage.updateUserOnboardingStatus(
              UserOnboardStatus.signUpForm);
          // Navigator.push(
          //     context,
          //     PageTransition(
          //         type: PageTransitionType.bottomToTop,
          //         child: const UserGuidePage()));
          Navigator.pushReplacementNamed(context, AppRoutes.agentHome,
              arguments: AgentHomePageArgs(tabValue: 1));
          return;
        }
      }
    });
  }

  FutureOr<void> authenticateWithPhoneEvent(
      AuthenticateWithPhoneEvent event, Emitter<AuthPageState> emit) async {
    emit(PhoneVerificationInitiatedState());
    if (phoneController.text.isNotEmpty) {
      auth
          .signInWithPhone(selectedCountry!.dialCode, phoneNumber)
          .then((value) {
        add(AuthPageCodeSentEvent(event.context));
      }).catchError((error) {
        // Only show error for actual failures, not for existing users
        add(AuthPageCodeSentEvent(event.context));
      });
    } else {
      emit(PhoneVerificationFailedState());
      ToastManager(
        Toast(
          title: Constants.enterNumber,
          type: ToastificationType.warning,
        ),
      ).show(event.context);
    }
  }

  FutureOr<void> authenticateWithGoogleEvent(
      AuthenticateWithGoogleEvent event, Emitter<AuthPageState> emit) async {
    emit(AuthenticatingWithGoogleState());
    try {
      AuthResponse googleAuth = await auth.signInWithGoogle();
      if (googleAuth.user != null) {
        email = googleAuth.user!.email;
        final result = await fetchUserUseCase(email: googleAuth.user!.email);
        result.fold((l) {}, (user) {
          if (user != null) {
            _navigateToSignUp(event.context, user: user);
          }
        });
      }
    } catch (error, s) {
      if (kDebugMode) {
        print("error");
        print(error);
        print(s);
      }
    }

    emit(AuthenticationCompleteWithGoogleState());
  }

  FutureOr<void> authenticateWithAppleEvent(
      AuthenticateWithAppleEvent event, Emitter<AuthPageState> emit) async {
    print('🍎 [AUTH_BLOC] Apple Sign-In event received');
    emit(AuthenticatingWithAppleState());
    
    try {
      print('🍎 [AUTH_BLOC] Calling auth.signInWithApple()...');
      AuthResponse appleAuth = await auth.signInWithApple();
      print('🍎 [AUTH_BLOC] Apple Sign-In response received');
      print('🍎 [AUTH_BLOC] User: ${appleAuth.user != null ? "Present" : "Null"}');
      print('🍎 [AUTH_BLOC] Session: ${appleAuth.session != null ? "Present" : "Null"}');
      
      if (appleAuth.user != null) {
        print('🍎 [AUTH_BLOC] Apple user found');
        print('🍎 [AUTH_BLOC] User ID: ${appleAuth.user!.id}');
        print('🍎 [AUTH_BLOC] User Email: ${appleAuth.user!.email ?? "Not provided"}');
        print('🍎 [AUTH_BLOC] User Phone: ${appleAuth.user!.phone ?? "Not provided"}');
        print('🍎 [AUTH_BLOC] User Metadata: ${appleAuth.user!.userMetadata}');
        
        email = appleAuth.user!.email;
        print('🍎 [AUTH_BLOC] Set email variable to: $email');
        
        if (email != null && email!.isNotEmpty) {
          print('🍎 [AUTH_BLOC] Fetching user from database with email: $email');
          final result = await fetchUserUseCase(email: appleAuth.user!.email);
          result.fold((l) {
            print('🍎 [AUTH_BLOC] FetchUserUseCase failed: $l');
            print('🍎 [AUTH_BLOC] User not found in database, proceeding to signup...');
            _navigateToSignUpForNewUser(event.context);
          }, (user) {
            print('🍎 [AUTH_BLOC] FetchUserUseCase result: $user');
            if (user != null) {
              print('🍎 [AUTH_BLOC] Existing user found, navigating to sign up...');
              _navigateToSignUp(event.context, user: user);
            } else {
              print('🍎 [AUTH_BLOC] User is null, proceeding to signup...');
              _navigateToSignUpForNewUser(event.context);
            }
          });
        } else {
          print('🍎 [AUTH_BLOC] No email provided by Apple (Hide My Email), showing email dialog...');
          await _showAppleEmailDialog(event.context);
        }
      } else {
        print('🍎 [AUTH_BLOC] Apple user is null, authentication may have failed');
      }
    } catch (e, stackTrace) {
      print('🍎 [AUTH_BLOC] ERROR during Apple Sign-In: $e');
      print('🍎 [AUTH_BLOC] Error type: ${e.runtimeType}');
      print('🍎 [AUTH_BLOC] Stack trace: $stackTrace');
      
      if (kDebugMode) {
        print("Error during Apple Sign-In: $e");
      }
      
      // Show user-friendly error message
      ToastManager(
        Toast(
          title: 'Apple Sign-In Failed',
          description: 'Unable to sign in with Apple. Please try again or use another method.',
          type: ToastificationType.error,
        ),
      ).show(event.context);
    }
    
    print('🍎 [AUTH_BLOC] Apple Sign-In process completed');
    emit(AuthenticationCompleteWithAppleState());
  }

  FutureOr<void> initializeEvent(
      InitializeEvent event, Emitter<AuthPageState> emit) async {
    emit(InitializingState(event.isInitState));
    // await resetSignUpPageBlocInstance();
    _countryList = countries;
    await sl<HomePageBloc>().updateLocation();
    await sl<HomePageBloc>().updateLocation();
    selectedCountry = sl<HomePageBloc>().country;
    formatter = MaskTextInputFormatter(
      mask: countryMasks[selectedCountry!.code],
      filter: {"#": RegExp(r'[0-9]')},
    );
    // selectedCountry ??= _countryList.firstWhere((item) => item.code == "US",
    //     orElse: () => _countryList.first);
    _countryList = countries;
    filteredCountries = _countryList;
    emit(InitializedState());
  }

  FutureOr<void> disposeEvent(
      DisposeEvent event, Emitter<AuthPageState> emit) {}

  FutureOr<void> onBackClickedEvent(
      OnBackClickedEvent event, Emitter<AuthPageState> emit) async {
    exitApp = !exitApp;
    if (exitApp) {
      ScaffoldMessenger.of(event.context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFFEEEEEE),
        elevation: 0,
        duration: const Duration(milliseconds: 1500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: const Text(
          Constants.exitText,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black),
        ),
        margin: const EdgeInsets.all(120),
      ));
    } else {
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
    }
  }

  FutureOr<void> onPhoneUpdateEvent(
      OnPhoneUpdateEvent event, Emitter<AuthPageState> emit) async {
    emit(PhoneUpdatingState());
    final initialPhoneNumber = PhoneNumber(
      countryISOCode: selectedCountry!.code,
      countryCode: '+${selectedCountry!.dialCode}',
      number: phoneController.text
          .replaceAll(' ', '')
          .replaceAll('-', '')
          .replaceAll('(', '')
          .replaceAll(')', ''),
    );
    int phoneLengthBasedOnCountryCode = countries
        .firstWhere(
            (element) => element.code == initialPhoneNumber.countryISOCode)
        .maxLength;

    if (initialPhoneNumber.number.length == phoneLengthBasedOnCountryCode) {
      FocusManager.instance.primaryFocus?.unfocus();
    }

    phoneNumberWithoutCountryCode = phoneController.text;
    emit(PhoneUpdatedState());
  }

  FutureOr<void> onCountryUpdateEvent(
      OnCountryUpdateEvent event, Emitter<AuthPageState> emit) async {
    emit(CountryUpdatingState());
    bool isNumeric(String s) => s.isNotEmpty && double.tryParse(s) != null;

    filteredCountries = _countryList;
    await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
      ),
      isScrollControlled: true,
      context: event.context,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (ctx, setStateCountry) => Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF7f7f97), width: 0.5),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15), topLeft: Radius.circular(15))),
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Container(
                height: 40,
                margin: const EdgeInsets.only(top: 10, bottom: 5),
                child: TextField(
                  onChanged: (value) {
                    filteredCountries = isNumeric(value)
                        ? _countryList
                            .where(
                                (country) => country.dialCode.contains(value))
                            .toList()
                        : _countryList
                            .where((country) => country.name
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                    setStateCountry(() {});
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    hintText: 'Search country',
                    hintStyle: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(6),
                      child: SvgPicture.asset(
                        'assets/search_new.svg',
                        color: Colors.black,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredCountries.length,
                  itemBuilder: (ctx, index) => Column(
                    children: <Widget>[
                      ListTile(
                        onTap: () {
                          selectedCountry = filteredCountries[index];
                          formatter = MaskTextInputFormatter(
                            mask: countryMasks[selectedCountry!.code],
                            filter: {"#": RegExp(r'[0-9]')},
                          );
                          Navigator.of(context).pop();
                          FocusScope.of(context).unfocus();
                        },
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/flags/${filteredCountries[index].code.toLowerCase()}.png',
                            width: 50,
                          ),
                        ),
                        title: Text(
                          filteredCountries[index].name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.black),
                        ),
                        trailing: Text(
                          '+${filteredCountries[index].dialCode}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.black),
                        ),
                      ),
                      const Divider(thickness: 1),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    emit(CountryUpdatedState());
  }

  FutureOr<void> onVerifyEvent(
      OnVerifyEvent event, Emitter<AuthPageState> emit) async {
    print('🚀 [AUTH_BLOC] OnVerifyEvent received!');
    print('🚀 [AUTH_BLOC] OTP value: ${event.value}');
    print('🚀 [AUTH_BLOC] OTP length: ${event.value.length}');
    print('🚀 [AUTH_BLOC] Required OTP length: ${Constants.otpLength}');
    print('🚀 [AUTH_BLOC] Verification type: ${event.type}');
    print('🚀 [AUTH_BLOC] Phone number: $phoneNumber');
    print('🚀 [AUTH_BLOC] OnVerify callback: ${event.onVerify}');
    
    if (event.value.length == Constants.otpLength) {
      print('🚀 [AUTH_BLOC] OTP length is valid, proceeding with verification...');
      emit(PhoneVerifyingState());
      try {
        AuthResponse authRes;
        if (event.type == OtpVerificationType.phone) {
          print('🚀 [AUTH_BLOC] Verifying phone OTP...');
          try {
            print('🚀 [AUTH_BLOC] Calling auth.verifyPhone with OTP: ${event.value}, Phone: $phoneNumber');
            authRes = await auth.verifyPhone(
                event.value, phoneNumber, event.onVerify != null);
            print('🚀 [AUTH_BLOC] Phone verification successful! User: ${authRes.user?.id}');
          } catch (err) {
            print('🚀 [AUTH_BLOC] Phone verification failed: $err');
            ToastManager(
              Toast(
                title: 'Invalid OTP',
                description: 'Please enter the correct OTP to proceed.',
                type: ToastificationType.error,
              ),
            ).show(event.context);
            throw Exception(err.toString());
          }
        } else {
          if (shouldVerifyEmail) {
            final email =
                sl<SignUpPageBloc>().emailOrPhoneController.text.toLowerCase();
            authRes = await auth.verifyEmail(event.value, email);
          } else {
            authRes = await auth.verifyPhone(
                event.value, phoneNumber, event.onVerify != null);
          }
        }
        // await auth.verifyPhoneFirebase(
        //     firebaseVerificationId!, event.value); //firebase
        if (authRes.user != null) {
          print('🚀 [AUTH_BLOC] AuthRes user is not null, proceeding with navigation logic...');
          // supabase
          // if (auth.firebaseCurrentUser != null) { // firebase
          if (event.onVerify == null) {
            print('🚀 [AUTH_BLOC] OnVerify is null, fetching user data...');
            print('🚀 [AUTH_BLOC] Phone number without code: $phoneNumberWithoutCode');
            final result =
                await fetchUserUseCase(phoneNumber: phoneNumberWithoutCode);
            result.fold((l) {
              print('🚀 [AUTH_BLOC] FetchUserUseCase failed: $l');
              print('🚀 [AUTH_BLOC] Creating new user since fetch failed...');
              _handleNewUser(event.context);
            }, (user) {
              print('🚀 [AUTH_BLOC] FetchUserUseCase result: $user');
              if (user != null) {
                print('🚀 [AUTH_BLOC] User found, navigating to sign up...');
                _navigateToSignUp(event.context, user: user);
              } else {
                print('🚀 [AUTH_BLOC] User is null, creating new user...');
                _handleNewUser(event.context);
              }
            });
          } else {
            print('🚀 [AUTH_BLOC] OnVerify callback is present, calling it...');
            event.onVerify?.call();
          }
        } else {
          print('🚀 [AUTH_BLOC] AuthRes user is null, no navigation performed');
        }
      } catch (e, s) {
        print('🚀 [AUTH_BLOC] Exception in onVerifyEvent: $e');
        print('🚀 [AUTH_BLOC] Stack trace: $s');
        emit(PhoneVerifiedState());
        return;
      }
    } else {
      print('🚀 [AUTH_BLOC] OTP length is insufficient: ${event.value.length}/${Constants.otpLength}');
      print('🚀 [AUTH_BLOC] Not proceeding with verification');
    }
    emit(PhoneVerifiedState());
  }

  FutureOr<void> onOtpResendEvent(
      OnOtpResendEvent event, Emitter<AuthPageState> emit) async {
    countdown.restart();
    emit(ResendingOtpState());
    if (event.otpVerificationType == OtpVerificationType.phone) {
      auth.resendOtp(phoneNumber).then((value) {
        // supabase
        // auth.resendOtpFirebase(phoneNumber, event.context).then((value) {
        // firebase
        add(CountDownForResendFunction());
      });
    } else {
      auth
          .resendEmailOtp(
              sl<SignUpPageBloc>().emailOrPhoneController.text.toLowerCase())
          .then((value) {
        // supabase
        // auth.resendOtpFirebase(phoneNumber, event.context).then((value) {
        // firebase
        add(CountDownForResendFunction());
      });
    }
  }

  FutureOr<void> authPageCodeSentEvent(
      AuthPageCodeSentEvent event, Emitter<AuthPageState> emit) {
    emit(AuthPageInitialState());
    Navigator.pushNamed(event.context, AppRoutes.otpVerification,
        arguments: OtpVerificationPageArgs(type: OtpVerificationType.phone));
  }

  FutureOr<void> phoneVerificationFailedEvent(
      PhoneVerificationFailedEvent event, Emitter<AuthPageState> emit) {
    emit(PhoneVerificationFailedState());
  }

  FutureOr<void> countDownForResendFunction(
      CountDownForResendFunction event, Emitter<AuthPageState> emit) {
    const oneSec = Duration(seconds: 1);
    countDownForResend = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (countDownForResendStartValue == 0) {
          timer.cancel();
          resendValidation = true;
          countDownForResendStartValue = 60;
        } else {
          countDownForResendStartValue--;
        }
      },
    );
  }
}
