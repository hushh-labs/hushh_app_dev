import 'dart:developer';

import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/agent.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/location.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/user.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/brand.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/backend_controller/db_controller/db_tables.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_page_supabase_data_source.dart';

class AuthPageSupabaseDataSourceImpl extends AuthPageSupabaseDataSource {
  final supabase = Supabase.instance.client;

  @override
  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final data = await supabase.from(DbTables.agentCategoriesTable).select();
    return data;
  }

  @override
  Future<List<Map<String, dynamic>>> fetchBrandCategories() async {
    final data = await supabase.from(DbTables.brandCategoriesTable).select();
    return data;
  }

  @override
  Future<Map<String, dynamic>?> fetchUser(String? uid, String? email,
      String? phoneNumber, AgentApprovalStatus? approvalStatus) async {
    const agentApprovalStatusEnumMap = {
      AgentApprovalStatus.approved: 'approved',
      AgentApprovalStatus.pending: 'pending',
      AgentApprovalStatus.denied: 'denied',
    };

    final field = uid != null
        ? 'hushh_id'
        : email != null
            ? 'email'
            : phoneNumber != null
                ? 'phone_number'
                : 'agent_approval_status';

    final value = uid ??
        email ??
        phoneNumber ??
        agentApprovalStatusEnumMap[approvalStatus];
    final data = await supabase
        .from(DbTables.usersTable)
        .select()
        .eq(field, value!)
        .limit(1);
    return data.isEmpty ? null : data.first;
  }

  @override
  Future<List<Map<String, dynamic>>> fetchUsers(
      String? uid, String? email, String? phoneNumber) async {
    final field = uid != null
        ? 'uid'
        : email != null
            ? 'email'
            : 'phoneNumber';

    final value = uid ?? email ?? phoneNumber;

    final data =
        await supabase.from(DbTables.usersTable).select().eq(field, value!);
    return data;
  }

  @override
  Future<void> insertUser(UserModel userModel) async {
    await supabase.from(DbTables.usersTable).insert(userModel.toJson());
  }

  @override
  Future<void> updateUser(UserModel userModel, String uid) async {
    log('🚀 [USER_UPDATE] Starting user update process');
    log('👤 [USER_UPDATE] User ID: $uid');
    
    final data = userModel.toJson();
    log('📊 [USER_UPDATE] Original data keys: ${data.keys.toList()}');
    
    // Check for timestamp fields before removing nulls
    bool hasTimestamps = false;
    if (data.containsKey('dob_updated_at') && data['dob_updated_at'] != null) {
      log('🎂 [USER_UPDATE] DOB timestamp detected: ${data['dob_updated_at']}');
      hasTimestamps = true;
    }
    
    if (!hasTimestamps) {
      log('⚠️ [USER_UPDATE] No timestamp fields detected in update');
    }
    
    data.removeWhere((key, value) => value == null);
    log('📝 [USER_UPDATE] Final data keys after null removal: ${data.keys.toList()}');
    log('💾 [USER_UPDATE] Updating users table in Supabase...');
    
    try {
      await supabase
          .from(DbTables.usersTable)
          .update(data)
          .match({'hushh_id': uid});
      
      log('✅ [USER_UPDATE] User update successful!');
      if (hasTimestamps) {
        log('🎉 [USER_UPDATE] Timestamp fields successfully updated in database!');
      }
    } catch (e) {
      log('❌ [USER_UPDATE] Error updating user: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateAgent(AgentModel agent) async {
    final data = agent.toJson();
    data.remove('agent_brand');
    data.remove('agent_recent_lat');
    data.remove('agent_role');
    data.remove('agent_recent_long');

    await supabase
        .from(DbTables.agentsTable)
        .update(data)
        .match({'hushh_id': agent.hushhId!});
  }

  @override
  Future<void> insertAgent(AgentModel agent) async {
    final data = agent.toJson();
    data.remove('agent_recent_lat');
    data.remove('agent_recent_long');
    data.remove('agent_brand');
    data.remove('agent_role');
    await supabase.from(DbTables.agentsTable).insert(data);
  }

  @override
  Future<void> insertLocation(LocationModel location) async {
    final data = location.toJson();
    data.remove('id');
    await supabase.from(DbTables.locationsTable).insert(data);
  }

  @override
  Future<int> insertBrand(Brand brand) async {
    final data = brand.toJson();
    data.remove('id');
    data.remove('is_claimed');
    data.remove('agent_to_operate_for_brand_status');
    return (await supabase.from(DbTables.brandsTable).insert(data).select())
        .first['id'];
  }

  @override
  Future<List<Map<String, dynamic>>> fetchAgents(String? uid, String? email,
      AgentApprovalStatus? approvalStatus, int? brandId) async {
    const agentApprovalStatusEnumMap = {
      AgentApprovalStatus.approved: 'approved',
      AgentApprovalStatus.pending: 'pending',
      AgentApprovalStatus.denied: 'denied',
    };

    final field = uid != null
        ? 'hushh_id'
        : email != null
            ? 'agent_work_email'
            : approvalStatus != null
                ? 'agent_approval_status'
                : 'agent_brand_id';

    final value =
        uid ?? email ?? brandId ?? agentApprovalStatusEnumMap[approvalStatus];
    final data = await supabase
        .from(DbTables.agentsView)
        .select()
        .eq(field, value!)
        .order('created_at');
    return data;
  }

  @override
  Future<void> insertAgentRole(int brandId, String hushhId, AgentRole agentRole,
      AgentApprovalStatus status) async {
    await supabase.from(DbTables.brandTeamsTable).insert({
      "brand_id": brandId,
      "hushh_id": hushhId,
      "role": agentRole.name,
      "status": status.name
    });
  }
}
