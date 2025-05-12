import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/auth/data/models/agent_category.dart';
import 'package:hushh_app/app/platforms/mobile/auth/data/repository_impl/auth_page_repository_impl.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/user.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class UpdateUserUseCase {
  final AuthPageRepositoryImpl authPageRepository;

  UpdateUserUseCase(this.authPageRepository);

  Future<Either<ErrorState, void>> call({required UserModel user, required String uid}) async {
    return await authPageRepository.updateUser(user, uid);
  }
}
