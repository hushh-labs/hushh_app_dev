import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/repository_impl/settings_page_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class InitiateLoginInExtensionWithHushhQrUseCase {
  final SettingsPageRepositoryImpl settingsPageRepository;

  InitiateLoginInExtensionWithHushhQrUseCase(this.settingsPageRepository);

  Future<Either<ErrorState, bool>> call({required String code}) async {
    return await settingsPageRepository
        .initiateLoginInExtensionWithHushhQr(code);
  }
}
