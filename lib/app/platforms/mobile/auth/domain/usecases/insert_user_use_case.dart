import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/auth/data/models/agent_category.dart';
import 'package:hushh_app/app/platforms/mobile/auth/data/repository_impl/auth_page_repository_impl.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/user.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class InsertUserUseCase {
  final AuthPageRepositoryImpl authPageRepository;

  InsertUserUseCase(this.authPageRepository);

  Future<Either<ErrorState, void>> call({required UserModel user}) async {
    return await authPageRepository.insertUser(user);
  }
}
