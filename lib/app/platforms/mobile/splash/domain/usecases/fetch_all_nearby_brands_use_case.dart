import 'package:dartz/dartz.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/brand_location.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/splash/data/repository_impl/splash_page_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class FetchAllNearbyBrandsUseCase {
  final SplashPageRepositoryImpl splashPageRepository;

  FetchAllNearbyBrandsUseCase(this.splashPageRepository);

  Future<Either<ErrorState, List<BrandLocation>>> call({required Placemark place, required List<CardModel> installedBrandCards}) async {
    return await splashPageRepository.fetchAllNearbyBrands(place, installedBrandCards);
  }
}
