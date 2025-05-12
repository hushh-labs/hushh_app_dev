import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/repository_impl/card_market_repository_impl.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/brand_location.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class InsertBrandLocationsUseCase {
  final CardMarketRepositoryImpl cardMarketRepository;

    InsertBrandLocationsUseCase(this.cardMarketRepository);

  Future<Either<ErrorState, void>> call(
      {required List<BrandLocation> locations}) async {
    return await cardMarketRepository.insertBrandLocations(locations);
  }
}
