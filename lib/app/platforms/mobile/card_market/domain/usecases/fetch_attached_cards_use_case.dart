import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/repository_impl/card_market_repository_impl.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class FetchAttachedCardsUseCase {
  final CardMarketRepositoryImpl cardMarketRepository;

  FetchAttachedCardsUseCase(this.cardMarketRepository);

  Future<Either<ErrorState, List<CardModel>>> call({required int cid}) async {
    return await cardMarketRepository.fetchAttachedCards(cid);
  }
}
