import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_meeting.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/meeting_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/repository_impl/card_wallet_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class InsertMeetUseCase {
  final CardWalletPageRepositoryImpl cardWalletPageRepository;

  InsertMeetUseCase(this.cardWalletPageRepository);

  Future<Either<ErrorState, void>> call(
      {required MeetingModel meeting}) async {
    return await cardWalletPageRepository.insertMeet(meeting);
  }
}
