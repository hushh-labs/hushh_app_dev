import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:fadingpageview/fadingpageview.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/user.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/fetch_user_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/update_user_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/agent_sign_up_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/auth_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/pages/new/agent_guide/agent_guide_brand_select_page.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/pages/new/user_guide/create_first_card.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/pages/new/user_guide/user_guide_gmail_page.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/pages/new/user_guide/user_guide_location_page.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/pages/new/user_guide/user_guide_question_page.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/pages/otp_verification.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/bloc/card_market_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/splash/presentation/bloc/splash_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/ai_handler/ai_handler.dart';
import 'package:hushh_app/app/shared/core/backend_controller/auth_controller/auth_controller_impl.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

part 'events.dart';

part 'states.dart';

class SignUpPageBloc extends Bloc<SignUpPageEvent, SignUpPageState> {
  final FetchUserUseCase fetchUserUseCase;
  final UpdateUserUseCase updateUserUseCase;

  String? accessToken;

  Map<String, int> coinsMap = {};

  SignUpPageBloc(
    this.fetchUserUseCase,
    this.updateUserUseCase,
  ) : super(SignUpPageInitialState()) {
    on<SelectDateEvent>(selectDateEvent);
    on<UpdateDateEvent>(updateDateEvent);
    on<OnBackPressedEvent>(onBackPressedEvent);
    on<SignUpInitializeEvent>(signUpInitializeEvent);
    on<SignUpEvent>(userSignUpEvent);
    on<OnNextUserGuideClickedEvent>(onNextUserGuideClickedEvent);
  }

  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode dobFocusNode = FocusNode();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController emailOrPhoneController = TextEditingController();
  DateTime? birthDatePicker;
  String? recordedVideoUrl;
  Uint8List? recordedVideoImageData;
  String? selectedGender;
  String? selectedReasonForUsingHushh;

  final auth = sl<AuthController>();
  final userGuideController = FadingPageViewController();

  // final userGuidePages = ;

  int get totalPages => userGuidePages.length;
  final messaging = FirebaseMessaging.instance;
  UserModel? user;

  List<Widget> get userGuidePages {
    return sl<HomePageBloc>().entity == Entity.user
        ? [
            const CreateFirstCardPage(),
            const UserGuideQuestionPage(
                question: UserGuideQuestionType.emailOrPhone),
            const UserGuideQuestionPage(question: UserGuideQuestionType.name),
            // const UserGuideQuestionPage(
            //     question: UserGuideQuestionType.multiChoiceQuestion,
            //     multiChoiceQuestion: MultiChoiceQuestions.whyInstallHushh),
            // const UserGuideQuestionPage(question: UserGuideQuestionType.dob),
            // const UserGuideQuestionPage(
            //     question: UserGuideQuestionType.categories),
            const UserGuideGmailPage(),
            // const UserGuideLocationPage(),
            // const UserGuideQuestionPage(
            //     question: UserGuideQuestionType.multiChoiceQuestion,
            //     multiChoiceQuestion: MultiChoiceQuestions.whatGender),
            const UserGuideQuestionPage(question: UserGuideQuestionType.record),
          ]
        : [
            // const CreateFirstCardPage(),
            const UserGuideQuestionPage(question: UserGuideQuestionType.name),
            // const AgentGuideProfileImagePage(),
            if (!(user?.email != null && user?.phoneNumber != null))
              const UserGuideQuestionPage(
                  question: UserGuideQuestionType.emailOrPhone),
            if (user?.dob == null)
              const UserGuideQuestionPage(question: UserGuideQuestionType.dob),
            const UserGuideQuestionPage(
                question: UserGuideQuestionType.categories),
            // const UserGuideLocationPage(optional: true),
            // const AgentGuideAgentVerificationPage(),
            const AgentGuideBrandSelectPage(),
            // if (sl<AgentSignUpPageBloc>().newlyCreatedSelectedBrand == null ||
            //     sl<AgentSignUpPageBloc>().newlyCreatedSelectedBrand?.domain !=
            //         null)
            //   const AgentGuideBrandAgentVerification()
            // navigate to home screen w/ temporary app access
          ];
  }

