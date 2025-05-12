import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hushh_app/app/platforms/mobile/auth/data/models/agent_category.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/agent.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/temp_user.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/user.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/brand.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_question_answer_model.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/backend_controller/auth_controller/auth_controller_impl.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class Boxes {
  static const String user = 'user_data';
  static const String tempUser = 'temp_user_data';
  static const String agent = 'agent_data';
  static const String contactList = 'contactList';
  static const String receiptInfo = 'receipt-info';
  static const String other = 'other';
  static const String plaid = 'plaid';
}

class AppLocalStorage {
  static final boxes = <String>[
    Boxes.user,
    Boxes.agent,
    Boxes.contactList,
    Boxes.receiptInfo,
    Boxes.other,
    Boxes.plaid,
    Boxes.tempUser
  ];

  static List<int> generateKey(boxName) {
    var bytes = utf8.encode(_getSecretKey());
    var hmacSha256 = Hmac(sha256, bytes);
    var key = hmacSha256.convert(utf8.encode(boxName));
    return key.bytes;
  }

  static String _getSecretKey() {
    // ignore: prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation
    return 'utf8' +
        'encode' +
        '_getSecretKey' +
        '(ffd90ee21e57aa858' +
        'f68879d659bbce1)';
  }

  static Future<void> refresh() async {
    await sl<AuthController>().signOut();
    for (String box in boxes) {
      await Hive.deleteBoxFromDisk(box);
    }
    for (int i = 0; i < boxes.length; i++) {
      await Hive.openBox(
        boxes[i],
        // encryptionCipher: HiveAesCipher(generateKey(boxes[i])),
      );
    }
  }

  static void _register() {
    Hive.registerAdapter(CustomCardAnswerTypeAdapter());
    Hive.registerAdapter(CardQuestionAnswerModelAdapter());
    Hive.registerAdapter(UserOnboardStatusAdapter());
    Hive.registerAdapter(OnboardStatusAdapter());
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(AgentModelAdapter());
    Hive.registerAdapter(EntityAdapter());
    Hive.registerAdapter(AgentApprovalStatusAdapter());
    Hive.registerAdapter(AgentCategoryAdapter());
    Hive.registerAdapter(BrandAdapter());
    Hive.registerAdapter(AgentRoleAdapter());
    Hive.registerAdapter(CardModelAdapter());
    Hive.registerAdapter(BrandApprovalStatusAdapter());
    Hive.registerAdapter(TempUserModelAdapter());
  }

  static Future<void> initialize() async {
    await Hive.initFlutter();
    // await refresh();
    _register();
    for (int i = 0; i < boxes.length; i++) {
      await Hive.openBox(boxes[i]);
    }
  }

  static UserModel? get user => Hive.box(Boxes.user).get('value');

  static TempUserModel? get tempUser => Hive.box(Boxes.tempUser).get('value');

  static AgentModel? get agent => Hive.box(Boxes.agent).get('value');

  static bool get isUserInActive {
    String? lastActiveTimeStamp = Hive.box(Boxes.other).get('last_active_time_stamp');

    if (lastActiveTimeStamp != null) {
      DateTime lastActive = DateTime.parse(lastActiveTimeStamp);
      DateTime sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));

      // If last active time is before 7 days ago, the user is inactive
      return lastActive.isBefore(sevenDaysAgo);
    }
    return false; // Assume inactive if no timestamp exists
  }

  static Future setUserActiveState() =>
      Hive.box(Boxes.other).put('last_active_time_stamp', DateTime.now().toIso8601String());

  static String? get lastSyncedPlaceName =>
      Hive.box(Boxes.other).get('last_synced_place_name');

  static void updateLastSyncedPlaceName(String? place) =>
      Hive.box(Boxes.other).put('last_synced_place_name', place);

  static String? get lastSyncedEmail =>
      Hive.box(Boxes.other).get('last_synced_email');

  static void updateLastSyncedEmail(String email) =>
      Hive.box(Boxes.other).put('last_synced_email', email);

  static String? get plaidAccessToken =>
      Hive.box(Boxes.plaid).get('access_token');

  static String? get plaidInstitutionName =>
      Hive.box(Boxes.plaid).get('plaid_institution_name');

  static String? get hushhId => Hive.box(Boxes.other).get('hushh_id');

  static bool get isAppUsagePermissionProvided =>
      Hive.box(Boxes.other).get('is_app_usage_permission_provided') ?? false;

  static void setAppUsagePermission(bool perm) =>
      Hive.box(Boxes.other).put('is_app_usage_permission_provided', perm);

  static bool get isTutorialWatched =>
      Hive.box(Boxes.other).get('is_tutorial_watched') ?? false;

  static void tutorialWatched([bool value = false]) =>
      Hive.box(Boxes.other).put('is_tutorial_watched', value);

  static bool get isUserLoggedIn =>
      user != null && userOnboardStatus == UserOnboardStatus.loggedIn;

  static bool get isReceiptRadarFetchingReceipts =>
      (Hive.box(Boxes.receiptInfo).get('session_id') != null);

  static String? get receiptRadarSessionId =>
      (Hive.box(Boxes.receiptInfo).get('session_id'));

  static void setSessionIdForReceiptRadar(String? id) =>
      (Hive.box(Boxes.receiptInfo).put('session_id', id));

  static bool get hasUserConnectedHealthInsights =>
      (Hive.box(Boxes.other).get('health_connected') == true);

  static void userConnectHealthInsights(bool value) =>
      (Hive.box(Boxes.other).put('health_connected', value));

  static bool get hasUserConnectedReceiptRadar =>
      (Hive.box(Boxes.receiptInfo).get('access_token') != null);

  static void userConnectReceiptRadar(String? id) =>
      (Hive.box(Boxes.receiptInfo).put('access_token', id));

  static UserOnboardStatus get userOnboardStatus =>
      Hive.box(Boxes.other).get('user_onboard_status') ??
      UserOnboardStatus.initial;

  static bool get isContactsLookupTableCreated =>
      Hive.box(Boxes.contactList).isNotEmpty;

  static void putContactInLookupTable(
      String contactIdentifier, bool isHushUser) {
    Hive.box(Boxes.contactList).put(contactIdentifier, isHushUser);
  }

  static void putPlaidAccessToken(String accessToken) {
    Hive.box(Boxes.plaid).put("access_token", accessToken);
  }

  static void putPlaidInstitutionName(String name) {
    Hive.box(Boxes.plaid).put("plaid_institution_name", name);
  }

  static void updateHushhId(String uid) {
    Hive.box(Boxes.other).put('hushh_id', uid);
  }

  static void updateUserOnboardingStatus(UserOnboardStatus status) {
    Hive.box(Boxes.other).put('user_onboard_status', status);
  }

  static void updateUser(UserModel user) {
    Hive.box(Boxes.user).put('value', user);
  }

  static void updateTempUser(TempUserModel user) {
    Hive.box(Boxes.tempUser).put('value', user);
  }

  static Future<void> updateAgent(AgentModel agent) async {
    await Hive.box(Boxes.agent).put('value', agent);
  }

  static Future<void> logout() async {
    await refresh();
  }

  static void storeReceiptRadarEncryptedToken(String? cipherText) {
    Hive.box(Boxes.other).put('receipt_radar_token', cipherText);
  }

  static String? get receiptRadarEncryptedToken =>
      Hive.box(Boxes.other).get('receipt_radar_token');
}
