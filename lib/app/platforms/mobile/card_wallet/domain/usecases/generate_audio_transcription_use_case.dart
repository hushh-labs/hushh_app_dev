import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/models/audio_transcription.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/repository_impl/card_wallet_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';

class GenerateAudioTranscriptionUseCase {
  final CardWalletPageRepositoryImpl cardWalletPageRepository;

  GenerateAudioTranscriptionUseCase(this.cardWalletPageRepository);

  Future<Either<ErrorState, AudioTranscription>> call(
      {required String audioUrl}) async {
    return await cardWalletPageRepository.generateAudioTranscription(audioUrl);
  }
}
