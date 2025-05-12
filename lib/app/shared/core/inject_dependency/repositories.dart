part of 'dependencies.dart';

Future<void> injectRepositories() async {
  // initialize repositories
  sl.registerSingleton(AuthPageRepositoryImpl(sl()));

  sl.registerSingleton(SettingsPageRepositoryImpl(sl(), sl()));

  sl.registerSingleton(CardWalletPageRepositoryImpl(sl(), sl()));

  sl.registerSingleton(CardMarketRepositoryImpl(sl(), sl()));

  sl.registerSingleton(ChatRepositoryImpl(sl()));

  sl.registerSingleton(ReceiptRadarPageRepositoryImpl(sl()));

  sl.registerSingleton(SplashPageRepositoryImpl(sl()));

  sl.registerSingleton(CardShareEcoSystemRepositoryImpl(sl()));
}
