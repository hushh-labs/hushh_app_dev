import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/auth/data/repository_impl/auth_page_repository_impl.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/agent.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class FetchAgentsUseCase {
  final AuthPageRepositoryImpl authPageRepository;

  FetchAgentsUseCase(this.authPageRepository);

  Future<Either<ErrorState, List<AgentModel>>> call(
      {String? uid,
      String? email,
      AgentApprovalStatus? approvalStatus,
      int? brandId}) async {
    return await authPageRepository.fetchAgents(
        uid, email, approvalStatus, brandId);
  }
}
