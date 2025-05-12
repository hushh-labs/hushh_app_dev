import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/inventory_schema_response.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/repository_impl/card_wallet_repository_impl.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class InsertInventoryUseCase {
  final CardWalletPageRepositoryImpl cardWalletPageRepository;

  InsertInventoryUseCase(this.cardWalletPageRepository);

  Future<Either<ErrorState, void>> call(
      {required dynamic payload,
      required int configurationId,
      required int brandId,
      required Map<String, InventoryColumn> mappedColumns,
      required InventoryServer inventoryServer}) async {
    return await cardWalletPageRepository.insertInventory(
        payload, configurationId, brandId, inventoryServer, mappedColumns);
  }
}
