import 'package:hushh_app/app/platforms/mobile/card_market/data/models/card_purchased_by_agent.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/brand_location.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/customer_model.dart';

abstract class CardMarketSupabaseDataSource {
  Future<Map<String, dynamic>> fetchBrandProducts(int brandId);

  Future<List<Map<String, dynamic>>> fetchUserInstalledCards(
      String? userId, int? cardId, int? cardInstalledId);

  Future<void> deleteUserInstalledCards(String? userId, int? cardId);

  Future<int> insertUserInstalledCard(CardModel cardModel);

  Future<void> updateUserInstalledCard(CardModel cardModel);

  Future<List<Map<String, dynamic>>> fetchCardMarket();

  Future<List<Map<String, dynamic>>> fetchCardQuestions(int cardId);

  Future<List<Map<String, dynamic>>> fetchCustomers(String agentId);

  Future<void> insertCardPurchasedByAgent(
      CardPurchasedByAgent cardPurchasedByAgent);

  Future<List<Map<String, dynamic>>> fetchAgentsWhoPurchasedTheCard(int cardId);

  Stream<List<CustomerModel>> fetchCustomersAsStream(String agentId);

  Future<List<Map<String, dynamic>>> fetchAttachedCards(int cid);

  Future<List<Map<String, dynamic>>> fetchBrands();

  Future<void> insertBrandLocations(List<BrandLocation> locations);

  Future<void> insertCard(CardModel card);

  Future<List<Map<String, dynamic>>> fetchInsuranceDetails(CardModel? card);

  Future<Map<String, dynamic>?> fetchTravelDetails(CardModel card);

  Future<List<Map<String, dynamic>>> fetchPurchasedItems(String userId);
}
