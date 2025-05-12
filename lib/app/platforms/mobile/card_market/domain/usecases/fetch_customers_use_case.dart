import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/repository_impl/card_market_repository_impl.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/customer_model.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class FetchCustomersUseCase {
  final CardMarketRepositoryImpl cardMarketRepository;

  FetchCustomersUseCase(this.cardMarketRepository);

  Future<Either<ErrorState, List<CustomerModel>>> call(
      {required String agentId}) async {
    return await cardMarketRepository.fetchCustomers(agentId);
  }
}
