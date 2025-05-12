part of 'bloc.dart';

/// Default State
@immutable
abstract class CardMarketState extends Equatable {
  const CardMarketState();

  @override
  List<Object> get props => [];
}

/// Default Auth Page State
class CardMarketInitialState extends CardMarketState {}

class AgentsFetchingState extends CardMarketState {}

class FetchedAgentsState extends CardMarketState {}

class DeletingCardState extends CardMarketState {}

class CardDeletedState extends CardMarketState {}

class InsertingCardState extends CardMarketState {}

class CardInsertedState extends CardMarketState {}

class SearchingForCardsState extends CardMarketState {}

class SearchCompletedForCardsState extends CardMarketState {}

class FetchingCardMarketState extends CardMarketState {}

class FetchedCardMarketState extends CardMarketState {}

class FetchingCardQuestionsState extends CardMarketState {}

class CardQuestionsFetchedState extends CardMarketState {
  final int cardId;

  const CardQuestionsFetchedState(this.cardId);
}

class UpdatingAnswersState extends CardMarketState {}

class AnswerUpdatedSuccessfullyState extends CardMarketState {}

class UpdatingBidValueState extends CardMarketState {}

class SomeErrorOccurredWhileUpdatingBidValueState extends CardMarketState {}

class BidValueUpdatedState extends CardMarketState {}

class FetchingBrandsState extends CardMarketState {}

class BrandsFetchedState extends CardMarketState {}

class InsertingBrandLocationsState extends CardMarketState {}

class BrandLocationInsertedState extends CardMarketState {}

class InsertingBrandState extends CardMarketState {}

class BrandInsertingState extends CardMarketState {}

class CardQuestionAnswerUpdatingState extends CardMarketState {}

class CardQuestionAnswerUpdatedState extends CardMarketState {}