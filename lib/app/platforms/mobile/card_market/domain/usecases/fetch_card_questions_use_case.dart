import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/repository_impl/card_market_repository_impl.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_question.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_product.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class FetchCardQuestionsUseCase {
  final CardMarketRepositoryImpl cardMarketRepository;

  FetchCardQuestionsUseCase(this.cardMarketRepository);

  Future<Either<ErrorState, List<CardQuestion>>> call({required int cardId}) async {
    return await cardMarketRepository.fetchCardQuestions(cardId);
  }
}
