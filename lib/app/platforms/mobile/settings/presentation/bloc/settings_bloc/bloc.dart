import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/fetch_user_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/delete_user_installed_card_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/app_usage_data.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/brand.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/browsed_collection.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/browsed_product_model.dart';
import 'package:hushh_app/app/platforms/mobile/settings/domain/usecases/after_usage_inserted_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/settings/domain/usecases/delete_account_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/settings/domain/usecases/fetch_app_ids_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/settings/domain/usecases/fetch_app_usage_count_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/settings/domain/usecases/fetch_browsing_behaviour_products_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/settings/domain/usecases/fetch_browsing_behaviour_visit_times_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/settings/domain/usecases/fetch_browsing_behaviour_wish_list_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/settings/domain/usecases/initiate_login_in_extension_with_hushh_qr_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/settings/domain/usecases/insert_browsed_product_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/settings/domain/usecases/insert_multiple_app_usage_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/settings/domain/usecases/link_hushh_id_with_extension_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/components/account_deleting_bottom_sheet.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

part 'events.dart';

part 'states.dart';

class SettingsPageBloc extends Bloc<SettingsPageEvent, SettingsPageState> {
  final DeleteAccountUseCase deleteAccountUseCase;
  final DeleteUserInstalledCardsUseCase deleteUserInstalledCardsUseCase;
  final FetchUserUseCase fetchUserUseCase;
  final FetchBrowsingBehaviourVisitTimesUseCase
      fetchBrowsingBehaviourVisitTimesUseCase;
  final FetchBrowsingBehaviourProductsUseCase
      fetchBrowsingBehaviourProductsUseCase;
  final FetchBrowsingBehaviourWishListUseCase
      fetchBrowsingBehaviourWishListUseCase;
  final FetchAppUsageCountUseCase fetchAppUsageCountUseCase;
  final InsertMultipleAppUsagesUseCase insertMultipleAppUsagesUseCase;
  final AfterUsageInsertedUseCase afterUsageInsertedUseCase;
  final FetchAppIdsUseCase fetchAppIdsUseCase;
  final InsertBrowsedProductUseCase insertBrowsedProductUseCase;
  final InitiateLoginInExtensionWithHushhQrUseCase
      initiateLoginInExtensionWithHushhQr;
  final LinkHushhIdWithExtensionUseCase linkHushhIdWithExtensionUseCase;

  SettingsPageBloc(
    this.deleteAccountUseCase,
    this.deleteUserInstalledCardsUseCase,
    this.fetchUserUseCase,
    this.fetchBrowsingBehaviourVisitTimesUseCase,
    this.fetchBrowsingBehaviourProductsUseCase,
    this.fetchBrowsingBehaviourWishListUseCase,
    this.fetchAppUsageCountUseCase,
    this.insertMultipleAppUsagesUseCase,
    this.afterUsageInsertedUseCase,
    this.fetchAppIdsUseCase,
    this.insertBrowsedProductUseCase,
    this.initiateLoginInExtensionWithHushhQr,
    this.linkHushhIdWithExtensionUseCase,
  ) : super(SettingsPageInitialState()) {
    on<LogoutEvent>(logoutEvent);
    on<DeleteAccountEvent>(deleteAccountEvent);
    on<IsUserUsingChromeExtensionEvent>(isUserUsingChromeExtensionEvent);
    on<CheckForAnyDeviceActivityDataStoredInDbEvent>(
        checkForAnyDeviceActivityDataStoredInDbEvent);
    on<InsertMultipleAppUsagesEvent>(insertMultipleAppUsagesEvent);
    on<FetchUserTypeBasedOnBrowsingBehaviourEvent>(
        fetchUserTypeBasedOnBrowsingBehaviourEvent);
    on<FetchProductsBasedOnBrowsingBehaviourEvent>(
        fetchProductsBasedOnBrowsingBehaviourEvent);
    on<FetchBrowsedCollectionsBasedOnBrowsingBehaviourEvent>(
        fetchBrowsedCollectionsBasedOnBrowsingBehaviourEvent);
    on<InsertBrowsedProductEvent>(insertBrowsedProductEvent);
    on<InitiateLoginInExtensionWithHushhQrEvent>(
        initiateLoginInExtensionWithHushhQrEvent);
  }

  DayNight? browsingBehaviourPersonType;
  List<BrowsedProduct>? allBrowsedProducts;

  List<BrowsedCollection>? collections;

  List? appUsage;

