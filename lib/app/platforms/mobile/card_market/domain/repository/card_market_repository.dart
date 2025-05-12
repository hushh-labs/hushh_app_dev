import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/agent.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/models/card_purchased_by_agent.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/models/purchased_item.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/data/models/nearby_found_brand.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_question.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_product.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/brand.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/brand_location.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/cached_inventory_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/customer_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/insurance_receipt.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/travel_card_insights.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

abstract class CardMarketRepository {
  Future<Either<ErrorState, String>> generatePlaidToken(String token);

  Future<Either<ErrorState, CachedInventoryModel>> fetchBrandProducts(
      int brandId);

  Future<Either<ErrorState, List<CardModel>>> fetchUserInstalledCards(
    String? userId,
    int? cardId,
    int? cardInstalledId
  );

  Future<Either<ErrorState, List<CustomerModel>>> fetchCustomers(
      String agentId);

  Stream<List<CustomerModel>> fetchCustomersAsStream(String agentId);

  Future<Either<ErrorState, void>> deleteUserInstalledCards(
    String? userId,
    int? cardId,
  );

  Future<Either<ErrorState, int>> insertUserInstalledCard(CardModel card);

  Future<Either<ErrorState, void>> updateUserInstalledCard(CardModel card);

  Future<Either<ErrorState, List<CardModel>>> fetchCardMarket();

  Future<Either<ErrorState, List<CardQuestion>>> fetchCardQuestions(int cardId);

  Future<Either<ErrorState, void>> insertCardPurchasedByAgent(
      CardPurchasedByAgent cardPurchasedByAgent);

  Future<Either<ErrorState, List<AgentModel>>> fetchAgentsWhoPurchasedTheCard(
      int cardId);

  Future<Either<ErrorState, List<CardModel>>> fetchAttachedCards(int cid);

  Future<Either<ErrorState, List<Brand>>> fetchBrands();

  Future<Either<ErrorState, void>> insertBrandLocations(List<BrandLocation> locations);

  Future<Either<ErrorState, void>> insertCard(CardModel card);

  Future<Either<ErrorState, List<InsuranceReceipt>>> fetchInsuranceDetails(CardModel? card);

  Future<Either<ErrorState, TravelCardInsights?>> fetchTravelDetails(CardModel card);

  Future<Either<ErrorState, List<PurchasedItem>>> fetchPurchasedItems(String userId);
}
