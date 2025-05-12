import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/agent.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/models/card_purchased_by_agent.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/repository_impl/card_market_repository_impl.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_product.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class FetchAgentsWhoPurchasedTheCardUseCase {
  final CardMarketRepositoryImpl cardMarketRepository;

  FetchAgentsWhoPurchasedTheCardUseCase(this.cardMarketRepository);

  Future<Either<ErrorState, List<AgentModel>>> call({required int cardId}) async {
    return await cardMarketRepository.fetchAgentsWhoPurchasedTheCard(cardId);
  }
}
