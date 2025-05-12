import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/user_preference.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/repository_impl/card_wallet_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class FetchSharedPreferencesUseCase {
  final CardWalletPageRepositoryImpl cardWalletPageRepository;

  FetchSharedPreferencesUseCase(this.cardWalletPageRepository);

  Future<Either<ErrorState, List<UserPreference>>> call(
      {required String hushhId, required int cardId}) async {
    return await cardWalletPageRepository.fetchSharedPreferences(hushhId, cardId);
  }
}
