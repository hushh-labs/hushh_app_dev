import 'package:hushh_app/app/platforms/mobile/receipt_radar/data/models/receipt_radar_history.dart';

abstract class ReceiptRadarPageSupabaseDataSource {
  Future<List<Map<String, dynamic>>> fetchReceiptRadar(String uid);

  Future<String> updateReceiptRadarHistory(ReceiptRadarHistory receiptRadarHistory);
}
