import 'package:hushh_app/currency_converter/currency.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/auth/data/models/countriesModel.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/models/transaction_model.dart';
import 'package:hushh_app/app/platforms/mobile/splash/data/models/tutorial_model.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';

const receiptRadarCoins = 20;
const healthInsightsCoins = 10;

Currency defaultCurrency = Currency.usd;
Entity defaultEntity = Entity.user;
Country defaultCountry =
    countries.firstWhere((element) => element.code == 'US');

List<TransactionModel> defaultTransactions = [
  TransactionModel(
    title: 'Apple Store',
    desc: 'Gadgets',
    dateTime: DateTime.now(),
    currency: 'INR',
    amount: 64.20,
    image: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Apple_logo_black.svg/488px-Apple_logo_black.svg.png'
  ),
  TransactionModel(
    title: 'Spotify',
    desc: 'Music',
    dateTime: DateTime.now(),
    currency: 'INR',
    amount: 2.39,
    image: 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/84/Spotify_icon.svg/512px-Spotify_icon.svg.png'
  ),
  TransactionModel(
    title: 'Amazon',
    desc: 'Shopping',
    dateTime: DateTime.now(),
    currency: 'INR',
    amount: 282,
    image: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a9/Amazon_logo.svg/603px-Amazon_logo.svg.png'
  ),
];

List<TutorialModel> defaultUserTutorials = [
  TutorialModel(
      heading: "Your data, Your business",
      image: "assets/onboardScreens/onboard-1.png",
      items: [
        TutorialItem(
          icon: 'assets/icons/onboard-1_get-rewarded.svg',
          heading: 'Get Rewarded',
          desc: 'Earn rewards for sharing your preferences with brands.',
        ),
        TutorialItem(
          icon: 'assets/icons/onboard-1_taste.svg',
          heading: 'Tell Us Your Tastes',
          desc:
              'Love coffee? Obsessed with sneakers? Let Hushh know your favorite brands and styles to have personalized experiences.',
        ),
        TutorialItem(
          icon: 'assets/icons/onboard-1_privacy.svg',
          heading: 'Your Privacy Matters',
          desc:
              'Your data is always safe with us. We never share your personal details. You control what you share.',
        ),
      ]),
  TutorialModel(
      heading: "Your Brand World, Your Way",
      image: "assets/onboardScreens/onboard-2.png",
      items: [
        TutorialItem(
          icon: 'assets/icons/onboard-2_exclusive-rewarded.svg',
          heading: 'Unlock Exclusive Rewards',
          desc:
              'Get personalized offers, early access, and more from your favorite brands.',
        ),
        TutorialItem(
          icon: 'assets/icons/onboard-2_preferences.svg',
          heading: 'Share Your Preferences',
          desc:
              'Tell brands what you love (and what you don\'t) to get tailored recommendations.',
        ),
        TutorialItem(
          icon: 'assets/icons/onboard-2_earn.svg',
          heading: 'Earn from Your Data',
          desc:
              'Choose to share your preferences and earn rewards for helping brands understand your needs.',
        ),
      ]),
  TutorialModel(
      heading: "Your Preferences, Your Perks",
      image: "assets/onboardScreens/onboard-3.png",
      items: [
        TutorialItem(
          icon: 'assets/icons/onboard-3_create-card.svg',
          heading: 'Create Preference Cards',
          desc:
              'Organize your favorite things – from coffee orders to travel destinations.',
        ),
        TutorialItem(
          icon: 'assets/icons/onboard-3_tailored.svg',
          heading: 'Tailored to You',
          desc:
              ' Get personalized recommendations and offers that match your unique tastes.',
        ),
        TutorialItem(
          icon: 'assets/icons/onboard-3_earn.svg',
          heading: 'Earn from Your Data',
          desc:
              'Choose to share your preferences (anonymously) and get rewarded for your insights.',
        ),
      ]),
  TutorialModel(
      heading: "Your Receipts, Your Rewards",
      image: "assets/onboardScreens/onboard-4.png",
      items: [
        TutorialItem(
          icon: 'assets/icons/onboard-4_link-gmail.svg',
          heading: 'Link Your Gmail',
          desc:
              'Connect your inbox to easily sync and organize all your receipts.',
        ),
        TutorialItem(
          icon: 'assets/icons/onboard-4_search-find.svg',
          heading: 'Search & Find',
          desc: 'Instantly find any receipt, no matter how old.',
        ),
        TutorialItem(
          icon: 'assets/icons/onboard-4_spending-insights.svg',
          heading: 'Spending Insights',
          desc:
              'Track your spending habits and discover trends across brands and categories.',
        ),
        TutorialItem(
          icon: 'assets/icons/onboard-4_connect-card.svg',
          heading: 'Connect with Cards',
          desc:
              'Link receipts to your preference cards for even more personalized experiences and rewards.',
        ),
      ]),
];

