import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/receipt_model.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/data/models/insights.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/data/repository_impl/receipt_radar_page_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class FetchReceiptRadarInsightsUseCase {
  final ReceiptRadarPageRepositoryImpl receiptRadarPageRepository;

  FetchReceiptRadarInsightsUseCase(this.receiptRadarPageRepository);

  Future<Either<ErrorState, List<ReceiptModel>>> call(
      {required String uid}) async {
    return await receiptRadarPageRepository
        .fetchReceiptRadarInsights(uid);
  }
}
