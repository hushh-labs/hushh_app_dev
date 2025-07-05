import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/repository_impl/card_wallet_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class UpdateProductStockQuantityUseCase {
  final CardWalletPageRepositoryImpl repository;
  UpdateProductStockQuantityUseCase(this.repository);

  Future<Either<ErrorState, void>> call({
    required String productSkuUniqueId,
    required int newStockQuantity,
    required String hushhId,
  }) async {
    return await repository.updateProductStockQuantity(
        productSkuUniqueId, newStockQuantity, hushhId);
  }
}
