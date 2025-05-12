import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/repository_impl/settings_page_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class DeleteAccountUseCase {
  final SettingsPageRepositoryImpl settingsPageRepository;

  DeleteAccountUseCase(this.settingsPageRepository);

  Future<Either<ErrorState, void>> call() async {
    return await settingsPageRepository.deleteAccount();
  }
}
