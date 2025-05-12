import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_lookbook.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_meeting.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/shared_asset.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/task.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/repository_impl/card_wallet_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class InsertSharedAssetUseCase {
  final CardWalletPageRepositoryImpl cardWalletPageRepository;

  InsertSharedAssetUseCase(this.cardWalletPageRepository);

  Future<Either<ErrorState, SharedAsset>> call(
      {required SharedAsset asset}) async {
    return await cardWalletPageRepository.insertSharedAsset(asset);
  }
}
