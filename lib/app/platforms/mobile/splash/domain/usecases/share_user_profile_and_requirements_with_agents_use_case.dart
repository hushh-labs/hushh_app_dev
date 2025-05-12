import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/splash/data/repository_impl/splash_page_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class ShareUserProfileAndRequirementsWithAgentsUseCase {
  final SplashPageRepositoryImpl splashPageRepository;

  ShareUserProfileAndRequirementsWithAgentsUseCase(this.splashPageRepository);

  Future<Either<ErrorState, void>> call(
      {required String agentId,
      required String query,
      required int cardId,
      required String senderHushhId}) async {
    return await splashPageRepository.shareUserProfileAndRequirementsWithAgent(
        agentId, query, cardId, senderHushhId);
  }
}
