import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/inventory_configuration.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/repository_impl/card_wallet_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class FetchInventoriesUseCase {
  final CardWalletPageRepositoryImpl cardWalletPageRepository;

  FetchInventoriesUseCase(this.cardWalletPageRepository);

  Future<Either<ErrorState, List<InventoryConfiguration>>> call(
      {required int brandId}) async {
    return await cardWalletPageRepository.fetchInventories(brandId);
  }
}
