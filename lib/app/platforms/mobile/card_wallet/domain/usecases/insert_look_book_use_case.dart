import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_lookbook.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_meeting.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_product.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/task.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/repository_impl/card_wallet_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class InsertLookBookUseCase {
  final CardWalletPageRepositoryImpl cardWalletPageRepository;

  InsertLookBookUseCase(this.cardWalletPageRepository);

  Future<Either<ErrorState, void>> call(
      {required AgentLookBook lookbook, required List<AgentProductModel> products}) async {
    return await cardWalletPageRepository.insertLookBook(lookbook, products);
  }
}
