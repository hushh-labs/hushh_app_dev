part of 'auth_page_supabase_data_source_impl.dart';

abstract class AuthPageSupabaseDataSource {
  Future<List<Map<String, dynamic>>> fetchCategories();

  Future<List<Map<String, dynamic>>> fetchBrandCategories();

  Future<Map<String, dynamic>?> fetchUser(
    String? uid,
    String? email,
    String? phoneNumber,
    AgentApprovalStatus? approvalStatus,
  );

  Future<List<Map<String, dynamic>>> fetchUsers(
    String? uid,
    String? email,
    String? phoneNumber,
  );

  Future<void> insertUser(UserModel userModel);

  Future<void> updateUser(UserModel userModel, String uid);

  Future<void> updateAgent(AgentModel agent);

  Future<void> insertAgent(AgentModel agent);

  Future<void> insertLocation(LocationModel location);

  Future<void> insertBrand(Brand brand);

  Future<List<Map<String, dynamic>>> fetchAgents(String? uid, String? email,
      AgentApprovalStatus? approvalStatus, int? brandId);

  Future<void> insertAgentRole(int brandId, String hushhId, AgentRole agentRole,
      AgentApprovalStatus status);
}
