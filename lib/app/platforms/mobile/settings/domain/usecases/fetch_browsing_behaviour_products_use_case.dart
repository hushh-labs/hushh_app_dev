import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/browsed_product_model.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/repository_impl/settings_page_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class FetchBrowsingBehaviourProductsUseCase {
  final SettingsPageRepositoryImpl settingsPageRepository;

  FetchBrowsingBehaviourProductsUseCase(this.settingsPageRepository);

  Future<Either<ErrorState, List<BrowsedProduct>>> call({required String hushhId}) async {
    return await settingsPageRepository.fetchBrowsingBehaviourProducts(hushhId);
  }
}
