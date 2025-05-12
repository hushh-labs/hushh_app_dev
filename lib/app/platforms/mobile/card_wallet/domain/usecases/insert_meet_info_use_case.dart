import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_meeting.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/repository_impl/card_wallet_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class InsertHushhMeetInfoUseCase {
  final CardWalletPageRepositoryImpl cardWalletPageRepository;

  InsertHushhMeetInfoUseCase(this.cardWalletPageRepository);

  Future<Either<ErrorState, void>> call(
      {required AgentMeeting meeting}) async {
    return await cardWalletPageRepository.insertHushhMeet(meeting);
  }
}
