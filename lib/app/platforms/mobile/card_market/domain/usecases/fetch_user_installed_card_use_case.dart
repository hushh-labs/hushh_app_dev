import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/repository_impl/card_market_repository_impl.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_product.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class FetchUserInstalledCardsUseCase {
  final CardMarketRepositoryImpl cardMarketRepository;

  FetchUserInstalledCardsUseCase(this.cardMarketRepository);

  Future<Either<ErrorState, List<CardModel>>> call({String? userId, int? cardId, int? cardInstalledId}) async {
    return await cardMarketRepository.fetchUserInstalledCards(userId, cardId, cardInstalledId);
  }
}
