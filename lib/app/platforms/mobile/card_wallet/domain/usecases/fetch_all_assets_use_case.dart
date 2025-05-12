import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/shared_asset.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/repository_impl/card_wallet_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class FetchAllAssetsUseCase {
  final CardWalletPageRepositoryImpl cardWalletPageRepository;

  FetchAllAssetsUseCase(this.cardWalletPageRepository);

  Future<Either<ErrorState, List<SharedAsset>>> call({required String uid, required int cardId}) async {
    return await cardWalletPageRepository.fetchAllAssets(uid, cardId);
  }
}
