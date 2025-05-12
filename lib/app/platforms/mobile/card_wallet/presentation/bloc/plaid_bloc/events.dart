part of 'bloc.dart';

abstract class PlaidEvent extends Equatable {
  const PlaidEvent();

  @override
  List<Object> get props => [];
}

class FetchFinanceCardInfoEvent extends PlaidEvent {
  final BuildContext context;

  const FetchFinanceCardInfoEvent(this.context);
}