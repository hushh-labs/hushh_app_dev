part of 'bloc.dart';

/// Default State
@immutable
abstract class HushhMeetState extends Equatable {
  const HushhMeetState();

  @override
  List<Object> get props => [];
}

/// Default Auth Page State
class HushhMeetInitialState extends HushhMeetState {}

class FetchingMeetingInfoState extends HushhMeetState {}

class MeetingInfoFetchedState extends HushhMeetState {}

class ConfirmingMeetState extends HushhMeetState {}

class MeetConfirmedState extends HushhMeetState {}


class CreatingNewMeetingState extends HushhMeetState {}

class NewMeetingCreatedState extends HushhMeetState {}

class FetchingMeetingsState extends HushhMeetState {}

class MeetingsFetchedState extends HushhMeetState {}