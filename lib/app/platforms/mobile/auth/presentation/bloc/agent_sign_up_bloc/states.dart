part of 'bloc.dart';

abstract class AgentSignUpPageState extends Equatable {
  const AgentSignUpPageState();

  @override
  List<Object> get props => [];
}

/// Default Auth Page State
class AgentSignUpPageInitialState extends AgentSignUpPageState {}

class FetchingAllCategoriesState extends AgentSignUpPageState {}

class AllCategoriesFetchedState extends AgentSignUpPageState {}

class CapturingImageState extends AgentSignUpPageState {}

class ImageCapturedState extends AgentSignUpPageState {}

class UpdatingAgentState extends AgentSignUpPageState {}

class UpdatedAgentState extends AgentSignUpPageState {}

class SelectingCategoryState extends AgentSignUpPageState {}

class CategorySelectedState extends AgentSignUpPageState {}

class UpdatingBrandCategoryState extends AgentSignUpPageState {}

class UpdatedBrandCategoryState extends AgentSignUpPageState {
  final BrandCategory value;

  const UpdatedBrandCategoryState(this.value);
}

class CreatingBrandState extends AgentSignUpPageState {}

class BrandCreatedState extends AgentSignUpPageState {}

class BandCreationErrorState extends AgentSignUpPageState {}

class FetchingAllBrandCategoriesState extends AgentSignUpPageState {}

class AllBrandCategoriesFetchedState extends AgentSignUpPageState {}


class CheckingIfCardExistsInCardMarketState extends AgentSignUpPageState {}

class CardDoesNotExistsInCardMarketState extends AgentSignUpPageState {}

class CardExistsInCardMarketState extends AgentSignUpPageState {}
