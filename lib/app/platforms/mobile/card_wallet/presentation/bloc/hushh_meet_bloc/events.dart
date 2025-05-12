part of 'bloc.dart';

abstract class HushhMeetEvent extends Equatable {
  const HushhMeetEvent();

  @override
  List<Object> get props => [];
}

class FetchMeetInfoEvent extends HushhMeetEvent {}

class FetchMeetInfoAsUserEvent extends HushhMeetEvent {}

class UpdateMeetInfoEvent extends HushhMeetEvent {}

class UserConfirmMeetEvent extends HushhMeetEvent {
  final String slot;
  final DateTime selectedDate;
  final BuildContext context;

  const UserConfirmMeetEvent(this.slot, this.context, this.selectedDate);
}

class CreateMeetingEvent extends HushhMeetEvent {
  final MeetingModel meeting;
  final BuildContext context;

  const CreateMeetingEvent(this.meeting, this.context);
}

class DeleteMeetingEvent extends HushhMeetEvent {
  final MeetingModel meeting;
  final BuildContext context;

  const DeleteMeetingEvent(this.meeting, this.context);
}

class FetchMeetingsEvent extends HushhMeetEvent {
  const FetchMeetingsEvent();
}
