import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_lookbook.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_product.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/repository_impl/card_wallet_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class DeleteLookBookUseCase {
  final CardWalletPageRepositoryImpl cardWalletPageRepository;

  DeleteLookBookUseCase(this.cardWalletPageRepository);

  Future<Either<ErrorState, void>> call(
      {required AgentLookBook lookBook}) async {
    return await cardWalletPageRepository.deleteLookBook(lookBook);
  }
}
