part of 'bloc.dart';

abstract class HomePageEvent extends Equatable {
  const HomePageEvent();

  @override
  List<Object> get props => [];
}

// add events here
class UpdateHomeScreenIndexEvent extends HomePageEvent {
  final int index;
  final BuildContext context;

  const UpdateHomeScreenIndexEvent(this.index, this.context);
}

class ConnectChromeExtension extends HomePageEvent {
  final BuildContext context;
  final String? data;

  ConnectChromeExtension(this.data, this.context);
}

class UpdateUserProfileEvent extends HomePageEvent {
  final Uint8List? bytes;

  const UpdateUserProfileEvent({this.bytes});
}

class UpdateAgentProfileEvent extends HomePageEvent {
  final Uint8List bytes;

  const UpdateAgentProfileEvent({required this.bytes});
}