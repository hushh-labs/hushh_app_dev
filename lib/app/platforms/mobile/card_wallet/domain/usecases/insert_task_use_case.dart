import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_meeting.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/task.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/repository_impl/card_wallet_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class InsertTaskUseCase {
  final CardWalletPageRepositoryImpl cardWalletPageRepository;

  InsertTaskUseCase(this.cardWalletPageRepository);

  Future<Either<ErrorState, void>> call(
      {required TaskModel task}) async {
    return await cardWalletPageRepository.insertTask(task);
  }
}
