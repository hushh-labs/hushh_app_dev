import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/brand_location.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/user_brand_location_trigger_model.dart';
import 'package:hushh_app/app/platforms/mobile/splash/data/repository_impl/splash_page_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class InsertUserBrandLocationTriggerUseCase {
  final SplashPageRepositoryImpl splashPageRepository;

  InsertUserBrandLocationTriggerUseCase(this.splashPageRepository);

  Future<Either<ErrorState, void>> call(
      {required UserBrandLocationTriggerModel
          userBrandLocationTriggerModel}) async {
    return await splashPageRepository
        .insertUserBrandLocationTrigger(userBrandLocationTriggerModel);
  }
}