  FutureOr<void> selectDateEvent(
      SelectDateEvent event, Emitter<SignUpPageState> emit) {
    showDatePicker(
            context: event.context,
            builder: (BuildContext context, Widget? child) => Theme(
                data: ThemeData(
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white, // button text color
                      ),
                    ),
                    colorScheme: const ColorScheme.dark(
                        onSurface: Colors.white, primary: Colors.grey),
                    datePickerTheme: const DatePickerThemeData(
                      headerBackgroundColor: Colors.black87,
                      backgroundColor: Colors.black87,
                      headerHeadlineStyle: TextStyle(color: Colors.white),
                      headerHelpStyle: TextStyle(color: Colors.white),
                      dayStyle: TextStyle(color: Colors.white),
                      weekdayStyle: TextStyle(color: Colors.white),
                      yearStyle: TextStyle(color: Colors.white),
                      surfaceTintColor: Colors.white,
                      dayForegroundColor:
                          MaterialStatePropertyAll(Colors.white),
                    )),
                child: child!),
            initialDate: DateTime.now(),
            firstDate: DateTime(1850),
            lastDate: DateTime.now())
        .then((selectedDate) {
      if (selectedDate == null) return null;
      add(UpdateDateEvent(selectedDate));
    });
  }

  FutureOr<void> updateDateEvent(
      UpdateDateEvent event, Emitter<SignUpPageState> emit) {
    emit(DateUpdatingState());
    birthDatePicker = event.dateTime;
    dobController.text = DateFormat('yyyy-MM-dd').format(event.dateTime);
    emit(DateUpdatedState(event.dateTime));
  }

  FutureOr<void> onBackPressedEvent(
      OnBackPressedEvent event, Emitter<SignUpPageState> emit) async {
    await auth.signOut();
    await GoogleSignIn().signOut();
    Navigator.pushNamedAndRemoveUntil(
        event.context, AppRoutes.mainAuth, (route) => false);
  }

  FutureOr<void> signUpInitializeEvent(
      SignUpInitializeEvent event, Emitter<SignUpPageState> emit) {
    emit(BasicInfoUpdatingState());
    // if (AppLocalStorage.tempUser?.email != null) {
    //   emailOrPhoneController.text = auth.currentUser!.email!;
    // }
    firstNameController.clear();
    if (AppLocalStorage.tempUser?.name != null) {
      firstNameController.text = AppLocalStorage.tempUser!.name!;
    }
    sl<CardMarketBloc>().add(FetchBrandsEvent());
    sl<AgentSignUpPageBloc>().add(FetchBrandCategoriesEvent());
    emit(BasicInfoUpdatedState());
  }

  FutureOr<void> userSignUpEvent(
      SignUpEvent event, Emitter<SignUpPageState> emit) async {
    showToast(String message) {
      ToastManager(Toast(title: message, type: ToastificationType.error))
          .show(event.context);
    }

    emit(SigningUpState());

    final String firstName = firstNameController.text;
    // String emailOrPhone = emailOrPhoneController.text;
    if (firstName.isEmpty) {
      emit(SigningUpErrorState());
      showToast("Please enter your first name");
      return;
    }

    // if (birthDatePicker == null) {
    //   emit(SigningUpErrorState());
    //   showToast("Please enter your date of birth");
    //   return;
    // }
    if (birthDatePicker != null) {
      final Duration ageDifference =
          DateTime.now().difference(birthDatePicker!);
      if (ageDifference.inDays <= 6590) {
        emit(SigningUpErrorState());
        showToast("You need to be at least 18 years old");
        return;
      }
    }

    // if (sl<AuthPageBloc>().isPhoneLogin) {
    //   if (emailOrPhone.isEmpty ||
    //       !RegExp(r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+\.([a-zA-Z0-9!#$%&*+/=?^_`{|}~-]+)$')
    //           .hasMatch(emailOrPhone.trim())) {
    //     emit(SigningUpErrorState());
    //     showToast("Invalid email");
    //     return;
    //   }
    // } else {
    //   if (emailOrPhone.isEmpty) {
    //     emit(SigningUpErrorState());
    //     showToast("Invalid phone number");
    //     return;
    //   }
    // }
    // final result = await fetchUserUseCase(email: emailOrPhone);
    // result.fold((l) {}, (r) {
    //   if (r != null) {
    //     emit(SigningUpErrorState());
    //     showToast("Email already exists!");
    //     return;
    //   }
    // });
    String? fcmToken = "";
    sl<SplashPageBloc>().add(UpdateUserRegistrationTokenEvent(
        hushhId: Supabase.instance.client.auth.currentUser?.id));

    // emailOrPhone = emailOrPhone.toLowerCase();

    int coins = 0;

    try {
      coins = (accessToken != null ? receiptRadarCoins : 0) +
          (coinsMap.values.reduce((a, b) => a + b));
    } catch (_) {}
    final user = UserModel(
        hushhId: Supabase.instance.client.auth.currentUser?.id,
        onboardStatus: OnboardStatus.signed_up,
        avatar: auth.currentUser?.userMetadata?['avatar_url'] ?? "",
        creationTime: "",
        privateMode: false,
        gender: selectedGender,
        userCoins: coins,
        // add more coins here (a) + (b)
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        countryCode: sl<AuthPageBloc>().selectedCountry!.dialCode,
        profileVideo: recordedVideoUrl,
        // phoneNumber: !sl<AuthPageBloc>().isPhoneLogin
        //     ? emailOrPhone
        //     : sl<AuthPageBloc>().phoneController.text,
        fcmToken: fcmToken,
        selectedReasonForUsingHushh: selectedReasonForUsingHushh,
        isHushhAppUser: true,
        // email: sl<AuthPageBloc>().isPhoneLogin
        //     ? emailOrPhone
        //     : sl<AuthPageBloc>().email,
        dob: birthDatePicker != null
            ? DateFormat('yyyy-mm-dd').format(birthDatePicker!)
            : null,
        role: sl<HomePageBloc>().entity);
    AppLocalStorage.updateUser(user);
    AppLocalStorage.updateHushhId(user.hushhId!);
    final result2 = await updateUserUseCase(user: user, uid: user.hushhId!);
    result2.fold((l) {}, (r) async {
      AppLocalStorage.updateUserOnboardingStatus(event.onboardStatus);
      sl<CardWalletPageBloc>()
          .add(CardWalletInitializeEvent(event.context, signUp: true));
    });
  }

  FutureOr<void> onNextUserGuideClickedEvent(
      OnNextUserGuideClickedEvent event, Emitter<SignUpPageState> emit) async {
    emit(GoingToNextPageState());
    bool isValidated = event.isValidated;
    UserGuideQuestionType question = event.question;
    BuildContext context = event.context;

    showToast(String message) {
      ToastManager(Toast(title: message, type: ToastificationType.error))
          .show(context);
    }

    if (!isValidated) {
      emit(SigningUpErrorState());
      return;
    }

    if (question == UserGuideQuestionType.record) {
      // 'record video
      sl<SignUpPageBloc>().add(SignUpEvent(context));
      return;
    } else if (question == UserGuideQuestionType.dob) {
      if (sl<SignUpPageBloc>().birthDatePicker == null) {
        showToast("Please select your date of birth to continue");
        emit(SigningUpErrorState());
        return;
      } else {
        final Duration ageDifference =
            DateTime.now().difference(sl<SignUpPageBloc>().birthDatePicker!);
        if (ageDifference.inDays <= 6590) {
          showToast("You need to be at least 18 years old");
          emit(SigningUpErrorState());
          return;
        }
      }
    } else if (question == UserGuideQuestionType.emailOrPhone) {
      final email = sl<AuthPageBloc>().isPhoneLogin
          ? sl<SignUpPageBloc>().emailOrPhoneController.text.toLowerCase()
          : sl<AuthPageBloc>().email;
      final phoneNumber = !sl<AuthPageBloc>().isPhoneLogin
          ? sl<SignUpPageBloc>().emailOrPhoneController.text.toLowerCase()
          : sl<AuthPageBloc>().phoneController.text;
      final phoneWithCountryCode =
          "+${sl<AuthPageBloc>().selectedCountry!.dialCode.replaceAll('+', '')}$phoneNumber";
      try {
        if (sl<AuthPageBloc>().isPhoneLogin) {
          await Supabase.instance.client.auth
              .updateUser(UserAttributes(email: email));
          if (Supabase.instance.client.auth.currentUser?.email == email) {
            userGuideController.next();
            emit(OnNextPageState());
            return;
          }

          // ignore: use_build_context_synchronously
          Navigator.pushNamed(event.context, AppRoutes.otpVerification,
              arguments: OtpVerificationPageArgs(
                  type: OtpVerificationType.email,
                  onVerifyFunc: () {
                    Navigator.pop(context);
                    // ToastManager(Toast(
                    //     title: 'OTP Verified 🎉',
                    //     description:
                    //     'Almost there! Continue creating your Hushh ID Card',
                    //     type: ToastificationType.success))
                    //     .show(event.context);
                    userGuideController.next();
                  }));
          emit(OnNextPageState());
          return;
        } else {
          await Supabase.instance.client.auth.updateUser(UserAttributes(
              phone: phoneWithCountryCode,
              data: {
                'country_code': sl<AuthPageBloc>().selectedCountry!.dialCode
              }));
          sl<AuthPageBloc>().phoneController.text = phoneNumber;
          if (Supabase.instance.client.auth.currentUser?.phone ==
              phoneWithCountryCode.replaceAll('+', '')) {
            userGuideController.next();
            emit(OnNextPageState());
            return;
          }
          // ignore: use_build_context_synchronously
          Navigator.pushNamed(event.context, AppRoutes.otpVerification,
              arguments: OtpVerificationPageArgs(
                  type: OtpVerificationType.phone,
                  onVerifyFunc: () {
                    Navigator.pop(context);
                    // ToastManager(Toast(
                    //     title: 'OTP Verified 🎉',
                    //     description:
                    //     'Almost there! Continue creating your Hushh ID Card',
                    //     type: ToastificationType.success))
                    //     .show(event.context);
                    userGuideController.next();
                  }));
          emit(OnNextPageState());
          return;
        }
      } on AuthException catch (err) {
        showToast(err.message);
        emit(SigningUpErrorState());
        return;
      }
    }
    userGuideController.next();
    emit(OnNextPageState());
  }

  Future<String?> getPersonalizedAffirmation() async {
    String prompt = """Given the following user information:
Name: ${firstNameController.text}
Country code: ${sl<AuthPageBloc>().selectedCountry!.dialCode}
Location: ${sl<HomePageBloc>().country.name}
Reason for using and installing the app: $selectedReasonForUsingHushh
Age/Date of birth: 8 July, 2004 (20 years old)
Product categories of interest: ${sl<AgentSignUpPageBloc>().selectedCategories.map((e) => e.name).join(", ")}
Gender: $selectedGender

Generate a personalized affirmation based on the above details under 2 lines that reflects the user's interests and personality. Make it positive and tailored to their preferences and lifestyle. For example, if the user is interested in technology and outdoor activities, the affirmation could be 'You seem to be a tech enthusiast who loves outdoor adventures!\nNote: Make sure to add the user's name in the response to make it more personalized""";
    log(prompt);
    final response = await AiHandler("").getChatResponse(prompt);
    if (response != null) {
      final parsedEvent = extractSingleJSONFromString(response);
      return parsedEvent;
    }
    return null;
  }
}
