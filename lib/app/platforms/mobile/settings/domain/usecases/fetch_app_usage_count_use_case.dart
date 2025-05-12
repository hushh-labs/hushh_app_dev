import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/browsed_collection.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/repository_impl/settings_page_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class FetchAppUsageCountUseCase {
  final SettingsPageRepositoryImpl settingsPageRepository;

  FetchAppUsageCountUseCase(this.settingsPageRepository);

  Future<Either<ErrorState, int?>> call(
      {required String hushhId}) async {
    return await settingsPageRepository.fetchAppUsageCount(hushhId);
  }
}
