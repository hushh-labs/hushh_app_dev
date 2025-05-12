import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/data/models/nearby_found_brand.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/task.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

abstract class CardShareEcoSystemRepository {
  Future<Either<ErrorState, List<NearbyFoundBrandOffers>>> fetchBrandOffers(
      List<int> brandIds);

  Future<Either<ErrorState, List<int>>> fetchBrandIdsFromGroupId(int gId);

  Future<Either<ErrorState, void>> createNewTaskAsUserForAgent(TaskModel task);
}
