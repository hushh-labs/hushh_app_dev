part of 'dependencies.dart';

Future<void> injectDataSources() async {
  // initialize dataSources
  sl.registerSingleton(AuthPageSupabaseDataSourceImpl());

  sl.registerSingleton(CardMarketSupabaseDataSourceImpl());

  sl.registerSingleton(ReceiptRadarPageSupabaseDataSourceImpl());

  sl.registerSingleton(CardWalletPageSupabaseDataSourceImpl());

  sl.registerSingleton(SettingsPageSupabaseDataSourceImpl());

  sl.registerSingleton(SplashPageSupabaseDataSourceImpl());

  sl.registerSingleton(ChatSupabaseDataSourceImpl());

  sl.registerSingleton(SettingsPageApiDataSource(sl()));

  sl.registerSingleton(CardWalletPageApiDataSourceImpl());

  sl.registerSingleton(CardMarketApiDataSource(sl()));

  sl.registerSingleton(CardShareEcoSystemDataSourceImpl());
}
