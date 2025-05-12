import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/splash/data/repository_impl/splash_page_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class UpdateUserRegistrationTokenUseCase {
  final SplashPageRepositoryImpl splashPageRepository;

  UpdateUserRegistrationTokenUseCase(this.splashPageRepository);

  Future<Either<ErrorState, void>> call({required String token, required String hushhId}) async {
    return await splashPageRepository.updateUserRegistrationToken(token, hushhId);
  }
}
