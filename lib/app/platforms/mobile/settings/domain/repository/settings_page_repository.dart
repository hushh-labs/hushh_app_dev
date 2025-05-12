import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/app_usage_data.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/browsed_collection.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/browsed_product_model.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

abstract class SettingsPageRepository {
  Future<Either<ErrorState, void>> deleteAccount();

  Future<Either<ErrorState, List<DateTime>>> fetchBrowsingBehaviourVisitTimes(
      String hushhId);

  Future<Either<ErrorState, List<BrowsedProduct>>>
      fetchBrowsingBehaviourProducts(String hushhId);

  Future<Either<ErrorState, List<BrowsedCollection>>>
      fetchBrowsingBehaviourWishList(String hushhId);

  Future<Either<ErrorState, int?>> fetchAppUsageCount(String hushhId);

  Future<Either<ErrorState, void>> insertMultipleAppUsages(
      List<AppUsageData> appUsages);

  Future<Either<ErrorState, void>> afterUsageInserted(
      List<AppUsageData> appUsages);

  Future<Either<ErrorState, List<String>>> fetchAppIds();

  Future<Either<ErrorState, void>> insertBrowsedProduct(BrowsedProduct product);

  Future<Either<ErrorState, bool>> initiateLoginInExtensionWithHushhQr(String code);

  Future<Either<ErrorState, void>> linkHushhIdWithExtension(String hushhId, String code);
}
