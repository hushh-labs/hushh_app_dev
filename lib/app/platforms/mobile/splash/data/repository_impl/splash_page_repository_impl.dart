import 'package:dartz/dartz.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/brand_location.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/user_brand_location_trigger_model.dart';
import 'package:hushh_app/app/platforms/mobile/splash/data/data_sources/splash_page_supabase_data_source_impl.dart';
import 'package:hushh_app/app/platforms/mobile/splash/domain/repository/splash_page_repository.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_handler.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class SplashPageRepositoryImpl extends SplashPageRepository {
  final SplashPageSupabaseDataSourceImpl splashPageApiDataSource;

  SplashPageRepositoryImpl(this.splashPageApiDataSource);

  @override
  Future<Either<ErrorState, void>> updateUserRegistrationToken(
      String token, String hushhId) async {
    return await ErrorHandler.callSupabase(
      () => splashPageApiDataSource.updateUserRegistrationToken(token, hushhId),
      (value) {},
    );
  }

  @override
  Future<Either<ErrorState, List<BrandLocation>>> fetchAllNearbyBrands(
      Placemark place, List<CardModel> installedBrandCards) async {
    return await ErrorHandler.callSupabase(
      () => splashPageApiDataSource.fetchAllNearbyBrands(place, installedBrandCards),
      (value) {
        final result = value as List<Map<String, dynamic>>;
        return result.map((e) => BrandLocation.fromJson(e)).toList();
      },
    );
  }

  @override
  Future<Either<ErrorState, void>> insertUserBrandLocationTrigger(
      UserBrandLocationTriggerModel userBrandLocationTrigger) async {
    return await ErrorHandler.callSupabase(
      () => splashPageApiDataSource
          .insertUserBrandLocationTrigger(userBrandLocationTrigger),
      (value) {},
    );
  }

  @override
  Future<Either<ErrorState, void>> shareUserProfileAndRequirementsWithAgent(
      String agentId, String query, int cardId, String senderHushhId) async {
    return await ErrorHandler.callSupabase(
      () => splashPageApiDataSource
          .shareUserProfileAndRequirementsWithAgent(agentId, query, cardId, senderHushhId),
      (value) {},
    );
  }
}
