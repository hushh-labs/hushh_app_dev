import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/cached_inventory_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/repository_impl/card_wallet_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class FetchProductsResultFromInventoryUseCase {
  final CardWalletPageRepositoryImpl cardWalletPageRepository;

  FetchProductsResultFromInventoryUseCase(this.cardWalletPageRepository);

  Future<Either<ErrorState, CachedInventoryModel?>> call(
      {required int brandId, required int configurationId}) async {
    return await cardWalletPageRepository.fetchProductsResultFromInventory(
        brandId, configurationId);
  }
}
