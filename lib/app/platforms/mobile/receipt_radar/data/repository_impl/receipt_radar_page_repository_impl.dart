import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/receipt_model.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/data/data_sources/receipt_radar_page_supabase_data_source_impl.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/data/models/receipt_radar_history.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/domain/repository/receipt_radar_page_repository.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_handler.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class ReceiptRadarPageRepositoryImpl extends ReceiptRadarPageRepository {
  final ReceiptRadarPageSupabaseDataSourceImpl
      receiptRadarPageSupabaseDataSource;

  ReceiptRadarPageRepositoryImpl(this.receiptRadarPageSupabaseDataSource);

  @override
  Future<Either<ErrorState, List<ReceiptModel>>> fetchReceiptRadarInsights(
      String uid) async {
    return await ErrorHandler.callSupabase(
        () => receiptRadarPageSupabaseDataSource.fetchReceiptRadar(uid),
        (value) {
      final result = value as List<Map<String, dynamic>>;
      return result
          .map((e) => ReceiptModel.fromJson(e))
          .toList();
    });
  }

  @override
  Future<Either<ErrorState, String>> updateReceiptRadarHistory(
      ReceiptRadarHistory receiptRadarHistory) async {
    return await ErrorHandler.callSupabase(
        () => receiptRadarPageSupabaseDataSource
            .updateReceiptRadarHistory(receiptRadarHistory), (value) {
      return value as String;
    });
  }
}
