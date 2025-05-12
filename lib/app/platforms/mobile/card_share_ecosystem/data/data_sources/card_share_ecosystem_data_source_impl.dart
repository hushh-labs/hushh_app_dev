import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/data/data_sources/card_share_ecosystem_data_source.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/task.dart';
import 'package:hushh_app/app/shared/core/backend_controller/db_controller/db_tables.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CardShareEcoSystemDataSourceImpl extends CardShareEcoSystemDataSource {
  final supabase = Supabase.instance.client;

  @override
  Future<List<Map<String, dynamic>>> fetchBrandOffers(
      List<int> brandIds) async {
    if (brandIds.isEmpty) {
      return [];
    }
    final data = await supabase.rpc('fetch_brand_offers',
        params: {'location_id_list': brandIds}).select();
    return data;
  }

  @override
  Future<Map<String, dynamic>> fetchBrandIdsFromGroupId(int gId) async {
    final data =
        await supabase.from('brand_groups').select().eq('gId', gId).single();
    return data;
  }

  @override
  Future<void> createNewTaskAsUserForAgent(
      TaskModel task) async {
    await supabase.from(DbTables.agentServices).insert(task.toJson());
  }
}
