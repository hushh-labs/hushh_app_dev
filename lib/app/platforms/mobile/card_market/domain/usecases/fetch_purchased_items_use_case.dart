import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/models/purchased_item.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/repository_impl/card_market_repository_impl.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_product.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class FetchPurchaseItemsUseCase {
  final CardMarketRepositoryImpl cardMarketRepository;

  FetchPurchaseItemsUseCase(this.cardMarketRepository);

  Future<Either<ErrorState, List<PurchasedItem>>> call({required String userId}) async {
    return await cardMarketRepository.fetchPurchasedItems(userId);
  }
}
