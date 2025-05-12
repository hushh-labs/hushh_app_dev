import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/data_sources/settings_page_api_data_source.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/data_sources/settings_page_supabase_data_source_impl.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/app_usage_data.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/browsed_collection.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/browsed_product_model.dart';
import 'package:hushh_app/app/platforms/mobile/settings/domain/repository/settings_page_repository.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_handler.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class SettingsPageRepositoryImpl extends SettingsPageRepository {
  final SettingsPageSupabaseDataSourceImpl settingsPageSupabaseDataSource;
  final SettingsPageApiDataSource settingsPageApiDataSource;

  SettingsPageRepositoryImpl(
    this.settingsPageSupabaseDataSource,
    this.settingsPageApiDataSource,
  );

  @override
  Future<Either<ErrorState, void>> deleteAccount() async {
    return await ErrorHandler.callSupabase(
        () => settingsPageSupabaseDataSource.deleteUser(), (result) {});
  }

  @override
  Future<Either<ErrorState, List<DateTime>>> fetchBrowsingBehaviourVisitTimes(
      String hushhId) async {
    return await ErrorHandler.callSupabase(
        () => settingsPageSupabaseDataSource
            .fetchBrowsingBehaviourVisitTimes(hushhId), (result) {
      final data = result as List<String>;
      return data.map((e) => DateTime.parse(e)).toList();
    });
  }

  @override
  Future<Either<ErrorState, List<BrowsedProduct>>>
      fetchBrowsingBehaviourProducts(String hushhId) async {
    return await ErrorHandler.callSupabase(
        () => settingsPageSupabaseDataSource
            .fetchBrowsingBehaviourProducts(hushhId), (result) {
      final data = result as List<Map<String, dynamic>>;
      return data.map((e) => BrowsedProduct.fromJson(e)).toList();
    });
  }

  @override
  Future<Either<ErrorState, List<BrowsedCollection>>>
      fetchBrowsingBehaviourWishList(String hushhId) async {
    return await ErrorHandler.callSupabase(
        () => settingsPageSupabaseDataSource
            .fetchBrowsingBehaviourWishList(hushhId), (result) {
      final data = result as List<Map<String, dynamic>>;
      return data.map((e) {
        final json = e;
        json['collection_data'] = json['collection_data'] ?? [];
        return BrowsedCollection.fromJson(json);
      }).toList();
    });
  }

  @override
  Future<Either<ErrorState, int?>> fetchAppUsageCount(String hushhId) async {
    return await ErrorHandler.callSupabase(
        () => settingsPageSupabaseDataSource.fetchAppUsageCount(hushhId),
        (result) {
      final data = result as int?;
      return data;
    });
  }

  @override
  Future<Either<ErrorState, void>> insertMultipleAppUsages(
      List<AppUsageData> appUsages) async {
    return await ErrorHandler.callSupabase(
        () => settingsPageSupabaseDataSource.insertMultipleAppUsages(appUsages),
        (result) {});
  }

  @override
  Future<Either<ErrorState, void>> afterUsageInserted(
      List<AppUsageData> appUsages) async {
    return await ErrorHandler.callApi(
        () => settingsPageApiDataSource.afterUsageInserted(appUsages),
        (result) {});
  }

  @override
  Future<Either<ErrorState, List<String>>> fetchAppIds() async {
    return await ErrorHandler.callSupabase(
        () => settingsPageSupabaseDataSource.fetchAppIds(), (result) {
      final data = result as List<Map<String, dynamic>>;
      return data.map((e) => e['app_id'] as String).toList();
    });
  }

  @override
  Future<Either<ErrorState, void>> insertBrowsedProduct(
      BrowsedProduct product) async {
    return await ErrorHandler.callSupabase(
        () => settingsPageSupabaseDataSource.insertBrowsedProduct(product),
        (result) {});
  }

  @override
  Future<Either<ErrorState, bool>> initiateLoginInExtensionWithHushhQr(
      String code) async {
    return await ErrorHandler.callSupabase(
        () => settingsPageSupabaseDataSource.initiateLoginInExtensionWithHushhQr(code),
        (result) {
          final data = result as bool;
          return data;
        });
  }

  @override
  Future<Either<ErrorState, void>> linkHushhIdWithExtension(String hushhId, String code) async {
    return await ErrorHandler.callSupabase(
            () => settingsPageSupabaseDataSource.linkHushhIdWithExtension(hushhId, code),
            (result) {});
  }
}
