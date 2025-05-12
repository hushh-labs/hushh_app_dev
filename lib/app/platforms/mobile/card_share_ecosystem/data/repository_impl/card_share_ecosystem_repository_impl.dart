import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/data/data_sources/card_share_ecosystem_data_source_impl.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/data/models/nearby_found_brand.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/domain/repository/card_share_ecosytem_repository_impl.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/task.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_handler.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class CardShareEcoSystemRepositoryImpl extends CardShareEcoSystemRepository {
  final CardShareEcoSystemDataSourceImpl cardShareEcoSystemDataSource;

  CardShareEcoSystemRepositoryImpl(this.cardShareEcoSystemDataSource);

  @override
  Future<Either<ErrorState, List<NearbyFoundBrandOffers>>> fetchBrandOffers(
      List<int> brandIds) async {
    return await ErrorHandler.callSupabase(
        () => cardShareEcoSystemDataSource.fetchBrandOffers(brandIds), (value) {
      final result = value as List<Map<String, dynamic>>;
      return result.map((e) => NearbyFoundBrandOffers.fromJson(e)).toList();
    });
  }

  @override
  Future<Either<ErrorState, List<int>>> fetchBrandIdsFromGroupId(
      int gId) async {
    return await ErrorHandler.callSupabase(
        () => cardShareEcoSystemDataSource.fetchBrandIdsFromGroupId(gId),
        (value) {
      final result = value as Map<String, dynamic>;
      return List<int>.from(result['location_ids']);
    });
  }

  @override
  Future<Either<ErrorState, void>> createNewTaskAsUserForAgent(TaskModel task) async {
    return await ErrorHandler.callSupabase(
        () => cardShareEcoSystemDataSource.createNewTaskAsUserForAgent(task),
        (value) {});
  }
}
