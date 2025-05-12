import 'package:hushh_app/app/platforms/mobile/receipt_radar/data/data_sources/receipt_radar_page_supabase_data_source.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/data/models/receipt_radar_history.dart';
import 'package:hushh_app/app/shared/core/backend_controller/db_controller/db_tables.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReceiptRadarPageSupabaseDataSourceImpl
    extends ReceiptRadarPageSupabaseDataSource {
  final supabase = Supabase.instance.client;

  @override
  Future<List<Map<String, dynamic>>> fetchReceiptRadar(String uid) async {
    final data = await supabase
        .rpc('fetch_receipts')
        .eq('user_id', uid)
        .not('message_id', 'is', null)
        .select();
    return data;
  }

  @override
  Future<String> updateReceiptRadarHistory(
      ReceiptRadarHistory receiptRadarHistory) async {
    final data = await supabase
        .from(DbTables.receiptRadarHistory)
        .update(receiptRadarHistory.toJson())
        .match({'email': receiptRadarHistory.email}).select();
    print("data[0]['id'].toString()::${data[0]['id'].toString()}");
    return data[0]['id'].toString();
  }
}
