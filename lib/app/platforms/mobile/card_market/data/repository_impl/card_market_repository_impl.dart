import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/agent.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/user.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/data_sources/card_market_api_data_source.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/data_sources/card_market_supabase_data_source_impl.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/models/card_purchased_by_agent.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/models/purchased_item.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/repository/card_market_repository.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/brand.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/brand_location.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/cached_inventory_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_question.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/customer_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/insurance_receipt.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/travel_card_insights.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_handler.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class CardMarketRepositoryImpl extends CardMarketRepository {
  final CardMarketApiDataSource cardMarketApiDataSource;
  final CardMarketSupabaseDataSourceImpl cardMarketSupabaseDataSource;

  CardMarketRepositoryImpl(
      this.cardMarketApiDataSource, this.cardMarketSupabaseDataSource);

  @override
  Future<Either<ErrorState, String>> generatePlaidToken(String token) async {
    return await ErrorHandler.callApi(
        () => cardMarketApiDataSource.generatePlaidToken(
              "63f87207e9b49300135afac8",
              "606fc93026114c32eb5dfc2d6725b6",
              token,
            ), (result) {
      return result['access_token'];
    });
  }

  @override
  Future<Either<ErrorState, CachedInventoryModel>> fetchBrandProducts(
      int brandId) async {
    return await ErrorHandler.callSupabase(
        () => cardMarketSupabaseDataSource.fetchBrandProducts(brandId),
        (value) {
      final result = value as Map<String, dynamic>;
      return CachedInventoryModel.fromJson(result);
    });
  }

  @override
  Future<Either<ErrorState, List<CardModel>>> fetchUserInstalledCards(
      String? userId, int? cardId, int? cardInstalledId) async {
    return await ErrorHandler.callSupabase(
        () => cardMarketSupabaseDataSource.fetchUserInstalledCards(
            userId, cardId, cardInstalledId), (value) {
      final result = value as List<Map<String, dynamic>>;
      return result.map((e) => CardModel.fromJson(e)).toList();
    });
  }

  @override
  Future<Either<ErrorState, void>> deleteUserInstalledCards(
      String? userId, int? cardId) async {
    return await ErrorHandler.callSupabase(
        () => cardMarketSupabaseDataSource.deleteUserInstalledCards(
            userId, cardId),
        (value) {});
  }

  @override
  Future<Either<ErrorState, int>> insertUserInstalledCard(
      CardModel card) async {
    return await ErrorHandler.callSupabase(
        () => cardMarketSupabaseDataSource.insertUserInstalledCard(card),
        (value) => value);
  }

  @override
  Future<Either<ErrorState, void>> updateUserInstalledCard(
      CardModel card) async {
    return await ErrorHandler.callSupabase(
        () => cardMarketSupabaseDataSource.updateUserInstalledCard(card),
        (value) {});
  }

  @override
  Future<Either<ErrorState, List<CardModel>>> fetchCardMarket() async {
    return await ErrorHandler.callSupabase(
        () => cardMarketSupabaseDataSource.fetchCardMarket(), (value) {
      final result = value as List<Map<String, dynamic>>;
      return result.map((e) => CardModel.fromJson(e)).toList();
    });
  }

  @override
  Future<Either<ErrorState, List<CardQuestion>>> fetchCardQuestions(
      int cardId) async {
    return await ErrorHandler.callSupabase(
        () => cardMarketSupabaseDataSource.fetchCardQuestions(cardId), (value) {
      final result = value as List<Map<String, dynamic>>;
      return result.map((e) => CardQuestion.fromJson(e)).toList();
    });
  }

  @override
  Future<Either<ErrorState, List<CustomerModel>>> fetchCustomers(
    String agentId,
  ) async {
    return await ErrorHandler.callSupabase(
        () => cardMarketSupabaseDataSource.fetchCustomers(agentId), (value) {
      final result = value as List<Map<String, dynamic>>;
      return result.map((e) {
        return CustomerModel(
            brand: CardModel.fromJson(e), user: UserModel.fromJson(e['user']));
      }).toList();
    });
  }

  @override
  Future<Either<ErrorState, void>> insertCardPurchasedByAgent(
      CardPurchasedByAgent cardPurchasedByAgent) async {
    return await ErrorHandler.callSupabase(
        () => cardMarketSupabaseDataSource
            .insertCardPurchasedByAgent(cardPurchasedByAgent),
        (value) {});
  }

  @override
  Future<Either<ErrorState, List<AgentModel>>> fetchAgentsWhoPurchasedTheCard(
      int cardId) async {
    return await ErrorHandler.callSupabase(
        () =>
            cardMarketSupabaseDataSource.fetchAgentsWhoPurchasedTheCard(cardId),
        (value) {
      final result = value as List<Map<String, dynamic>>;
      return result.map((e) => AgentModel.fromJson(e['agent'])).toList();
    });
  }

  @override
  Future<Either<ErrorState, List<CardModel>>> fetchAttachedCards(
      int cid) async {
    return await ErrorHandler.callSupabase(
        () => cardMarketSupabaseDataSource.fetchAttachedCards(cid), (value) {
      final result = value as List<Map<String, dynamic>>;
      return result.map((e) => CardModel.fromJson(e)).toList();
    });
  }

  @override
  Future<Either<ErrorState, List<Brand>>> fetchBrands() async {
    return await ErrorHandler.callSupabase(
        () => cardMarketSupabaseDataSource.fetchBrands(), (value) {
      final result = value as List<Map<String, dynamic>>;
      return result.map((e) => Brand.fromJson(e)).toList();
    });
  }

  @override
  Stream<List<CustomerModel>> fetchCustomersAsStream(String agentId) {
    return cardMarketSupabaseDataSource.fetchCustomersAsStream(agentId);
  }

  @override
  Future<Either<ErrorState, void>> insertBrandLocations(
      List<BrandLocation> locations) async {
    return await ErrorHandler.callSupabase(
        () => cardMarketSupabaseDataSource.insertBrandLocations(locations),
        (value) {});
  }

  @override
  Future<Either<ErrorState, void>> insertCard(CardModel card) async {
    return await ErrorHandler.callSupabase(
        () => cardMarketSupabaseDataSource.insertCard(card), (value) {});
  }

  @override
  Future<Either<ErrorState, List<InsuranceReceipt>>> fetchInsuranceDetails(
      CardModel? card) async {
    return await ErrorHandler.callSupabase(
        () => cardMarketSupabaseDataSource.fetchInsuranceDetails(card),
        (value) {
      final result = value as List<Map<String, dynamic>>;
      return result.map((e) => InsuranceReceipt.fromJson(e)).toList();
    });
  }

  @override
  Future<Either<ErrorState, TravelCardInsights?>> fetchTravelDetails(
      CardModel card) async {
    return await ErrorHandler.callSupabase(
        () => cardMarketSupabaseDataSource.fetchTravelDetails(card), (value) {
      final result = value as Map<String, dynamic>?;
      return result != null ? TravelCardInsights.fromJson(result) : null;
    });
  }

  @override
  Future<Either<ErrorState, List<PurchasedItem>>> fetchPurchasedItems(
      String userId) async {
    return await ErrorHandler.callSupabase(
        () => cardMarketSupabaseDataSource.fetchPurchasedItems(userId),
        (value) {
      final result = value as List<Map<String, dynamic>>;
      return result.map((e) => PurchasedItem.fromJson(e)).toList();
    });
  }
}
