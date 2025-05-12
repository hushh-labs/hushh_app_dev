import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/auth/data/models/agent_category.dart';
import 'package:hushh_app/app/platforms/mobile/auth/data/repository_impl/auth_page_repository_impl.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/user.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class FetchUsersUseCase {
  final AuthPageRepositoryImpl authPageRepository;

  FetchUsersUseCase(this.authPageRepository);

  Future<Either<ErrorState, List<UserModel>>> call({String? uid, String? email, String? phoneNumber}) async {
    return await authPageRepository.fetchUsers(uid, email, phoneNumber);
  }
}