  List<Brand>? get topSearchBrands {
    // Check if allBrowsedProducts is not null
    if (allBrowsedProducts == null || allBrowsedProducts!.isEmpty) {
      return null; // Return empty list if allBrowsedProducts is null or empty
    }

    // Map to count occurrences of brands
    final Map<String, int> brandCounts = {};

    // Iterate through allBrowsedProducts to count occurrences of each brand
    allBrowsedProducts!
        .where((element) => element.brand != null)
        .forEach((product) {
      final brandName = product.brand!.brandName;
      brandCounts[brandName] = (brandCounts[brandName] ?? 0) + 1;
    });

    // Sort brands by occurrence count
    final sortedBrands = brandCounts.keys.toList()
      ..sort((a, b) => brandCounts[b]!.compareTo(brandCounts[a]!));

    // Extract top searched brands
    final topBrands = sortedBrands.take(3).toList();

    // Convert top searched brand names to Brand objects
    final List<Brand> topBrandObjects = [];
    topBrands.forEach((brandName) {
      final brand = allBrowsedProducts!
          .firstWhere((product) =>
              product.brand != null && product.brand!.brandName == brandName)
          .brand;
      topBrandObjects.add(brand!);
    });

    return topBrandObjects;
  }

  Map<String, int> brandCounts = {};

  Future<void> _deleteAgentFromSupabase(context) async {
    if (AppLocalStorage.hushhId == null) {
      ToastManager(Toast(
              title: 'We are unable to delete the agent account at the moment',
              description: 'ERR102A: Please contact support team'))
          .show(context);
    }
    final supabase = Supabase.instance.client;
    final response = await supabase.rpc('delete_agent_account',
        params: {'p_hushh_id': AppLocalStorage.hushhId});
  }

  Future<void> _deleteUserFromSupabase(context) async {
    if (AppLocalStorage.hushhId == null) {
      ToastManager(Toast(
              title: 'We are unable to delete the account at the moment',
              description: 'ERR102A: Please contact support team'))
          .show(context);
    }
    final supabase = Supabase.instance.client;
    final response = await supabase.rpc('delete_user_account',
        params: {'p_hushh_id': AppLocalStorage.hushhId});
  }

  Future<void> _deleteUser(context) async {
    final result = await deleteAccountUseCase();
    result.fold((l) {
      ToastManager(Toast(
              title: 'Unable to delete Account',
              type: ToastificationType.error,
              description:
                  'There\'s an error in deleting the account from server.'))
          .show(context);
    }, (r) {});
  }

  Future<void> _deleteUserInstalledCards() async {
    await deleteUserInstalledCardsUseCase(userId: AppLocalStorage.hushhId);
  }

  FutureOr<void> logoutEvent(
      LogoutEvent event, Emitter<SettingsPageState> emit) async {
    await AppLocalStorage.logout();
    await clearAndReinitializeDependencies();
    await GoogleSignIn().signOut();
    Navigator.pushNamedAndRemoveUntil(
        event.context, AppRoutes.splash, (route) => false);
  }

  FutureOr<void> deleteAccountEvent(
      DeleteAccountEvent event, Emitter<SettingsPageState> emit) async {
    if (state is! DeletingAccountState) {
      emit(DeletingAccountState());

      showBottomSheet(
        context: event.context,
        enableDrag: false,
        builder: (context) {
          return const AccountDeletingBottomSheet();
        },
      );
      if (event.isAgentAccount) {
        await _deleteAgentFromSupabase(event.context);
      } else {
        await _deleteUserFromSupabase(event.context);
      }

      await AppLocalStorage.logout();

      Navigator.pop(event.context);
      emit(AccountDeletedState());
      Navigator.pushNamedAndRemoveUntil(
          event.context, AppRoutes.splash, (route) => false);
    }
  }

  FutureOr<void> isUserUsingChromeExtensionEvent(
      IsUserUsingChromeExtensionEvent event,
      Emitter<SettingsPageState> emit) async {
    emit(FetchingUserInfoState());
    await fetchUserUseCase(uid: AppLocalStorage.hushhId).then((result) async {
      await result.fold((l) => null, (r) async {
        if (r != null) {
          AppLocalStorage.updateUser(r);
          emit(UserInfoFetchedState());
        }
      });
    });
  }

  FutureOr<void> fetchUserTypeBasedOnBrowsingBehaviourEvent(
      FetchUserTypeBasedOnBrowsingBehaviourEvent event,
      Emitter<SettingsPageState> emit) async {
    DayNight getDayNight(DateTime dateTime) {
      final int hour = dateTime.hour;
      return (hour >= 6 && hour < 18) ? DayNight.day : DayNight.night;
    }

    DayNight getPersonType(List<DateTime> visitTimes) {
      int dayVisits = 0;
      int nightVisits = 0;

      for (DateTime visitTime in visitTimes) {
        DayNight period = getDayNight(visitTime);
        if (period == DayNight.day) {
          dayVisits++;
        } else {
          nightVisits++;
        }
      }

      return (dayVisits > nightVisits) ? DayNight.day : DayNight.night;
    }

    emit(FetchingVisitInfoState());
    final result =
        await fetchBrowsingBehaviourVisitTimesUseCase(hushhId: event.hushhId);
    await result.fold((l) => null, (r) async {
      // for(var d in r) {
      //   print(DateFormat("hh:mm aa").format(d));
      // }
      browsingBehaviourPersonType = getPersonType(r);
      emit(VisitInfoFetchedState());
    });
  }

