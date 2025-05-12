import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/repository_impl/card_wallet_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class UserInstalledCardExistsUseCase {
  final CardWalletPageRepositoryImpl cardWalletPageRepository;

  UserInstalledCardExistsUseCase(this.cardWalletPageRepository);

  Future<Either<ErrorState, bool>> call(
      {required int id, required String hushhId}) async {
    return await cardWalletPageRepository.userInstalledCardExists(id, hushhId);
  }
}
