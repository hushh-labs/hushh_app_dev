part of 'bloc.dart';

/// Default State
@immutable
abstract class ReceiptRadarState extends Equatable {
  const ReceiptRadarState();

  @override
  List<Object> get props => [];
}

/// Default Splash Page State
class ReceiptRadarInitialState extends ReceiptRadarState {}

class ReceiptRadarFetchingState extends ReceiptRadarState {}

class ReceiptRadarFetchedState extends ReceiptRadarState {}

class ReceiptRadarFilterUpdatingState extends ReceiptRadarState {}

class ReceiptRadarFilterUpdatedState extends ReceiptRadarState {}

class FetchingCategoriesFromReceiptsState extends ReceiptRadarState {}

class FetchedCategoriesFromReceiptsState extends ReceiptRadarState {}