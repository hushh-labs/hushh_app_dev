// ignore_for_file: constant_identifier_names

import 'package:hive_flutter/hive_flutter.dart';

part 'enums.g.dart';

enum NetworkException { noInternetConnection, timeOutError, unknown }

enum HttpException { unAuthorized, internalServerError, unknown }

enum EmailProvider { google, outlook, yahoo }

enum HealthDataState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTH_NOT_GRANTED
}

enum CustomCardQuestionsType { hushhIdCard, demographicCard }

@HiveType(typeId: 8)
enum CustomCardAnswerType {
  @HiveField(0)
  text,
  @HiveField(1)
  choice,
  @HiveField(2)
  calendar,
  @HiveField(3)
  numberText,
  @HiveField(4)
  social,
}

@HiveType(typeId: 0)
enum UserOnboardStatus {
  @HiveField(0)
  initial,
  @HiveField(1)
  onboardDone,
  @HiveField(2)
  signUpForm,
  @HiveField(3)
  loggedIn,
}

@HiveType(typeId: 9)
enum OnboardStatus {
  @HiveField(0)
  authenticated,
  @HiveField(1)
  signed_up
}

@HiveType(typeId: 2)
enum Entity {
  @HiveField(0)
  user,
  @HiveField(1)
  agent,
  @HiveField(2)
  button_Admin
}

@HiveType(typeId: 4)
enum AgentApprovalStatus {
  @HiveField(0)
  approved,
  @HiveField(1)
  pending,
  @HiveField(2)
  denied
}

@HiveType(typeId: 10)
enum BrandApprovalStatus {
  @HiveField(0)
  approved,
  @HiveField(1)
  pending,
  @HiveField(2)
  denied
}

enum TaskType { phone, email, meeting }

enum CustomFormType { text, date, list, filter, duration, dateTime, web }

enum ConversationType { agent, user }

enum MeetingType { online, walkIn }

enum CardType { brandCard, preferenceCard }

enum PaymentStatus { declined, pending, accepted }

enum PaymentMethods { card, razorpay, upi, usdc, gPay, aPay, hushhCoins }

enum AgentProductsPageStatus { selectProducts, lookbookOpened, viewAll }

enum HushhProduct { hushhApp, hushhButton, hushhExtension, hushhVibeSearch }

enum DayNight { day, night }

enum NfcOperation { read, write }

enum AiMode { single, chat }

enum LoginMode { google, apple, phone }

enum OtpVerificationType { email, phone }

enum UserGuideQuestionType {
  name,
  emailOrPhone,
  dob,
  record,
  multiChoiceQuestion,
  categories
}

enum MultiChoiceQuestions { whyInstallHushh, whatGender }

enum ReceiptRadarSortType {
  newestFirst,
  oldestFirst,
  lowToHighTotalPrice,
  highToLowTotalPrice,
}

@HiveType(typeId: 12)
enum AgentRole {
  @HiveField(0)
  Admin,
  @HiveField(1)
  Owner,
  @HiveField(2)
  InventoryManager,
  @HiveField(3)
  SalesManager,
  @HiveField(4)
  ContentManager,
  @HiveField(5)
  SalesAgent,
  @HiveField(6)
  Support,
}

enum InventoryServer { gsheets_public_server, whatsapp }

enum TravelType {
  bus,
  train,
  airplane,
  taxi,
  bike,
  rickshaw,
}

enum InsuranceType {
  travel,
  health,
  term,
  vehicle,
  property,
  liability,
  life,
  business,
  others
}

enum ComprehensiveCoverageTypePolicy { yes, no }

enum BrandCategoryEnum {
  fashionAndApparel,
  jewelryAndWatches,
  beautyAndPersonalCare,
  automobiles,
  realEstate,
  travelAndLeisure,
  homeAndLifestyle,
  technologyAndElectronics,
  sportsAndLeisure,
  artAndCollectibles,
  healthAndWellness,
  stationeryAndWritingInstruments,
  childrenAndBaby,
  petAccessories,
  services,
  financialServices,
  airlineServices,
  accommodationServices,
  beveragesServices,
  culinaryServices,
  insurance,
  foodDeliveryService,
  hospitality,
  coupons,
  others
}

enum CardQuestionType {
  multiSelectQuestion,
  singleSelectQuestion,
  textNoteQuestion,
  audioNoteQuestion,
  imageGridQuestion,
  imageSwipeQuestion,
  singleImageUploadQuestion,
  multiImageUploadQuestion
}

enum ProductTileType { selectProducts, editProducts, viewProducts }

enum CardInfoUnlockMethod { byUser, byAgent }

enum NotificationType {
  system,
  ai_chat,
  interaction,
  location,
  chat,
  data_consent
}