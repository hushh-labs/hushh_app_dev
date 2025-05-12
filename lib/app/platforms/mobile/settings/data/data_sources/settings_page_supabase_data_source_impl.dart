import 'package:hushh_app/app/platforms/mobile/settings/data/models/app_usage_data.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/browsed_product_model.dart';
import 'package:hushh_app/app/shared/core/backend_controller/db_controller/db_tables.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'settings_page_supabase_data_source.dart';

class SettingsPageSupabaseDataSourceImpl
    extends SettingsPageSupabaseDataSource {
  final supabase = Supabase.instance.client;

  @override
  Future<void> deleteUser() async {
    await supabase
        .from(DbTables.usersTable)
        .delete()
        .eq('hushh_id', AppLocalStorage.hushhId!);
  }

  @override
  Future<List<String>> fetchBrowsingBehaviourVisitTimes(String hushhId) async {
    return (await supabase
            .from(DbTables.browsingBehaviorTable)
            .select('visit_time')
            .eq('hushh_id', hushhId))
        .map((e) => e['visit_time'] as String?)
        .where((element) => element != null)
        .map((e) => e!)
        .toList();
  }

  @override
  Future<List<Map<String, dynamic>>> fetchBrowsingBehaviourProducts(
      String hushhId) async {
    return await supabase
        .from(DbTables.browsingProductsTable)
        .select('*, brand: brands ( * )')
        .eq('user_id', hushhId);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchBrowsingBehaviourWishList(
      String hushhId) async {
    return await supabase
        .from(DbTables.browsingCollectionsTable)
        .select('collection_id, collection_name, products')
        .eq('hushh_id', hushhId);
  }

  @override
  Future<int?> fetchAppUsageCount(String hushhId) async {
    return (await supabase
            .from(DbTables.appUsageTable)
            .select()
            .eq('hushh_id', hushhId)
            .count())
        .count;
  }

  @override
  Future<void> insertMultipleAppUsages(List<AppUsageData> appUsages) async {
    await supabase
        .from(DbTables.appUsageTable)
        .insert(appUsages.map((e) => e.toJson()).toList());
  }

  @override
  Future<bool> initiateLoginInExtensionWithHushhQr(String code) async {
    int count = (await supabase
            .from(DbTables.appExtensionQrLogin)
            .select()
            .eq('code', code)
            .count())
        .count;
    return count >= 1;
  }

  @override
  Future<void> linkHushhIdWithExtension(String hushhId, String code) async {
    await supabase
        .from(DbTables.appExtensionQrLogin)
        .update({'hushh_id': hushhId}).eq('code', code);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchAppIds() async {
    return await supabase.from(DbTables.userAppsTable).select('app_id');
  }

  @override
  Future<void> insertBrowsedProduct(BrowsedProduct product) async {
    final data = product.toJson();
    data['brand_name'] = data['brand'];
    data.remove('brand');
    try {
      if (product.brand != null) {
        await supabase
            .from(DbTables.browsingBrandsTable)
            .insert(product.brand!.toJson());
      }
    } catch (_) {}

    await supabase.from(DbTables.browsingProductsTable).insert(data);
  }
}
