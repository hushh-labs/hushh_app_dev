import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/repository_impl/card_market_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class GeneratePlaidTokenUseCase {
  final CardMarketRepositoryImpl cardMarketRepository;

  GeneratePlaidTokenUseCase(this.cardMarketRepository);

  Future<Either<ErrorState, void>> call(String token) async {
    return await cardMarketRepository.generatePlaidToken(token);
  }
}
