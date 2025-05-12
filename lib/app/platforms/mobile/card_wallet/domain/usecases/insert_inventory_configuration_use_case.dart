import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/inventory_schema_response.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/repository_impl/card_wallet_repository_impl.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class InsertInventoryConfigurationUseCase {
  final CardWalletPageRepositoryImpl cardWalletPageRepository;

  InsertInventoryConfigurationUseCase(this.cardWalletPageRepository);

  Future<Either<ErrorState, int>> call(
      {required int brandId,
      required Map<String, InventoryColumn> mappedColumns,
      required InventoryServer inventoryServer}) async {
    return await cardWalletPageRepository.insertInventoryConfiguration(
        brandId, inventoryServer, mappedColumns);
  }
}
