import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/inventory_schema_response.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/repository_impl/card_wallet_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class FetchColumnsAndDataTypesFromGoogleSheetUseCase {
  final CardWalletPageRepositoryImpl cardWalletPageRepository;

  FetchColumnsAndDataTypesFromGoogleSheetUseCase(this.cardWalletPageRepository);

  Future<Either<ErrorState, InventorySchemaResponse>> call({required String sheetId}) async {
    return await cardWalletPageRepository
        .fetchColumnsAndDataTypesFromGoogleSheet(sheetId);
  }
}
