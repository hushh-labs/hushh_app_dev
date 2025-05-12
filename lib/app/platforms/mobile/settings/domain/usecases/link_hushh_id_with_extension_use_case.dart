import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/repository_impl/settings_page_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class LinkHushhIdWithExtensionUseCase {
  final SettingsPageRepositoryImpl settingsPageRepository;

  LinkHushhIdWithExtensionUseCase(this.settingsPageRepository);

  Future<Either<ErrorState, void>> call(
      {required String hushhId, required String code}) async {
    return await settingsPageRepository.linkHushhIdWithExtension(hushhId, code);
  }
}
