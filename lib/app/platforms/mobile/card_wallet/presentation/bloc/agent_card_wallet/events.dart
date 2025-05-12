part of 'bloc.dart';

abstract class AgentCardWalletPageEvent extends Equatable {
  const AgentCardWalletPageEvent();

  @override
  List<Object> get props => [];
}

// add events here

class FetchCustomersEvent extends AgentCardWalletPageEvent {}

class FetchAgentCardEvent extends AgentCardWalletPageEvent {}

class FetchCardInfoEvent extends AgentCardWalletPageEvent {
  final String userUid;
  final int cardId;
  final BuildContext context;
  final String? query;
  final bool replace;

  const FetchCardInfoEvent(this.userUid, this.cardId, this.context,
      {this.query, this.replace = true});
}

class OnSuccessCardUnlockEvent extends AgentCardWalletPageEvent {
  final BuildContext context;
  final CardModel? cardData;
  final CustomerModel? customer;
  final PaymentModel? payment;
  final CardInfoUnlockMethod cardInfoUnlockMethod;

  const OnSuccessCardUnlockEvent(
      {required this.context,
      this.cardData,
      this.payment,
      this.customer,
      required this.cardInfoUnlockMethod});
}

class OnAttachingCardsEvent extends AgentCardWalletPageEvent {
  final List<CardModel> selectedCards;
  final bool isBrandCard;
  final CardModel cardData;
  final BuildContext context;

  const OnAttachingCardsEvent(
    this.selectedCards,
    this.isBrandCard,
    this.cardData,
    this.context,
  );
}

class ContactAgentEvent extends AgentCardWalletPageEvent {
  final BuildContext context;

  const ContactAgentEvent(this.context);
}

class FetchAttachedCardsEvent extends AgentCardWalletPageEvent {
  final int? cid;

  const FetchAttachedCardsEvent(this.cid);
}

class FetchAgentToUpdateLocalAgentEvent extends AgentCardWalletPageEvent {}

class FetchUserRequestAgainstBrand extends AgentCardWalletPageEvent {
  final String userId;
  final int brandId;

  const FetchUserRequestAgainstBrand(this.userId, this.brandId);
}
