part of 'bloc.dart';

abstract class AgentSignUpPageEvent extends Equatable {
  const AgentSignUpPageEvent();

  @override
  List<Object> get props => [];
}

class InitializeEvent extends AgentSignUpPageEvent {}

class FetchCategoriesEvent extends AgentSignUpPageEvent {}

class CaptureImageEvent extends AgentSignUpPageEvent {
  final ImageSource source;

  const CaptureImageEvent(this.source);
}

class UpdateAgentEvent extends AgentSignUpPageEvent {
  final BuildContext context;

  const UpdateAgentEvent(this.context);
}

class UpdateBrandCategoryEvent extends AgentSignUpPageEvent {
  final BuildContext context;

  const UpdateBrandCategoryEvent(this.context);
}

class CreateBrandEvent extends AgentSignUpPageEvent {
  final Brand brand;
  final BuildContext context;
  final List<LatLng> locations;

  const CreateBrandEvent(this.brand, this.context, this.locations);
}

class FetchBrandCategoriesEvent extends AgentSignUpPageEvent {}

class AgentSignUpEvent extends AgentSignUpPageEvent {
  final UserModel user;
  final BuildContext context;

  const AgentSignUpEvent(this.user, this.context);
}

class CreateNewBrandCardEvent extends AgentSignUpPageEvent {
  final Brand brand;
  final int brandId;
  final BuildContext context;
  final bool signUp;

  const CreateNewBrandCardEvent(this.brand, this.brandId, this.context,
      {this.signUp = false});
}

class CheckIfCardIsCreatedElseCreateNewBrandCardEvent
    extends AgentSignUpPageEvent {
  final Brand brand;
  final BuildContext context;

  const CheckIfCardIsCreatedElseCreateNewBrandCardEvent(
      this.brand, this.context);
}

class GenerateNewTxtRecordEvent extends AgentSignUpPageEvent {
  final BuildContext context;

  const GenerateNewTxtRecordEvent(this.context);
}
