part of 'bloc.dart';

/// Default State
@immutable
abstract class LookBookProductState extends Equatable {
  const LookBookProductState();

  @override
  List<Object> get props => [];
}

/// Default Auth Page State
class LookBookProductInitialState extends LookBookProductState {}

class LoadingState extends LookBookProductState {}

class DoneState extends LookBookProductState {}

class SendingProductInquiryState extends LookBookProductState {}

class ProductInquirySentState extends LookBookProductState {}

class FetchingLookBooksState extends LookBookProductState {}

class LookBooksFetchedState extends LookBookProductState {}

class LookBooksErrorState extends LookBookProductState {}

class LookBooksSearchState extends LookBookProductState {}

class ShowLookBookState extends LookBookProductState {}

class ProductSearchState extends LookBookProductState {}

class ProductSearchFinishedState extends LookBookProductState {}

class ShowProductState extends LookBookProductState {}

class CreatingLookBookState extends LookBookProductState {}