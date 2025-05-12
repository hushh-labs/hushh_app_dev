import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/data/models/nearby_found_brand.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/data/repository_impl/card_share_ecosystem_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class FetchBrandIdsFromGroupIdUseCase {
  final CardShareEcoSystemRepositoryImpl cardShareEcoSystemRepository;

  FetchBrandIdsFromGroupIdUseCase(this.cardShareEcoSystemRepository);

  Future<Either<ErrorState, List<int>>> call(
      {required int gId}) async {
    return await cardShareEcoSystemRepository.fetchBrandIdsFromGroupId(gId);
  }
}
