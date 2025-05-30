part of 'bloc.dart';

/// Default State
@immutable
abstract class CardWalletPageState extends Equatable {
  const CardWalletPageState();

  @override
  List<Object> get props => [];
}

/// Default Auth Page State
class CardWalletPageInitialState extends CardWalletPageState {}

class InitializingState extends CardWalletPageState {}


class InitializedState extends CardWalletPageState {}

class FetchingAnswersState extends CardWalletPageState {}

class FetchedAnswersState extends CardWalletPageState {
  final List? answers;

  const FetchedAnswersState(this.answers);
}

class CoinsUpdatingState extends CardWalletPageState {}

class CoinsUpdatedState extends CardWalletPageState {}

class FetchingUpdatedAccessListState extends CardWalletPageState {}

class FetchedUpdatedAccessListState extends CardWalletPageState {
  final List<String> accessList;

  const FetchedUpdatedAccessListState(this.accessList);
}

class FetchingAgentsWithAccessState extends CardWalletPageState {}

class AgentsFetchedWithAccessState extends CardWalletPageState {}

class UpdatingAudioState extends CardWalletPageState {}

class AudioUpdatedState extends CardWalletPageState {}

class UpdatingBusinessCardNameState extends CardWalletPageState {}

class BusinessCardNameUpdatedState extends CardWalletPageState {}

class UpdatingBusinessCardLinksState extends CardWalletPageState {}

class BusinessCardLinksUpdatedState extends CardWalletPageState {}

class GeneratingAudioTranscriptionState extends CardWalletPageState {}

class AudioTranscriptionGeneratedState extends CardWalletPageState {}

class FetchingInsuranceDataState extends CardWalletPageState {}

class InsuranceDataFetchedState extends CardWalletPageState {}

class FetchingTravelDataState extends CardWalletPageState {}

class TravelDataFetchedState extends CardWalletPageState {}

class FetchingPurchasedItemsState extends CardWalletPageState {}

class PurchasedItemsFetchedState extends CardWalletPageState {}

class FetchingSharedPreferencesState extends CardWalletPageState {}

class SharedPreferencesFetchedState extends CardWalletPageState {}

class InsertingSharedPreferenceState extends CardWalletPageState {}

class SharedPreferenceInsertedState extends CardWalletPageState {
  final String successMessage;

  const SharedPreferenceInsertedState(this.successMessage);

  @override
  List<Object> get props => [successMessage];
}

class ErrorInsertingSharedPreferenceState extends CardWalletPageState {}
