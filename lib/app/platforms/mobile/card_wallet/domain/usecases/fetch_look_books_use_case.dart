import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_lookbook.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/meeting_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/repository_impl/card_wallet_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';

class FetchLookBooksUseCase {
  final CardWalletPageRepositoryImpl cardWalletPageRepository;

  FetchLookBooksUseCase(this.cardWalletPageRepository);

  Future<Either<ErrorState, List<AgentLookBook>>> call(
      {required String uid}) async {
    return await cardWalletPageRepository.fetchLookBooks(uid);
  }
}
