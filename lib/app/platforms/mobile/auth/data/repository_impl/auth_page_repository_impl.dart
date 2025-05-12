import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/auth/data/data_sources/auth_page_supabase_data_source_impl.dart';
import 'package:hushh_app/app/platforms/mobile/auth/data/models/agent_category.dart';
import 'package:hushh_app/app/platforms/mobile/auth/data/models/brand_category.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/agent.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/location.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/user.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/repository/auth_page_repository.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/brand.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_handler.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class AuthPageRepositoryImpl extends AuthPageRepository {
  final AuthPageSupabaseDataSourceImpl authPageSupabaseDataSource;

  AuthPageRepositoryImpl(this.authPageSupabaseDataSource);

  @override
  Future<Either<ErrorState, List<AgentCategory>>> fetchCategories() async {
    return await ErrorHandler.callSupabase(
        () => authPageSupabaseDataSource.fetchCategories(), (value) {
      final result = value as List<Map<String, dynamic>>;
      return result.map((e) => AgentCategory.fromJson(e)).toList();
    });
  }

  @override
  Future<Either<ErrorState, List<BrandCategory>>> fetchBrandCategories() async {
    return await ErrorHandler.callSupabase(
        () => authPageSupabaseDataSource.fetchBrandCategories(), (value) {
      final result = value as List<Map<String, dynamic>>;
      return result.map((e) => BrandCategory.fromJson(e)).toList();
    });
  }

  @override
  Future<Either<ErrorState, UserModel?>> fetchUser(String? uid, String? email,
      String? phoneNumber, AgentApprovalStatus? approvalStatus) async {
    return await ErrorHandler.callSupabase(
        () => authPageSupabaseDataSource.fetchUser(
            uid, email, phoneNumber, approvalStatus), (value) {
      final result = value as Map<String, dynamic>?;
      return result != null ? UserModel.fromJson(result) : null;
    });
  }

  @override
  Future<Either<ErrorState, void>> insertUser(UserModel user) async {
    return await ErrorHandler.callSupabase(
        () => authPageSupabaseDataSource.insertUser(user), (value) {});
  }

  @override
  Future<Either<ErrorState, void>> updateUser(
      UserModel user, String uid) async {
    return await ErrorHandler.callSupabase(
        () => authPageSupabaseDataSource.updateUser(user, uid), (value) {});
  }

  @override
  Future<Either<ErrorState, void>> updateAgent(AgentModel agent) async {
    return await ErrorHandler.callSupabase(
        () => authPageSupabaseDataSource.updateAgent(agent), (value) {});
  }

  @override
  Future<Either<ErrorState, List<UserModel>>> fetchUsers(
      String? uid, String? email, String? phoneNumber) async {
    return await ErrorHandler.callSupabase(
        () => authPageSupabaseDataSource.fetchUsers(uid, email, phoneNumber),
        (value) {
      final result = value as List<Map<String, dynamic>>;
      return result.map((e) => UserModel.fromJson(e)).toList();
    });
  }

  @override
  Future<Either<ErrorState, void>> insertAgent(AgentModel agent) async {
    return await ErrorHandler.callSupabase(
        () => authPageSupabaseDataSource.insertAgent(agent), (value) {});
  }

  @override
  Future<Either<ErrorState, int>> insertBrand(Brand brand) async {
    return await ErrorHandler.callSupabase(
        () => authPageSupabaseDataSource.insertBrand(brand), (value) {
      final result = value as int;
      return result;
    });
  }

  @override
  Future<Either<ErrorState, List<AgentModel>>> fetchAgents(String? uid,
      String? email, AgentApprovalStatus? approvalStatus, int? brandId) async {
    return await ErrorHandler.callSupabase(
        () =>
            authPageSupabaseDataSource.fetchAgents(uid, email, approvalStatus, brandId),
        (value) {
      final result = value as List<Map<String, dynamic>>;
      return result.map((e) => AgentModel.fromJson(e)).toList();
    });
  }

  @override
  Future<Either<ErrorState, void>> insertLocation(
      LocationModel location) async {
    return await ErrorHandler.callSupabase(
        () => authPageSupabaseDataSource.insertLocation(location), (value) {});
  }

  @override
  Future<Either<ErrorState, void>> insertAgentRole(int brandId, String hushhId,
      AgentRole agentRole, AgentApprovalStatus status) async {
    return await ErrorHandler.callSupabase(
        () => authPageSupabaseDataSource.insertAgentRole(
            brandId, hushhId, agentRole, status),
        (value) {});
  }
}
