part of 'bloc.dart';

/// Default State
@immutable
abstract class SettingsPageState extends Equatable {
  const SettingsPageState();

  @override
  List<Object> get props => [];
}

/// Default Auth Page State
class SettingsPageInitialState extends SettingsPageState {}

class DeletingAccountState extends SettingsPageState {}

class AccountDeletedState extends SettingsPageState {}

class FetchingUserInfoState extends SettingsPageState {}

class UserInfoFetchedState extends SettingsPageState {}

class FetchingVisitInfoState extends SettingsPageState {}

class VisitInfoFetchedState extends SettingsPageState {}

class FetchingBrandsInfoState extends SettingsPageState {}

class BrandsInfoFetchedState extends SettingsPageState {}

class FetchingWishListState extends SettingsPageState {}

class WishListFetchedState extends SettingsPageState {}

class FetchingAppUsageCountState extends SettingsPageState {}

class AppUsageCountFetchedState extends SettingsPageState {}

class InsertingMultipleAppUsagesState extends SettingsPageState {}

class InsertedMultipleAppUsagesState extends SettingsPageState {}

class AppIdsFetchedState extends SettingsPageState {}

class AfterUsageInsertedState extends SettingsPageState {}

class InsertingBrowsedProductState extends SettingsPageState {}

class InsertedBrowsedProductState extends SettingsPageState {}

class CheckingIfUserInitiatedLoginState extends SettingsPageState {}

class UserInitiatedLoginFlowState extends SettingsPageState {}

class UserHaventInitiatedLoginFlowState extends SettingsPageState {}