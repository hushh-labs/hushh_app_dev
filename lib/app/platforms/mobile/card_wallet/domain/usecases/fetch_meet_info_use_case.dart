import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_meeting.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/repository_impl/card_wallet_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class FetchHushhMeetInfoUseCase {
  final CardWalletPageRepositoryImpl cardWalletPageRepository;

  FetchHushhMeetInfoUseCase(this.cardWalletPageRepository);

  Future<Either<ErrorState, AgentMeeting?>> call(
      {required String uid}) async {
    return await cardWalletPageRepository.fetchHushhMeetInfo(uid);
  }
}
