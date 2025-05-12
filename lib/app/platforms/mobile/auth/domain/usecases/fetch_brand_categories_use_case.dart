import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/auth/data/models/agent_category.dart';
import 'package:hushh_app/app/platforms/mobile/auth/data/models/brand_category.dart';
import 'package:hushh_app/app/platforms/mobile/auth/data/repository_impl/auth_page_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class FetchBrandCategoriesUseCase {
  final AuthPageRepositoryImpl authPageRepository;

  FetchBrandCategoriesUseCase(this.authPageRepository);

  Future<Either<ErrorState, List<BrandCategory>>> call() async {
    return await authPageRepository.fetchBrandCategories();
  }
}
