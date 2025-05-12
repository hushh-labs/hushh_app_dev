import 'package:dartz/dartz.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/brand_location.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/user_brand_location_trigger_model.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

abstract class SplashPageRepository {
  Future<Either<ErrorState, void>> updateUserRegistrationToken(
      String token, String hushhId);

  Future<Either<ErrorState, List<BrandLocation>>> fetchAllNearbyBrands(
      Placemark place, List<CardModel> installedBrandCards);

  Future<Either<ErrorState, void>> insertUserBrandLocationTrigger(
      UserBrandLocationTriggerModel userBrandLocationTrigger);

  Future<Either<ErrorState, void>> shareUserProfileAndRequirementsWithAgent(
      String agentId, String query, int cardId, String senderHushhId);
}
