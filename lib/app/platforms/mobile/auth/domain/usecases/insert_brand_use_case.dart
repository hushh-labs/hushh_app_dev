import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/auth/data/models/agent_category.dart';
import 'package:hushh_app/app/platforms/mobile/auth/data/repository_impl/auth_page_repository_impl.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/agent.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/user.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/brand.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class InsertBrandUseCase {
  final AuthPageRepositoryImpl authPageRepository;

  InsertBrandUseCase(this.authPageRepository);

  Future<Either<ErrorState, int>> call({required Brand brand}) async {
    return await authPageRepository.insertBrand(brand);
  }
}
