import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/auth/data/models/agent_category.dart';
import 'package:hushh_app/app/platforms/mobile/auth/data/repository_impl/auth_page_repository_impl.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/agent.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/user.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class InsertAgentUseCase {
  final AuthPageRepositoryImpl authPageRepository;

  InsertAgentUseCase(this.authPageRepository);

  Future<Either<ErrorState, void>> call({required AgentModel agent}) async {
    return await authPageRepository.insertAgent(agent);
  }
}
