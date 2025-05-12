import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/app_usage_data.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/browsed_collection.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/repository_impl/settings_page_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class AfterUsageInsertedUseCase {
  final SettingsPageRepositoryImpl settingsPageRepository;

  AfterUsageInsertedUseCase(this.settingsPageRepository);

  Future<Either<ErrorState, void>> call(
      {required List<AppUsageData> appUsages}) async {
    return await settingsPageRepository.afterUsageInserted(appUsages);
  }
}
