import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/data/repository_impl/card_share_ecosystem_repository_impl.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/task.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class CreateNewTaskAsUserForAgentUseCase {
  final CardShareEcoSystemRepositoryImpl cardShareEcoSystemRepository;

  CreateNewTaskAsUserForAgentUseCase(this.cardShareEcoSystemRepository);

  Future<Either<ErrorState, void>> call({required TaskModel task}) async {
    return await cardShareEcoSystemRepository.createNewTaskAsUserForAgent(task);
  }
}
