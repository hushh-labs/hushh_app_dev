import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/repository_impl/card_wallet_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class FetchBrandInfoFromDomainUseCase {
  final CardWalletPageRepositoryImpl cardWalletPageRepository;

  FetchBrandInfoFromDomainUseCase(this.cardWalletPageRepository);

  Future<Either<ErrorState, CardModel?>> call(
      {required String domain}) async {
    return await cardWalletPageRepository.fetchBrandInfoFromDomain(domain);
  }
}
