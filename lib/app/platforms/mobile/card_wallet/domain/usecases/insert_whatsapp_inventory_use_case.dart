import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/repository_impl/card_wallet_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class InsertWhatsappInventoryUseCase {
  final CardWalletPageRepositoryImpl cardWalletPageRepository;

  InsertWhatsappInventoryUseCase(this.cardWalletPageRepository);

  Future<Either<ErrorState, void>> call(
      {required dynamic payload,
      required int configurationId,
      required int brandId}) async {
    return await cardWalletPageRepository.insertWhatsappInventory(
        payload, configurationId, brandId);
  }
}
