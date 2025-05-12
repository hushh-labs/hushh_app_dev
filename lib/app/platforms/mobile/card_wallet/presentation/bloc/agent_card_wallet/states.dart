part of 'bloc.dart';

/// Default State
@immutable
abstract class AgentCardWalletPageState extends Equatable {
  const AgentCardWalletPageState();

  @override
  List<Object> get props => [];
}

class AgentCardWalletPageInitialState extends AgentCardWalletPageState {}

class FetchingCustomersState extends AgentCardWalletPageState {}

class FetchedCustomersState extends AgentCardWalletPageState {}

class FetchedBrandInfoState extends AgentCardWalletPageState {}

class LoadingState extends AgentCardWalletPageState {}

class DoneState extends AgentCardWalletPageState {}

class FetchingAttachedCardsState extends AgentCardWalletPageState {}

class FetchedAttachedCardsState extends AgentCardWalletPageState {}

class FetchingAgentState extends AgentCardWalletPageState {}

class AgentFetchedState extends AgentCardWalletPageState {}