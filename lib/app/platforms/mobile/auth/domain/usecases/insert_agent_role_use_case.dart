import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/auth/data/repository_impl/auth_page_repository_impl.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class InsertAgentRoleUseCase {
  final AuthPageRepositoryImpl authPageRepository;

  InsertAgentRoleUseCase(this.authPageRepository);

  Future<Either<ErrorState, void>> call(
      {required int brandId,
      required String hushhId,
      required AgentRole agentRole,
      required AgentApprovalStatus status}) async {
    return await authPageRepository.insertAgentRole(
        brandId, hushhId, agentRole, status);
  }
}
