import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/auth/data/models/agent_category.dart';
import 'package:hushh_app/app/platforms/mobile/auth/data/repository_impl/auth_page_repository_impl.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/agent.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/location.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/user.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class InsertUserAgentLocationUseCase {
  final AuthPageRepositoryImpl authPageRepository;

  InsertUserAgentLocationUseCase(this.authPageRepository);

  Future<Either<ErrorState, void>> call({required LocationModel location}) async {
    return await authPageRepository.insertLocation(location);
  }
}
