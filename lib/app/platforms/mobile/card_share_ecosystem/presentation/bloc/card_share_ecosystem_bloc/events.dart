part of 'bloc.dart';

abstract class CardShareEcosystemEvent extends Equatable {
  const CardShareEcosystemEvent();

  @override
  List<Object> get props => [];
}

class FetchBrandOfferEvent extends CardShareEcosystemEvent {
  final int brandId;
  final BuildContext context;

  const FetchBrandOfferEvent(this.brandId, this.context);
}

class FetchBrandIdsFromGroupIdEvent extends CardShareEcosystemEvent {
  final int gId;
  final BuildContext context;

  const FetchBrandIdsFromGroupIdEvent(this.gId, this.context);
}

class FetchAllNearbyBrandsOfferEvent extends CardShareEcosystemEvent {
  final List<int> brandIds;
  final BuildContext context;

  const FetchAllNearbyBrandsOfferEvent(this.brandIds, this.context);
}

class CreateNewTaskAsUserForAgentEvent extends CardShareEcosystemEvent {
  final String? query;
  final int brandId;
  final int? cardId;

  const CreateNewTaskAsUserForAgentEvent(
      {this.query, required this.brandId, this.cardId});
}