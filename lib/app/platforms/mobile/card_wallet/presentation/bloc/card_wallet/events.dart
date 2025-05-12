part of 'bloc.dart';

abstract class CardWalletPageEvent extends Equatable {
  const CardWalletPageEvent();

  @override
  List<Object> get props => [];
}

// add events here
class CardWalletInitializeEvent extends CardWalletPageEvent {
  final BuildContext context;
  final bool refresh;
  final bool reload;
  final bool signUp;
  final Function(Function())? setState;

  const CardWalletInitializeEvent(this.context,
      {this.refresh = false,
      this.setState,
      this.reload = false,
      this.signUp = false});
}

class FetchCardAnswersEvent extends CardWalletPageEvent {}

class IncrementCoinEvent extends CardWalletPageEvent {
  final int length;

  const IncrementCoinEvent(this.length);
}

class UpdateUserRoleEvent extends CardWalletPageEvent {
  final Entity entity;
  final BuildContext context;

  const UpdateUserRoleEvent(this.entity, this.context);
}

class OnTokenUsageEvent extends CardWalletPageEvent {
  final int count;

  const OnTokenUsageEvent(this.count);
}

class ResetTokenUsageEvent extends CardWalletPageEvent {}

class FetchUpdatedAccessListEvent extends CardWalletPageEvent {
  final int cardId;

  const FetchUpdatedAccessListEvent(this.cardId);
}

class FetchAgentsWithAccessToTheCard extends CardWalletPageEvent {}

class UpdateBusinessCardNameEvent extends CardWalletPageEvent {
  final CardModel businessCard;
  final String name;
  final BuildContext context;

  const UpdateBusinessCardNameEvent(this.businessCard, this.name, this.context);
}

class UpdateBusinessCardLinksEvent extends CardWalletPageEvent {
  final CardModel businessCard;
  final List<String> links;
  final BuildContext context;

  const UpdateBusinessCardLinksEvent(
      this.businessCard, this.links, this.context);
}

class GenerateAudioTranscriptionEvent extends CardWalletPageEvent {
  final CardModel card;
  final BuildContext context;

  const GenerateAudioTranscriptionEvent(this.card, this.context);
}

class FetchInsuranceDetailsEvent extends CardWalletPageEvent {
  final CardModel? card;

  const FetchInsuranceDetailsEvent({this.card});
}

class FetchTravelDetailsEvent extends CardWalletPageEvent {
  final CardModel card;

  const FetchTravelDetailsEvent(this.card);
}

class InstallCardFromMarketplaceEvent extends CardWalletPageEvent {
  final int cardId;
  final BuildContext context;

  const InstallCardFromMarketplaceEvent(this.cardId, this.context);
}

class FetchPurchasedItemsEvent extends CardWalletPageEvent {}

class FetchSharedPreferencesEvent extends CardWalletPageEvent {
  final String hushhId;
  final int cardId;

  const FetchSharedPreferencesEvent({required this.hushhId, required this.cardId});
}

class AddNewPreferenceToCardEvent extends CardWalletPageEvent {
  final UserPreference preference;
  final String hushhId;
  final int cardId;

  const AddNewPreferenceToCardEvent({
    required this.preference,
    required this.hushhId,
    required this.cardId,
  });
}

class OnClickingSharePreferenceButtonEvent extends CardWalletPageEvent {
  final BuildContext context;

  const OnClickingSharePreferenceButtonEvent(this.context);
}