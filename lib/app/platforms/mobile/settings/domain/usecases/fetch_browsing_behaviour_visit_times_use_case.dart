import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/repository_impl/settings_page_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class FetchBrowsingBehaviourVisitTimesUseCase {
  final SettingsPageRepositoryImpl settingsPageRepository;

  FetchBrowsingBehaviourVisitTimesUseCase(this.settingsPageRepository);

  Future<Either<ErrorState, List<DateTime>>> call({required String hushhId}) async {
    return await settingsPageRepository.fetchBrowsingBehaviourVisitTimes(hushhId);
  }
}
