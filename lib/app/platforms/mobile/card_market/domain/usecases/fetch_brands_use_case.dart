import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/repository_impl/card_market_repository_impl.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_product.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/brand.dart';

class FetchBrandsUseCase {
  final CardMarketRepositoryImpl cardMarketRepository;

  FetchBrandsUseCase(this.cardMarketRepository);

  Future<Either<ErrorState, List<Brand>>> call() async {
    return await cardMarketRepository.fetchBrands();
  }
}
