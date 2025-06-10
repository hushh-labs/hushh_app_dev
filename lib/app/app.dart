import 'dart:async';
import 'dart:convert';
import 'dart:io';

// import 'package:app_usage/app_usage.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/splash/presentation/bloc/splash_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/firebase_config/firebase_remote_config_service.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/notification_service.dart';
import 'package:hushh_app/app/shared/core/utils/receive_sharing_intent_helper.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:wiredash/wiredash.dart';

import 'shared/core/utils/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService().initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions();
  int id = int.parse(message.data['notification_id'].toString());
  NotificationService().showNotification(id, message.data['title'],
      message.data['description'], jsonDecode(message.data['payload']));
}

Future<SecurityContext> get globalContext async {
  final sslCert = await rootBundle.load('assets/sup-certificate.pem');
  SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
  securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
  return securityContext;
}

Future<Client> getSSLPinningClient() async {
  HttpClient client = HttpClient(context: await globalContext);
  client.badCertificateCallback =
      (X509Certificate cert, String host, int port) => false;
  IOClient ioClient = IOClient(client);
  return ioClient;
}

void app(Entity entity) async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    Gemini.init(apiKey: const String.fromEnvironment('gemini_api_key'));
    // Initialize Firebase with options from firebase_options.dart
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await NotificationService().initialize();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.instance.onTokenRefresh.listen((event) {
      if (AppLocalStorage.isUserLoggedIn) {
        sl<SplashPageBloc>()
            .add(UpdateUserRegistrationTokenEvent(token: event));
      }
    });

    await Supabase.initialize(
      url: const String.fromEnvironment('supabase_url'),
      anonKey: const String.fromEnvironment('supabase_anon_key'),
      // httpClient: await getSSLPinningClient()
    );


    await AppLocalStorage.initialize();
    try {
      await FirebaseRemoteConfigService().initialize();
    } catch (_) {
      throw Exception('Firebase Remote Config error');
    }

    await initializeDependencies();
    sl<HomePageBloc>().entity = entity;

    if (!kIsWeb) {
      // Configure system UI overlay and preferred orientations
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ));

      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

      // Enable Crashlytics collection and handle Flutter errors
      FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
    }

    sl<Talker>().log('APP_OPENED');

    if (!kIsWeb) {
      FGBGEvents.instance.stream.listen((event) {
        if (event == FGBGType.foreground) {
          sl<Talker>().log('APP_MOVED_TO_FG');
        } else {
          sl<Talker>().log('APP_MOVED_TO_BG');
        }
      });
    }

    // Run the app
    runApp(const HushhInitial());
  }, (error, stackTrace) {
    if (!kIsWeb) {
      try {
        sl<Talker>().handle(error, stackTrace, 'Uncaught app exception');
      } catch (_) {}
    }
  });
}

// Widget to initialize the app
class HushhInitial extends StatefulWidget {
  const HushhInitial({Key? key}) : super(key: key);

  @override
  State<HushhInitial> createState() => _HushhInitialState();
}

class _HushhInitialState extends State<HushhInitial>
    with WidgetsBindingObserver {
  ReceiveSharingIntentHelper receiveSharingIntentHelper =
      ReceiveSharingIntentHelper();
  late double width;
  late double height;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    receiveSharingIntentHelper.intentSub.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    receiveSharingIntentHelper.initialize();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    WidgetsBinding.instance.addObserver(this);
    if (AppLocalStorage.hushhId != null) {}
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return DevicePreview(
      enabled: !isMobile && kIsWeb,
      // isToolbarVisible: true,
      builder: (context) => Wiredash(
        projectId: const String.fromEnvironment('wire_dash_project_id'),
        secret: const String.fromEnvironment('wire_dash_secret'),
        child: ResponsiveSizer(
          builder: (context, orientation, screenType) => MaterialApp(
            navigatorKey: navigatorKey,
            locale: DevicePreview.locale(context),
            navigatorObservers: [
              TalkerRouteObserver(sl<Talker>()),
            ],
            builder: DevicePreview.appBuilder,
            theme: ThemeData(
              brightness: Brightness.light,
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                surfaceTintColor: Colors.transparent,
              ),
              fontFamily: "Figtree",
            ),
            supportedLocales: const [Locale('en', 'US')],
            debugShowCheckedModeBanner: false,
            routes: !kIsWeb
                ? NavigationManager.routes
                : NavigationManager.webRoutes,
            // onGenerateRoute: (settings) {
            //   switch (settings.name) {
            //     case AppRoutes.userGuidePage:
            //       return PageTransition(
            //         child: const CreateFirstCardPage(),
            //         type: PageTransitionType.bottomToTop,
            //       );
            //     default:
            //       return null;
            //   }
            // },
          ),
        ),
      ),
    );
  }
}
