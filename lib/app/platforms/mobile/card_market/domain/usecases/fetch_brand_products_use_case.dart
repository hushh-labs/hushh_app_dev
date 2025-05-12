import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/repository_impl/card_market_repository_impl.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_product.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/cached_inventory_model.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class FetchBrandProductsUseCase {
  final CardMarketRepositoryImpl cardMarketRepository;

  FetchBrandProductsUseCase(this.cardMarketRepository);

  Future<Either<ErrorState, CachedInventoryModel>> call({required int brandId}) async {
    return await cardMarketRepository.fetchBrandProducts(brandId);
  }
}
