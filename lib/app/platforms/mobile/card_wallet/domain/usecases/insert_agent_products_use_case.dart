import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_lookbook.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_meeting.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_product.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/task.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/repository_impl/card_wallet_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class InsertAgentProductsUseCase {
  final CardWalletPageRepositoryImpl cardWalletPageRepository;

  InsertAgentProductsUseCase(this.cardWalletPageRepository);

  Future<Either<ErrorState, void>> call(
      {required List<AgentProductModel> products}) async {
    return await cardWalletPageRepository.insertAgentProducts(products);
  }
}
