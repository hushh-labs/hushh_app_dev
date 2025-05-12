part of 'settings_page_supabase_data_source_impl.dart';

abstract class SettingsPageSupabaseDataSource {
  Future<void> deleteUser();

  Future<List<String>> fetchBrowsingBehaviourVisitTimes(String hushhId);

  Future<List<Map<String, dynamic>>> fetchBrowsingBehaviourProducts(
      String hushhId);

  Future<List<Map<String, dynamic>>> fetchBrowsingBehaviourWishList(
      String hushhId);

  Future<int?> fetchAppUsageCount(String hushhId);

  Future<void> insertMultipleAppUsages(List<AppUsageData> appUsages);

  Future<void> initiateLoginInExtensionWithHushhQr(String code);

  Future<void> linkHushhIdWithExtension(String hushhId, String code);

  Future<List<Map<String, dynamic>>> fetchAppIds();

  Future<void> insertBrowsedProduct(BrowsedProduct product);
}
