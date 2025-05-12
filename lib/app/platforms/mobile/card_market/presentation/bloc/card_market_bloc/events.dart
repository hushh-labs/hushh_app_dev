part of 'bloc.dart';

abstract class CardMarketEvent extends Equatable {
  const CardMarketEvent();

  @override
  List<Object> get props => [];
}

class FetchAgentsEvent extends CardMarketEvent {}

class SearchAgentsEvent extends CardMarketEvent {
  final String value;

  const SearchAgentsEvent(this.value);
}

class DeleteCardEvent extends CardMarketEvent {
  final int cardId;

  const DeleteCardEvent(this.cardId);
}

class InsertCardInUserInstalledCardsEvent extends CardMarketEvent {
  final CardModel card;
  final BuildContext context;

  const InsertCardInUserInstalledCardsEvent(this.card, this.context);
}

class UpdateMinimumBidValueEvent extends CardMarketEvent {
  final BuildContext context;
  final CardModel cardModel;
  final String bidValue;
  final Currency currency;

  const UpdateMinimumBidValueEvent(this.context, this.cardModel, this.bidValue, this.currency);
}

class UpdateAnswersEvent extends CardMarketEvent {
  final int index;
  final List<String> answers;
  final BuildContext context;
  final CardModel cardData;

  const UpdateAnswersEvent(this.index, this.answers, this.context, this.cardData);
}

class FetchCardMarketEvent extends CardMarketEvent {}

class SearchCardInCardMarketEvent extends CardMarketEvent {
  final String text;

  const SearchCardInCardMarketEvent(this.text);
}

class FetchCardQuestionsEvent extends CardMarketEvent {
  final int cardId;
  final String? question;
  final BuildContext context;

  const FetchCardQuestionsEvent(this.cardId, this.context, {this.question});
}

class FetchBrandsEvent extends CardMarketEvent {}

class InsertBrandLocationsEvent extends CardMarketEvent {
  final List<BrandLocation> locations;

  const InsertBrandLocationsEvent(this.locations);
}

class InsertCardEvent extends CardMarketEvent {
  final CardModel brandCard;
  final BuildContext context;
  final Brand? brand;
  final bool afterInsertingCardSignUpAgent;

  const InsertCardEvent(this.brandCard, this.context, {this.brand, this.afterInsertingCardSignUpAgent = false});
}

class ToggleCardQuestionAnswerSelectionEvent extends CardMarketEvent {
  final dynamic answer;
  final int questionIndex;
  final bool onlyAdd;

  const ToggleCardQuestionAnswerSelectionEvent(this.answer, this.questionIndex,
      {this.onlyAdd = false});
}