  FutureOr<void> fetchProductsBasedOnBrowsingBehaviourEvent(
      FetchProductsBasedOnBrowsingBehaviourEvent event,
      Emitter<SettingsPageState> emit) async {
    emit(FetchingBrandsInfoState());
    final result =
        await fetchBrowsingBehaviourProductsUseCase(hushhId: event.hushhId);
    await result.fold((l) => null, (r) async {
      r.sort((a, b) => a.timestamp.isBefore(b.timestamp) ? 1 : 0);
      allBrowsedProducts = r;
      // r.where((element) => element.brand?.brandName != 'OTHERS').toList();
      emit(BrandsInfoFetchedState());
    });
  }

  FutureOr<void> fetchBrowsedCollectionsBasedOnBrowsingBehaviourEvent(
      FetchBrowsedCollectionsBasedOnBrowsingBehaviourEvent event,
      Emitter<SettingsPageState> emit) async {
    emit(FetchingWishListState());
    final result =
        await fetchBrowsingBehaviourWishListUseCase(hushhId: event.hushhId);
    await result.fold((l) => null, (r) async {
      collections = r;
      emit(WishListFetchedState());
    });
  }

  FutureOr<void> checkForAnyDeviceActivityDataStoredInDbEvent(
      CheckForAnyDeviceActivityDataStoredInDbEvent event,
      Emitter<SettingsPageState> emit) async {
    emit(FetchingAppUsageCountState());
    final result =
        await fetchAppUsageCountUseCase(hushhId: AppLocalStorage.hushhId!);
    await result.fold((l) => null, (r) async {
      bool dataStoredInDb = r != null && r != 0;
      AppLocalStorage.setAppUsagePermission(dataStoredInDb);
      emit(AppUsageCountFetchedState());
    });
  }

  FutureOr<void> insertMultipleAppUsagesEvent(
      InsertMultipleAppUsagesEvent event,
      Emitter<SettingsPageState> emit) async {
    emit(InsertingMultipleAppUsagesState());
    List<AppUsageData> appUsages = removeDuplicates(event.appUsages);
    final result =
        await insertMultipleAppUsagesUseCase(appUsages: event.appUsages);
    await result.fold((l) => null, (r) async {
      add(CheckForAnyDeviceActivityDataStoredInDbEvent());
      emit(InsertedMultipleAppUsagesState());
      final result = await fetchAppIdsUseCase();
      await result.fold((l) => null, (r) async {
        emit(AppIdsFetchedState());
        appUsages =
            appUsages.where((element) => !r.contains(element.appId)).toList();
        final result = await afterUsageInsertedUseCase(appUsages: appUsages);
        await result.fold((l) => null, (r) async {
          emit(AfterUsageInsertedState());
        });
      });
    });
  }

  FutureOr<void> insertBrowsedProductEvent(
      InsertBrowsedProductEvent event, Emitter<SettingsPageState> emit) async {
    emit(InsertingBrowsedProductState());

    final result =
        await insertBrowsedProductUseCase(product: event.browsedProduct);
    await result.fold((l) => null, (r) async {
      if (navigatorKey.currentState != null) {
        navigatorKey.currentState!.pop();
        ScaffoldMessenger.of(navigatorKey.currentState!.context).showSnackBar(
            const SnackBar(
                content: Text("Product added to Browsing Card successfully!")));
      }
      emit(InsertedBrowsedProductState());
    });
  }

  FutureOr<void> initiateLoginInExtensionWithHushhQrEvent(
      InitiateLoginInExtensionWithHushhQrEvent event,
      Emitter<SettingsPageState> emit) async {
    emit(CheckingIfUserInitiatedLoginState());
    final result = await initiateLoginInExtensionWithHushhQr(code: event.code);
    await result.fold((l) => null, (r) async {
      if (r) {
        emit(UserInitiatedLoginFlowState());
        final result = await linkHushhIdWithExtensionUseCase(
            code: event.code, hushhId: AppLocalStorage.hushhId!);
        await result.fold((l) => null, (r) async {

        });
      } else {
        emit(UserHaventInitiatedLoginFlowState());
      }
    });
  }
}
