import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/receipt_model.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/data/models/insights.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/data/models/receipt_radar_history.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

abstract class ReceiptRadarPageRepository {
  Future<Either<ErrorState, List<ReceiptModel>>> fetchReceiptRadarInsights(String uid);

  Future<Either<ErrorState, String>> updateReceiptRadarHistory(ReceiptRadarHistory receiptRadarHistory);
}
