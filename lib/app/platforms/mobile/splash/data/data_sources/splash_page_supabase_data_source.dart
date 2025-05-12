import 'package:geocoding/geocoding.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/user_brand_location_trigger_model.dart';

abstract class SplashPageSupabaseDataSource {
  Future<void> updateUserRegistrationToken(String token, String hushhId);

  Future<List<Map<String, dynamic>>> fetchAllNearbyBrands(
      Placemark place, List<CardModel> installedBrandCards);

  Future<void> insertUserBrandLocationTrigger(
      UserBrandLocationTriggerModel userBrandLocationTrigger);

  Future<void> shareUserProfileAndRequirementsWithAgent(
      String agentId, String query, int cardId, String senderHushhId);
}
