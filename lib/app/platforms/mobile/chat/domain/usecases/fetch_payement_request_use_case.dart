import 'package:dartz/dartz.dart';
import 'package:hushh_app/app/platforms/mobile/chat/data/repository_impl/chat_repository_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';
import 'package:hushh_app/app/shared/core/models/payment_model.dart';

class FetchPaymentRequestUseCase {
  final ChatRepositoryImpl chatRepository;

  FetchPaymentRequestUseCase(this.chatRepository);

  Future<Either<ErrorState, List<PaymentModel>>> call({required String pId}) async {
    return await chatRepository.fetchPaymentRequest(pId);
  }
}
