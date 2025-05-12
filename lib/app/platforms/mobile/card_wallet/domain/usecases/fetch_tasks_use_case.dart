import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/shared_asset.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/task.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/repository_impl/card_wallet_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class FetchTasksUseCase {
  final CardWalletPageRepositoryImpl cardWalletPageRepository;

  FetchTasksUseCase(this.cardWalletPageRepository);

  Future<Either<ErrorState, List<TaskModel>>> call({required String uid}) async {
    return await cardWalletPageRepository.fetchTasks(uid);
  }
}
