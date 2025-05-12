import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/repository_impl/card_market_repository_impl.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_product.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class DeleteUserInstalledCardsUseCase {
  final CardMarketRepositoryImpl cardMarketRepository;

  DeleteUserInstalledCardsUseCase(this.cardMarketRepository);

  Future<Either<ErrorState, void>> call({String? userId, int? cardId}) async {
    return await cardMarketRepository.deleteUserInstalledCards(userId, cardId);
  }
}
