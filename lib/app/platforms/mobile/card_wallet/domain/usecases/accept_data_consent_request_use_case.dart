import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/repository_impl/card_wallet_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';

class AcceptDataConsentRequestUseCase {
  final CardWalletPageRepositoryImpl cardWalletPageRepository;

  AcceptDataConsentRequestUseCase(this.cardWalletPageRepository);

  Future<Either<ErrorState, void>> call(
      {required String requestId}) async {
    return await cardWalletPageRepository.acceptDataConsentRequest(requestId);
  }
}
