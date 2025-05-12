import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:hushh_app/app/shared/core/firebase_config/firebase_remote_config_keys.dart';

class FirebaseRemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  static FirebaseRemoteConfigService? _instance;

  factory FirebaseRemoteConfigService() =>
      _instance ??= FirebaseRemoteConfigService._();

  FirebaseRemoteConfigService._();

  Future<void> initialize() async {
    await _setConfigSettings();
    await _setDefaults();
    await fetchAndActivate();
    print(FirebaseRemoteConfigService().receiptRadarApi);
  }

  Future<void> fetchAndActivate() async {
    bool updated = await _remoteConfig.fetchAndActivate();

    if (updated) {
    } else {
    }
  }

  Future<void> _setDefaults() async => _remoteConfig.setDefaults(
        <String, dynamic>{
          FirebaseRemoteConfigKeys.nonDisclaimerPolicy:
              'https://www.linkedin.com/company/hushh-ai/',
          FirebaseRemoteConfigKeys.paymentTermsService:
              'https://sites.google.com/hush1one.com/drops/uiux',
          FirebaseRemoteConfigKeys.privacyPolicy: 'https://www.hush1one.com/',
          FirebaseRemoteConfigKeys.termsOfService:
              'https://sites.google.com/hush1one.com/drops/home',
          FirebaseRemoteConfigKeys.receiptRadarApi:
              'wss://hushh-hushh-valet-chat.hf.space/websockets/ws',
          FirebaseRemoteConfigKeys.hushhUpiId: '',
          FirebaseRemoteConfigKeys.logosToken: 'live_6a1a28fd-6420-4492-aeb0-b297461d9de2',
          FirebaseRemoteConfigKeys.sttUrl: '',
          FirebaseRemoteConfigKeys.iosLink: 'https://bit.ly/hushh-app-ios',
          FirebaseRemoteConfigKeys.androidLink: 'https://bit.ly/hushh-app-ios',
          FirebaseRemoteConfigKeys.receiptRadarQuery: 'label:^smartlabel_receipt OR (subject:"your order" OR subject:receipts OR subject:receipt OR subject:aankoopbon OR subject:reçu OR subject:invoice OR subject:invoices OR category:purchases) has:attachment filename:pdf',
          // : 'label:^smartlabel_receipt has:attachment filename:pdf',
          FirebaseRemoteConfigKeys.receiptRadarBrandQuery: 'label:^smartlabel_receipt OR (subject:"your order" OR subject:receipts OR subject:receipt OR  subject: aankoopbon  OR subject:reçu OR subject:invoice OR subject:invoices OR category:purchases OR from:{brandName}) AND subject:{brandName} has:attachment filename:pdf',
          // ? 'label:^smartlabel_receipt ($brandName OR "$brandName" OR "${brandName.toLowerCase()} OR ${brandName.toUpperCase()}") has:attachment filename:pdf'
        },
      );

  Future<void> _setConfigSettings() async => _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(minutes: 1),
        ),
      );

  String get nonDisclaimerPolicy =>
      _remoteConfig.getString(FirebaseRemoteConfigKeys.nonDisclaimerPolicy);

  String get paymentTermsService =>
      _remoteConfig.getString(FirebaseRemoteConfigKeys.paymentTermsService);

  String get privacyPolicy =>
      _remoteConfig.getString(FirebaseRemoteConfigKeys.privacyPolicy);

  String get termsOfService =>
      _remoteConfig.getString(FirebaseRemoteConfigKeys.termsOfService);

  String get receiptRadarApi =>
      _remoteConfig.getString(FirebaseRemoteConfigKeys.receiptRadarApi);

  String get hushhUpiId =>
      _remoteConfig.getString(FirebaseRemoteConfigKeys.hushhUpiId);

  String get receiptRadarQuery =>
      _remoteConfig.getString(FirebaseRemoteConfigKeys.receiptRadarQuery);

  String get receiptRadarBrandQuery =>
      _remoteConfig.getString(FirebaseRemoteConfigKeys.receiptRadarBrandQuery);

  String get androidLink =>
      _remoteConfig.getString(FirebaseRemoteConfigKeys.androidLink);

  String get iosLink =>
      _remoteConfig.getString(FirebaseRemoteConfigKeys.iosLink);

  String get logosToken =>
      _remoteConfig.getString(FirebaseRemoteConfigKeys.logosToken);

  String get sttUrl =>
      _remoteConfig.getString(FirebaseRemoteConfigKeys.sttUrl);
}
