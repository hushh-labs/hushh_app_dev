import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/repository_impl/card_wallet_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class CardExistsUseCase {
  final CardWalletPageRepositoryImpl cardWalletPageRepository;

  CardExistsUseCase(this.cardWalletPageRepository);

  Future<Either<ErrorState, CardModel?>> call(
      {required int id}) async {
    return await cardWalletPageRepository.cardExists(id);
  }
}
