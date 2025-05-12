part of 'dependencies.dart';

Future<void> injectBlocs() async {
  // initialize blocs
  sl.registerSingleton(SplashPageBloc(
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
  ));

  sl.registerSingleton(HomePageBloc(sl(), sl()));

  sl.registerSingleton(CardMarketBloc(
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
  ));
  sl.registerSingleton(OnboardingPageBloc());

  sl.registerSingleton(AuthPageBloc(
    sl(),
    sl(),
    sl(),
    sl(),
  ));
  sl.registerSingleton(SignUpPageBloc(
    sl(),
    sl(),
  ));

  sl.registerSingleton(SettingsPageBloc(sl(), sl(), sl(), sl(), sl(), sl(),
      sl(), sl(), sl(), sl(), sl(), sl(), sl()));

  sl.registerSingleton(CardWalletPageBloc(
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
  ));

  sl.registerSingleton(AgentCardWalletPageBloc(
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
  ));

  sl.registerSingleton(ChatPageBloc(
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
  ));

  sl.registerSingleton(AiChatPageBloc(
    sl(),
    sl(),
    sl(),
  ));

  sl.registerSingleton(AgentSignUpPageBloc(
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
  ));

  sl.registerSingleton(HushhMeetBloc(
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
  ));

  sl.registerSingleton(AgentTaskBloc(
    sl(),
    sl(),
    sl(),
  ));
  sl.registerSingleton(HealthBloc(
    sl(),
    sl(),
  ));
  sl.registerSingleton(NotificationsBloc(
    sl(),
    sl(),
    sl(),
  ));
  sl.registerSingleton(PlaidBloc());
  sl.registerSingleton(ReceiptRadarBloc(sl(), sl()));
  sl.registerSingleton(SharedAssetsReceiptsBloc(
    sl(),
    sl(),
    sl(),
  ));
  sl.registerSingleton(LookBookProductBloc(
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
  ));
  sl.registerSingleton(InventoryBloc(
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
    sl(),
  ));
  sl.registerSingleton(CardShareEcosystemBloc(
    sl(),
    sl(),
    sl(),
    sl(),
  ));
}
