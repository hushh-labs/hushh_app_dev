part of 'bloc.dart';

abstract class SplashPageEvent extends Equatable {
  const SplashPageEvent();

  @override
  List<Object> get props => [];
}

class InitializeEvent extends SplashPageEvent {}

class DisposeEvent extends SplashPageEvent {}

class OnVideoEndEvent extends SplashPageEvent {
  final double visibility;

  const OnVideoEndEvent(this.visibility);
}

class UpdateUserRegistrationTokenEvent extends SplashPageEvent {
  final String? token;
  final String? hushhId;

  const UpdateUserRegistrationTokenEvent({this.token, this.hushhId});
}

class InsertUserAgentNewLocationEvent extends SplashPageEvent {
  final Position position;
  final String hushhId;

  const InsertUserAgentNewLocationEvent(this.position, this.hushhId);
}

class FetchAndLoadAllBrandsInCityEvent extends SplashPageEvent {
  final String? place;
  final List<CardModel> installedBrandCards;

  const FetchAndLoadAllBrandsInCityEvent(
      {this.place, required this.installedBrandCards});
}

class OnUserTriggerGeoFenceEvent extends SplashPageEvent {
  final int brandLocationId;
  final int brandId;
  final GeofenceEventType eventType;

  const OnUserTriggerGeoFenceEvent(
      this.brandLocationId, this.brandId, this.eventType);
}

class ShareUserProfileAndRequirementsWithAgentsEvent extends SplashPageEvent {
  final String userId;
  final String query;
  final int brandId;
  final int cardId;
  final String? audioPath;
  final BuildContext context;

  const ShareUserProfileAndRequirementsWithAgentsEvent(
      {required this.userId,
      required this.query,
      required this.brandId,
      required this.cardId,
      this.audioPath,
      required this.context});
}
