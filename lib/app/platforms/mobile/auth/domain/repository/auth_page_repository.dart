import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/auth/data/models/agent_category.dart';
import 'package:hushh_app/app/platforms/mobile/auth/data/models/brand_category.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/agent.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/location.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/user.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/brand.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

abstract class AuthPageRepository {
  Future<Either<ErrorState, List<AgentCategory>>> fetchCategories();

  Future<Either<ErrorState, List<BrandCategory>>> fetchBrandCategories();

  Future<Either<ErrorState, UserModel?>> fetchUser(
    String? uid,
    String? email,
    String? phoneNumber,
    AgentApprovalStatus? approvalStatus,
  );

  Future<Either<ErrorState, List<UserModel>>> fetchUsers(
    String? uid,
    String? email,
    String? phoneNumber,
  );

  Future<Either<ErrorState, void>> insertUser(UserModel user);

  Future<Either<ErrorState, void>> insertAgent(AgentModel agent);

  Future<Either<ErrorState, int>> insertBrand(Brand brand);

  Future<Either<ErrorState, void>> updateUser(UserModel user, String uid);

  Future<Either<ErrorState, void>> updateAgent(AgentModel agent);

  Future<Either<ErrorState, List<AgentModel>>> fetchAgents(String? uid,
      String? email, AgentApprovalStatus? approvalStatus, int? brandId);

  Future<Either<ErrorState, void>> insertLocation(LocationModel location);

  Future<Either<ErrorState, void>> insertAgentRole(int brandId, String hushhId,
      AgentRole agentRole, AgentApprovalStatus status);
}
