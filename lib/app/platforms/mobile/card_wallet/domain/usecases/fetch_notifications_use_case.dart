import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/repository_impl/card_wallet_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';

class FetchNotificationsUseCase {
  final CardWalletPageRepositoryImpl cardWalletPageRepository;

  FetchNotificationsUseCase(this.cardWalletPageRepository);

  Future<Either<ErrorState, List<CustomNotification>>> call(
      {required String uid}) async {
    return await cardWalletPageRepository.fetchNotifications(uid);
  }
}
