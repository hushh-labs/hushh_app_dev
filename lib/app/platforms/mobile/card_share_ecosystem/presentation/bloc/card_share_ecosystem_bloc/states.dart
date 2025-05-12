part of 'bloc.dart';

/// Default State
@immutable
abstract class CardShareEcosystemState extends Equatable {
  const CardShareEcosystemState();

  @override
  List<Object> get props => [];
}

class CardShareEcosystemInitialState extends CardShareEcosystemState {}

class FetchingBrandOffersState extends CardShareEcosystemState {}

class BrandOffersFetchedState extends CardShareEcosystemState {}

class FetchingAllNearbyBrandsOffersState extends CardShareEcosystemState {}

class AllNearbyBrandsOffersFetchedState extends CardShareEcosystemState {}

class FetchingBrandIdsState extends CardShareEcosystemState {}

class BrandIdsFetchedState extends CardShareEcosystemState {}

class NewTaskCreatingState extends CardShareEcosystemState {}

class NewTaskCreatedState extends CardShareEcosystemState {}
