import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_lookbook.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_meeting.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/task.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/repository_impl/card_wallet_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class UpdateLookBookFieldUseCase {
  final CardWalletPageRepositoryImpl cardWalletPageRepository;

  UpdateLookBookFieldUseCase(this.cardWalletPageRepository);

  Future<Either<ErrorState, void>> call(
      {required String lookbookId, required Map<String, dynamic> field}) async {
    return await cardWalletPageRepository.updateLookBookField(lookbookId, field);
  }
}
