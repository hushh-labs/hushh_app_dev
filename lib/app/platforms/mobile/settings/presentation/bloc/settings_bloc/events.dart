part of 'bloc.dart';

abstract class SettingsPageEvent extends Equatable {
  const SettingsPageEvent();

  @override
  List<Object> get props => [];
}

// add events here
class LogoutEvent extends SettingsPageEvent {
  final BuildContext context;

  const LogoutEvent(this.context);
}

class DeleteAccountEvent extends SettingsPageEvent {
  final BuildContext context;
  final bool isAgentAccount;

  const DeleteAccountEvent(this.context, this.isAgentAccount);
}

class IsUserUsingChromeExtensionEvent extends SettingsPageEvent {}

class CheckForAnyDeviceActivityDataStoredInDbEvent extends SettingsPageEvent {}

class InsertMultipleAppUsagesEvent extends SettingsPageEvent {
  final List<AppUsageData> appUsages;

  const InsertMultipleAppUsagesEvent(this.appUsages);
}

class FetchUserTypeBasedOnBrowsingBehaviourEvent extends SettingsPageEvent {
  final String hushhId;

  const FetchUserTypeBasedOnBrowsingBehaviourEvent(this.hushhId);
}

class FetchProductsBasedOnBrowsingBehaviourEvent extends SettingsPageEvent {
  final String hushhId;

  const FetchProductsBasedOnBrowsingBehaviourEvent(this.hushhId);
}

class FetchBrowsedCollectionsBasedOnBrowsingBehaviourEvent
    extends SettingsPageEvent {
  final String hushhId;

  const FetchBrowsedCollectionsBasedOnBrowsingBehaviourEvent(this.hushhId);
}

class InsertBrowsedProductEvent extends SettingsPageEvent {
  final BrowsedProduct browsedProduct;

  const InsertBrowsedProductEvent(this.browsedProduct);
}

class InitiateLoginInExtensionWithHushhQrEvent extends SettingsPageEvent {
  final String code;
  final BuildContext context;

  const InitiateLoginInExtensionWithHushhQrEvent(this.code, this.context);
}