List<TutorialModel> defaultAgentTutorials = [
  TutorialModel(
      heading: "Empower Your Brand, Connect \nwith Customers",
      image: "assets/onboardScreens/onboard-1.png",
      items: [
        TutorialItem(
          icon: 'assets/icons/onboard-1_get-rewarded.svg',
          heading: 'Register Your Brand',
          desc: 'Easily onboard your brand and connect it to hushh’s ecosystem to reach new customers.',
        ),
        TutorialItem(
          icon: 'assets/icons/onboard-1_taste.svg',
          heading: 'Connect Your Inventory',
          desc:
          'Sync your brand’s inventory through ERP solutions for real-time updates and seamless operations.',
        ),
        TutorialItem(
          icon: 'assets/icons/onboard-1_privacy.svg',
          heading: 'Create Custom Brand Cards',
          desc:
          'Design custom cards that reflect your brand’s uniqueness and stand out in the marketplace.',
        ),
      ]),
  TutorialModel(
      heading: "Find and Engage Your Customers",
      image: "assets/onboardScreens/onboard-2.png",
      items: [
        TutorialItem(
          icon: 'assets/icons/onboard-2_exclusive-rewarded.svg',
          heading: 'Target the Right Audience',
          desc:
          "Find customers who match your brand’s offerings and preferences through hushh’s data insights.",
        ),
        TutorialItem(
          icon: 'assets/icons/onboard-2_preferences.svg',
          heading: 'Engage with Customers',
          desc:
          'Chat with customers, answer queries, and build relationships that drive loyalty.',
        ),
        TutorialItem(
          icon: 'assets/icons/onboard-2_earn.svg',
          heading: 'Boost Sales with Direct Requests',
          desc:
          'Request payments directly from customers through the app for seamless transactions.',
        ),
      ]),
  TutorialModel(
      heading: "Earn and Grow with hushh",
      image: "assets/onboardScreens/onboard-3.png",
      items: [
        TutorialItem(
          icon: 'assets/icons/onboard-3_create-card.svg',
          heading: 'Unlock Exclusive Rewards',
          desc:
          'Earn rewards for customer interactions, brand promotions, and sales through hushh.',
        ),
        TutorialItem(
          icon: 'assets/icons/onboard-3_tailored.svg',
          heading: 'Track Your Performance',
          desc:
          'Monitor your sales and customer engagement with Hushh’s analytics tools.',
        ),
        TutorialItem(
          icon: 'assets/icons/onboard-3_earn.svg',
          heading: 'Access ERP Solutions',
          desc:
          'Leverage ERP solutions to streamline your brand’s operations and maximize efficiency.',
        ),
      ]),
];

class Constants {
  // static const baseUrl = String.fromEnvironment("baseUrl");

  //multi usage texts
  static const offlineAlert = "Please check your internet connection!";
  static const encryptionKey = "goodwillhush2023";
  static const exitText = "Press again to exit!";
  static const logIn = "Log in";
  static const getStarted = "Get Started";
  static const signUp = "Sign up";
  static const yourName = "Tell us your name";
  static const yourDateOfBirth = "Tell us your date of birth";
  static const yourEmailAddress = "Tell us your email address";
  static const yourEmail = "Your Email";
  static const yourPhoneNumber = "Phone number";
  static const password = "Password";
  static const otp = "OTP";
  static const enterEmail = "Email is Required!";
  static const enterName = "name required";
  static const enterDateOfBirth = "D.O.B required";
  static const enterNumber = "Phone number required";
  static const enterValidEmail = "Email must be valid!";
  static const emailVerificationLink = "Email verification link has been sent!";
  static const enterPassword = "Password required";
  static const enterOtp = "OTP required";
  static const loading = "Loading..";
  static const invalidVerificationCode = "Invalid verification code";
  static const invalidPhoneNumber = "Invalid phone number";
  static const pleaseTryAgain = "Please try again after some time!";
  static const fileFormatNotSupported = "File format not supported!";
  static const sessionExpired = "Session expired. Please try again!";

  //On board screen texts
  static const skip = "Skip";
  static const onBoardScreenFirstTextControl =
      "Control and manage your data with your privacy first choices";
  static const onBoardScreenSecondTextMineYour =
      "Mine your data into monetary assets like coins";

  //Sign up screen texts
  static const enterYourDetails = "Enter your details below & free sign up";
  static const createAccount = "Sign in";
  static const next = "Next";
  static const signUpCheckText =
      "By creating an account you have to agree with our terms & conditions.";
  static const alreadyHaveAccount = "Already have an account?";
  static const loginWithPhoneNumber = "login with phone number & otp";
  static const signUpCheck =
      "Please agree our terms & conditions before sign up";
  static const passwordTooWeak = "The password provided is too weak.";
  static const accountAlreadyExist =
      "The account already exists for that email. Please Sign in!";
  static const verifyEmail = "VERIFY YOUR EMAIL ADDRESS";

  //Login screen texts
  static const forgotPassword = "Forgot password?";
  static const doNotHaveAccount = "Don't have an account?";
  static const orLoginWith = "Or login with";
  static const userNotFound = "You haven't signed up yet. Please sign up!";
  static const incorrectCredentials = "Incorrect Credentials";

  //Forgot password tets
  static const proceed = "Proceed";
  static const StripeSecretKeyTest =
      "sk_test_51M2VQ0LYaD0u4Aj1Khu5C5vYZXO08vLUluF2FSD5yYp8QFF8EIuddEAkWmzc3bLX0nYDgrqMOs8Yn1uoC6vp6RRD00G1Is6hz4";
  static const StripeSecretKeyLive =
      "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";

  static const int otpLength = 6;

  static const int financeCardId = 63;

  static const int healthCardId = 130;

  static const int browseCardId = 65;

  static const int businessCardId = 212;

  static const int appUsageCardId = 253;

  static const int expenseCardId = 254;

  static const int wishlistCardId = 133;

  static const int insuranceCardId = 237;

  static const int travelCardId = 64;

  static const int coffeeCardId = 58;

  static const int hushhIdCardId = 132;

  static const int personalCardId = 131;

  static const int fashionCardId = 61;

  static const String baseUrl = String.fromEnvironment('base_url');
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NotificationsConstants {
  static const int ASKING_USER_REASON_TO_ENTER_IN_BRAND_STORE = 0;

  static const int INFORMING_AGENT_ABOUT_USER_REQUEST = 1;

  static const int NEW_RECEIPTS_BATCH_COMPLETED = 2;

  static const int PAYMENT_REQUEST_RECEIVED_FROM_AGENT = 3;

  static const int DATA_REQUEST = 101;

}