import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/agent.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/user.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/fetch_user_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/update_user_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/models/purchased_item.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/models/transaction_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/fetch_agents_who_purchased_the_card_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/fetch_card_market_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/fetch_insurance_details_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/fetch_purchased_items_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/fetch_travel_details_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/fetch_user_installed_card_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/insert_user_installed_card_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/update_user_installed_card_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/bloc/card_market_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/insurance_receipt.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/travel_card_insights.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/travel_insights.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/user_preference.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/fetch_shared_preferences_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/generate_audio_transcription_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/insert_shared_preference_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/update_business_card_links_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/update_business_card_name_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/user_installed_card_exists_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/health_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/share_preferences_bottom_sheet.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/bloc/receipt_radar_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/pages/receipt_radar_utils.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/bloc/settings_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/ai_handler/ai_handler.dart';
import 'package:hushh_app/app/shared/core/backend_controller/db_controller/db_controller_impl.dart';
import 'package:hushh_app/app/shared/core/backend_controller/db_controller/db_tables.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:hushh_app/app/shared/core/utils/utils_impl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

part 'events.dart';

part 'states.dart';

class CardWalletPageBloc
    extends Bloc<CardWalletPageEvent, CardWalletPageState> {
  final FetchUserInstalledCardsUseCase fetchUserInstalledCardsUseCase;
  final UpdateUserInstalledCardUseCase updateUserInstalledCardUseCase;
  final FetchUserUseCase fetchUserUseCase;
  final FetchAgentsWhoPurchasedTheCardUseCase
      fetchAgentsWhoPurchasedTheCardUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final InsertUserInstalledCardUseCase insertUserInstalledCardUseCase;
  final UserInstalledCardExistsUseCase cardExistsUseCase;
  final UpdateBusinessCardNameUseCase updateBusinessCardNameUseCase;
  final UpdateBusinessCardLinksUseCase updateBusinessCardLinksUseCase;
  final GenerateAudioTranscriptionUseCase generateAudioTranscriptionUseCase;
  final FetchInsuranceDetailsUseCase fetchInsuranceDetailsUseCase;
  final FetchTravelDetailsUseCase fetchTravelDetailsUseCase;
  final FetchCardMarketUseCase fetchCardMarketUseCase;
  final FetchPurchaseItemsUseCase fetchPurchaseItemsUseCase;
  final FetchSharedPreferencesUseCase fetchSharedPreferencesUseCase;
  final InsertSharedPreferenceUseCase insertSharedPreferenceUseCase;

  CardWalletPageBloc(
    this.fetchUserInstalledCardsUseCase,
    this.fetchUserUseCase,
    this.updateUserInstalledCardUseCase,
    this.updateUserUseCase,
    this.insertUserInstalledCardUseCase,
    this.cardExistsUseCase,
    this.fetchAgentsWhoPurchasedTheCardUseCase,
    this.updateBusinessCardNameUseCase,
    this.updateBusinessCardLinksUseCase,
    this.generateAudioTranscriptionUseCase,
    this.fetchInsuranceDetailsUseCase,
    this.fetchTravelDetailsUseCase,
    this.fetchCardMarketUseCase,
    this.fetchPurchaseItemsUseCase,
    this.fetchSharedPreferencesUseCase,
    this.insertSharedPreferenceUseCase,
  ) : super(CardWalletPageInitialState()) {
    on<CardWalletInitializeEvent>(cardWalletInitializeEvent);
    // on<FetchCardAnswersEvent>(fetchCardAnswersEvent);
    on<OnTokenUsageEvent>(onTokenUsageEvent);
    on<ResetTokenUsageEvent>(resetTokenUsageEvent);
    on<IncrementCoinEvent>(incrementCoinEvent);
    on<UpdateUserRoleEvent>(updateUserRoleEvent);
    on<FetchUpdatedAccessListEvent>(fetchUpdatedAccessListEvent);
    on<FetchAgentsWithAccessToTheCard>(fetchAgentsWithAccessToTheCard);
    on<UpdateBusinessCardNameEvent>(updateBusinessCardNameEvent);
    on<UpdateBusinessCardLinksEvent>(updateBusinessCardLinksEvent);
    on<GenerateAudioTranscriptionEvent>(generateAudioTranscriptionEvent);
    on<FetchInsuranceDetailsEvent>(fetchInsuranceDetailsEvent);
    on<FetchTravelDetailsEvent>(fetchTravelDetailsEvent);
    on<InstallCardFromMarketplaceEvent>(installCardFromMarketplaceEvent);
    on<FetchPurchasedItemsEvent>(fetchPurchasedItemsEvent);
    on<FetchSharedPreferencesEvent>(fetchSharedPreferencesEvent);
    on<AddNewPreferenceToCardEvent>(addNewPreferenceToCardEvent);
    on<OnClickingSharePreferenceButtonEvent>(onClickingSharePreferenceButtonEvent);
  }

  final PageController insurancePageController = PageController(initialPage: 0);
  final ScrollController scrollController = ScrollController();
  bool loading = true;
  int selectedShareScreenCardIndex = 0;
  List<Tuple2<CardType, CardModel>> allCards = [];
  List<CardModel> brandCardList = [];
  List<CardModel> preferenceCards = [];
  List<CardModel>? recommendedCards;
  List<TransactionModel>? transactions;
  CardModel? cardData;
  List<Contact>? foundHushhContacts;
  List<AgentModel>? agentsWithAccess;
  late GlobalKey cardKey;
  int currentBrandCardIndex = 0;
  int selectedCardWalletInfoTabIndex = 0;
  TabController? tabController;
  List recommendedCardsColors = [];
  List<InsuranceReceipt>? insuranceReceipts;
  List<PurchasedItem>? purchasedItems;
  List<UserPreference>? sharedPreferences;
  TravelCardInsights? travelCardInsights;

  TextEditingController textController = TextEditingController();
  String? lastRecordedPath;

  Duration? audioNotesDuration;
  AudioPlayer audioPlayerLoader = AudioPlayer();

  AgentModel? selectedAgent;

  List<TravelInsight>? travelInsights;

  UserModel? get user => AppLocalStorage.user;

  bool get isUser => sl<HomePageBloc>().entity == Entity.user;

  bool get isAgent => sl<HomePageBloc>().entity == Entity.agent;

  bool? get isSelectedCardPreferenceCard => cardData == null
      ? null
      : cardData!.isPreferenceCard || cardData?.type == 8;

  bool? get isSelectedCardBrandCard =>
      cardData == null ? null : cardData?.type == 1;

  Future<List<Contact>> fetchHushhUsersInContacts(context) async {
    // Function to check for contact permissions
    Future<bool> contactPermissionsGranted() async {
      Future<PermissionStatus> contactsPermissions() async {
        PermissionStatus permission = await Permission.contacts.status;
        if (permission != PermissionStatus.granted &&
            permission != PermissionStatus.permanentlyDenied) {
          PermissionStatus permissionStatus =
              await Permission.contacts.request();
          return permissionStatus;
        } else {
          return permission;
        }
      }

      PermissionStatus contactsPermissionsStatus = await contactsPermissions();
      if (contactsPermissionsStatus == PermissionStatus.granted) {
        return true;
      } else {
        ToastManager(
          Toast(
            title: 'Unable to access the contacts!',
            description: 'Please grant access from the settings.',
            type: ToastificationType.error,
          ),
        ).show(context);
        return false;
      }
    }

    final result = <Contact>[];
    if (await contactPermissionsGranted()) {
      // Fetch all phone numbers (without country codes)
      List<String> existingNumbers = await sl<DbController>().fetchAllUsers();

      // Fetch the contacts from the device
      final contacts = await ContactsService.getContacts();

      // Loop through device contacts and match them with existing numbers
      await Future.forEach(contacts, (Contact contact) async {
        final phoneNumbers = contact.phones ?? [];
        for (var phone in phoneNumbers) {
          String? phoneNumber = phone.value;

          if (phoneNumber != null && phoneNumber.trim().isNotEmpty) {
            // Clean the phone number by removing non-numeric characters
            phoneNumber = phoneNumber.phoneNumber();

            // Check if the number exists in the list of Hushh users
            if (existingNumbers.contains(phoneNumber)) {
              result.add(contact);
              break; // Stop processing further numbers for this contact
            }
          }
        }
      });
    }

    return result;
  }

  Future<void> checkForHushIdCard(context, isNewUser) async {
    final result = await cardExistsUseCase(
        id: Constants.hushhIdCardId, hushhId: AppLocalStorage.hushhId ?? '');
    await result.fold((l) => null, (exists) async {
      if (!exists) {
        CardModel hushhIdCard = CardModel(
          id: Constants.hushhIdCardId,
          brandName: "Hushh ID card",
          category: "Hushh ID Card",
          installedTime: DateTime.now(),
          name: AppLocalStorage.user!.name,
          type: 8,
          image: "",
          bodyImage:
              "https://firebasestorage.googleapis.com/v0/b/hushone-app.appspot.com/o/hushhgradient.png?alt=media&token=bea8dbbb-cb92-47ee-907e-ffdc1ef3ce21",
          logo:
              "https://firebasestorage.googleapis.com/v0/b/hushone-app.appspot.com/o/Hushh%20ID%20card.png?alt=media&token=0fc3f81a-b7cb-4526-9f9b-ffe38f1c82d8",
          cardValue: "50",
          featured: 1,
          userId: AppLocalStorage.hushhId!,
          coins: "5",
          preferences: const [],
        );
        final result = await insertUserInstalledCardUseCase(card: hushhIdCard);
        result.fold((l) => null, (r) {
          sl<CardWalletPageBloc>()
              .addCoins(int.tryParse(hushhIdCard.coins ?? "0") ?? 0);
          if (isNewUser && sl<HomePageBloc>().entity == Entity.user) {
            Navigator.pushNamed(context, AppRoutes.cardCreatedSuccessPage,
                arguments: hushhIdCard);
          } else {
            ToastManager(Toast(
                    title: 'Hushh ID Card added successfully!',
                    notification: CustomNotification(
                      title: 'Your Hushh ID card is added.',
                      description: 'Your Hushh id card is added to the wallet.',
                      route:
                          '/NewWallet?cardId=${AppLocalStorage.hushhId}&isHushhIdCard=true',
                    ),
                    type: ToastificationType.success))
                .show(context);
          }
        });
      }
    });
  }

  Future<void> checkForPIICard(context) async {
    final result = await cardExistsUseCase(
        id: Constants.personalCardId, hushhId: AppLocalStorage.hushhId ?? '');
    await result.fold((l) => null, (exists) async {
      if (!exists) {
        final piiCard = CardModel(
          id: Constants.personalCardId,
          brandName: "Personal Information",
          category: "Demographic Card",
          installedTime: DateTime.now(),
          name: AppLocalStorage.user!.name,
          accessList: const [],
          attachedCardIds: const [],
          attachedPrefCardIds: const [],
          attachedBrandCardsCoins: "0",
          attachedPrefCardsCoins: "0",
          type: 8,
          image: "",
          bodyImage:
              "https://firebasestorage.googleapis.com/v0/b/hushone-app.appspot.com/o/demograpic_body.png?alt=media&token=86c53102-c7ac-483d-bc6f-ed5eebf5718f",
          logo:
              "https://firebasestorage.googleapis.com/v0/b/hushone-app.appspot.com/o/Demographic%20card_logo.png?alt=media&token=a5eaf682-1800-456e-94b6-6ffca948b51a",
          cardValue: "50",
          featured: 1,
          userId: AppLocalStorage.hushhId!,
          coins: "5",
          preferences: const [],
        );
        final result = await insertUserInstalledCardUseCase(card: piiCard);
        result.fold((l) => null, (r) {
          sl<CardWalletPageBloc>()
              .addCoins(int.tryParse(piiCard.coins ?? "0") ?? 0);
          // ToastManager(Toast(
          //         title: 'Demographic Card added successfully!',
          //         notification: CustomNotification(
          //           title: 'Your Demographic Card is added.',
          //           description:
          //               'Your demographic card is added to the wallet.',
          //           route: '/NewWallet?cardId=${AppLocalStorage.hushhId}',
          //         ),
          //         type: ToastificationType.success))
          //     .show(context);
        });
      }
    });
  }

  Future<void> getCardRecommendations({String? uid}) async {
    final supabase = Supabase.instance.client;
    final response = await supabase.rpc('get_latest_recommended_cards',
        params: {'p_user_id': uid ?? AppLocalStorage.hushhId});
    recommendedCardsColors = [];
    recommendedCards = List<CardModel>.from(response
        .map((e) => CardModel.fromJson(e))
        .where((e) => !brandCardList.contains(e))
        .toList());
  }

  Future<void> getTravelInsights() async {
    sl<Dio>()
        .post(
            'https://omkar008-geo-location-api.hf.space/location/api/v1/get_coordinates?user_id=${AppLocalStorage.hushhId}')
        .then((value) {
      List<dynamic>? response = value.data['data'];
      if (response != null) {
        travelInsights =
            response.map((e) => TravelInsight.fromJson(e)).toList();
      }
    });
  }

  Future<Tuple2<List<CardModel>, List<CardModel>>> getInstalledCards(
      {String? uid}) async {
    bool didWeAlreadyHadBrandCards = brandCardList.isNotEmpty;
    // brandCardList = [];
    // preferenceCards = [];
    debugPrint('IN STATEM');
    final result = await fetchUserInstalledCardsUseCase(
        userId: uid ?? AppLocalStorage.hushhId);
    brandCardList = [];
    preferenceCards = [];
    result.fold((l) => debugPrint('ERROR: $l'), (r) {
      debugPrint('WORKED: $r');
      for (int i = 0; i < r.length; i++) {
        final card = r[i];
        // type 1 = brand cards
        // type 2 = general preference card from card market
        // type 8 = general preference card that are not from card market
        if (card.category == 'receipt_radar_card') {
          continue;
        }
        if (card.type != 8 && card.type != 2) {
          brandCardList.add(card);
        }
        if (card.type != 1 && card.type != 3) {
          preferenceCards.add(card);
        }
      }
      final tempBrandCards = sl<CardWalletPageBloc>()
          .brandCardList
          .map((card) => Tuple2(CardType.brandCard, card));

      final tempPreferenceCards = sl<CardWalletPageBloc>()
          .preferenceCards
          .map((card) => Tuple2(CardType.preferenceCard, card));

      allCards = [
        ...tempBrandCards,
        ...tempPreferenceCards,
      ];
      if (allCards.isNotEmpty) {
        selectedShareScreenCardIndex = (allCards.length - 1) ~/ 2;
      }
      if (!didWeAlreadyHadBrandCards) {
        tabController?.animateTo(brandCardList.isNotEmpty ? 0 : 1);
      }
    });
    return Tuple2(brandCardList, preferenceCards);
  }

  FutureOr<void> cardWalletInitializeEvent(CardWalletInitializeEvent event,
      Emitter<CardWalletPageState> emit) async {
    if (AppLocalStorage.hushhId == null) {
      return;
    }
    Future<void> getUserDetails() async {
      if (AppLocalStorage.hushhId == null) {
        return;
      }
      final result = await fetchUserUseCase(uid: AppLocalStorage.hushhId);
      result.fold((l) => null, (r) {
        if (r != null) {
          AppLocalStorage.updateUser(r);
        }
      });
    }

    sl<ReceiptRadarUtils>().fetchReceipts().then((value) {
      sl<ReceiptRadarBloc>().receipts = value;
      sl<ReceiptRadarBloc>().add(FetchCategoriesFromReceiptsEvent(value));
    });
    if (AppLocalStorage.user != null &&
        sl<HomePageBloc>().entity == Entity.user) {
      try {
        getTravelInsights();
      } catch (_) {}

      sl<HealthBloc>().add(FetchRemoteHealthDataEvent());
      sl<CardWalletPageBloc>().add(const FetchInsuranceDetailsEvent());
      sl<SettingsPageBloc>()
          .add(CheckForAnyDeviceActivityDataStoredInDbEvent());
      sl<SettingsPageBloc>().add(
          FetchBrowsedCollectionsBasedOnBrowsingBehaviourEvent(
              AppLocalStorage.hushhId!));
    }
    print("isUserr:::${sl<HomePageBloc>().entity}");
    if (event.refresh) {
      if (event.reload) {
        emit(InitializingState());
      }
      await Future.wait([
        getInstalledCards(),
        getUserDetails(),
        if (isUser) tryAndRun(() => getCardRecommendations()),
      ]);
    } else {
      emit(InitializingState());
      await Future.wait([
        getUserDetails(),
        if (isUser) getCardRecommendations(),
        checkForHushIdCard(event.context, event.signUp),
        checkForPIICard(event.context),
      ]);
      await getInstalledCards();
    }
    if (state is InitializedState) {
      emit(InitializingState());
    }
    emit(InitializedState());
    event.setState?.call(() {});
  }

  FutureOr<void> incrementCoinEvent(
      IncrementCoinEvent event, Emitter<CardWalletPageState> emit) async {
    emit(CoinsUpdatingState());
    sl<CardWalletPageBloc>().addCoins(event.length);
    cardData?.coins =
        ((int.tryParse(cardData?.coins ?? "") ?? 0) + event.length).toString();
    if (event.length != 0) {
      await updateUserInstalledCardUseCase(card: cardData!);
      emit(CoinsUpdatedState());
    }
  }

  FutureOr<void> updateUserRoleEvent(
      UpdateUserRoleEvent event, Emitter<CardWalletPageState> emit) async {
    final user = AppLocalStorage.user?.copyWith(role: event.entity);
    AppLocalStorage.updateUser(user!);
    final result = await updateUserUseCase(uid: user.hushhId!, user: user);
    result.fold((l) => null, (r) {
      clearAndReinitializeDependencies().then((value) {
        Navigator.pushNamedAndRemoveUntil(
            event.context, AppRoutes.splash, (route) => false);
      });
    });
  }

  FutureOr<void> onTokenUsageEvent(
      OnTokenUsageEvent event, Emitter<CardWalletPageState> emit) async {
    int remainingCount =
        (user!.gptTokenUsage ?? DEFAULT_GPT_TOKEN_PER_MONTH) - event.count;
    AppLocalStorage.updateUser(user!.copyWith(
        gptTokenUsage: remainingCount, lastUsedTokenDateTime: DateTime.now()));
    await updateUserUseCase(user: user!, uid: AppLocalStorage.hushhId!);
  }

  FutureOr<void> resetTokenUsageEvent(
      ResetTokenUsageEvent event, Emitter<CardWalletPageState> emit) async {
    AppLocalStorage.updateUser(
        user!.copyWith(gptTokenUsage: DEFAULT_GPT_TOKEN_PER_MONTH));
    await updateUserUseCase(user: user!, uid: AppLocalStorage.hushhId!);
  }

  void addCoins(int coins) {
    final user = AppLocalStorage.user!.copyWith(
        userCoins: ((AppLocalStorage.user?.userCoins ?? 0) + coins).toInt());
    updateUserUseCase(uid: AppLocalStorage.hushhId!, user: user).then((value) {
      AppLocalStorage.updateUser(user);
    });
  }

  FutureOr<void> fetchUpdatedAccessListEvent(FetchUpdatedAccessListEvent event,
      Emitter<CardWalletPageState> emit) async {
    emit(FetchingUpdatedAccessListState());
    final result = await fetchUserInstalledCardsUseCase(cardId: event.cardId);
    result.fold((l) => null, (r) {
      if (r.isNotEmpty) {
        emit(FetchedUpdatedAccessListState(r[0].accessList ?? []));
      }
    });
  }

  FutureOr<void> fetchAgentsWithAccessToTheCard(
      FetchAgentsWithAccessToTheCard event,
      Emitter<CardWalletPageState> emit) async {
    if (cardData?.cid == null) {
      return;
    }
    agentsWithAccess = [];
    emit(FetchingAgentsWithAccessState());
    final result =
        await fetchAgentsWhoPurchasedTheCardUseCase(cardId: cardData!.cid!);
    result.fold((l) => null, (r) {
      agentsWithAccess = r;
      emit(AgentsFetchedWithAccessState());
    });
  }

  Stream<List<TransactionModel>> getTransactionsStream() async* {
    final supabase = Supabase.instance.client;
    final stream1 = supabase
        .from(DbTables.paymentRequestsTable)
        .stream(primaryKey: ['id'])
        .eq('to_uuid', AppLocalStorage.hushhId!)
        .map((snap) => snap
          ..where((element) => element['status'] == PaymentStatus.accepted.name)
              .toList());

    final stream2 = supabase
        .from(DbTables.receiptRadarTable)
        .stream(primaryKey: ['id'])
        .eq('user_id', AppLocalStorage.hushhId!)
        .order('receipt_date', ascending: false)
        .limit(3);

    final stream = Rx.combineLatest2(
      stream1,
      stream2,
      (List<Map<String, dynamic>> r1, List<Map<String, dynamic>> r2) {
        List<Map<String, dynamic>> mergedList = [...r1, ...r2];
        mergedList.sort((a, b) {
          var dateA = DateTime.tryParse(a['amount_paid_dt'] ?? '');
          var dateB = DateTime.tryParse(b['amount_paid_dt'] ?? '');
          if (dateA == null || dateB == null) {
            return 0;
          }
          return dateB.compareTo(dateA);
        });

        mergedList.sort((a, b) {
          try {
            var dateA = DateTime.tryParse(a['receipt_date'] ?? '');
            var dateB = DateTime.tryParse(b['receipt_date'] ?? '');
            if (dateA == null || dateB == null) {
              return 0;
            }
            return dateB.compareTo(dateA);
          } catch (e) {
            print(e);
            return 0;
          }
        });

        mergedList.removeWhere((element) {
          bool isPaymentRequest = element.containsKey('amount_paid_dt');
          return isPaymentRequest && element['amount_paid_dt'] == null
              ? true
              : false;
        });

        final res = mergedList.map((data) {
          bool isPaymentRequest = data.containsKey('amount_paid_dt');
          if (isPaymentRequest) {
            return TransactionModel.fromPaymentRequestJson(data);
          } else {
            return TransactionModel.fromReceiptJson(data);
          }
        }).toList();


        return res;
      },
    ).asBroadcastStream();

    yield* stream;
  }

  FutureOr<void> updateBusinessCardNameEvent(UpdateBusinessCardNameEvent event,
      Emitter<CardWalletPageState> emit) async {
    emit(UpdatingBusinessCardNameState());
    final result = await updateBusinessCardNameUseCase(
        businessCard: event.businessCard, name: event.name);
    result.fold((l) => null, (r) {
      add(CardWalletInitializeEvent(event.context));
      emit(BusinessCardNameUpdatedState());
    });
  }

  FutureOr<void> updateBusinessCardLinksEvent(
      UpdateBusinessCardLinksEvent event,
      Emitter<CardWalletPageState> emit) async {
    emit(UpdatingBusinessCardLinksState());
    final result = await updateBusinessCardLinksUseCase(
        businessCard: event.businessCard, links: event.links);
    result.fold((l) => null, (r) {
      add(CardWalletInitializeEvent(event.context));
      emit(BusinessCardLinksUpdatedState());
    });
  }

  FutureOr<void> generateAudioTranscriptionEvent(
      GenerateAudioTranscriptionEvent event,
      Emitter<CardWalletPageState> emit) async {
    emit(GeneratingAudioTranscriptionState());
    final result =
        await generateAudioTranscriptionUseCase(audioUrl: event.card.audioUrl!);
    result.fold((l) {}, (r) async {
      final card = event.card.copyWith(audioTranscription: r);
      cardData = card;
      emit(AudioTranscriptionGeneratedState());
      await updateUserInstalledCardUseCase(card: card);
      add(CardWalletInitializeEvent(event.context));
    });
  }

  FutureOr<void> fetchInsuranceDetailsEvent(FetchInsuranceDetailsEvent event,
      Emitter<CardWalletPageState> emit) async {
    insuranceReceipts = null;
    emit(FetchingInsuranceDataState());
    final result = await fetchInsuranceDetailsUseCase(card: event.card);
    result.fold((l) {}, (r) async {
      insuranceReceipts = r;
      emit(InsuranceDataFetchedState());
    });
  }

  FutureOr<void> fetchTravelDetailsEvent(
      FetchTravelDetailsEvent event, Emitter<CardWalletPageState> emit) async {
    travelCardInsights = null;
    emit(FetchingTravelDataState());
    final result = await fetchTravelDetailsUseCase(card: event.card);
    result.fold((l) {}, (r) async {
      travelCardInsights = r;
      emit(TravelDataFetchedState());
    });
  }

  FutureOr<void> installCardFromMarketplaceEvent(
      InstallCardFromMarketplaceEvent event,
      Emitter<CardWalletPageState> emit) async {
    Utils().showLoader(event.context);
    final result = await fetchCardMarketUseCase();
    result.fold((l) {
      Navigator.pop(event.context);
    }, (r) {
      Navigator.pop(event.context);
      CardModel? card =
          r.firstWhereOrNull((element) => element.id == event.cardId);
      card = card?.copyWith(
          installedTime: DateTime.now(),
          name: AppLocalStorage.user!.name,
          cardValue: "1",
          userId: AppLocalStorage.hushhId!,
          coins: "10");
      if (card != null) {
        sl<CardMarketBloc>()
            .add(InsertCardInUserInstalledCardsEvent(card, event.context));
      }
    });
  }

  FutureOr<void> fetchPurchasedItemsEvent(
      FetchPurchasedItemsEvent event, Emitter<CardWalletPageState> emit) async {
    emit(FetchingPurchasedItemsState());
    final result =
        await fetchPurchaseItemsUseCase(userId: AppLocalStorage.hushhId!);
    result.fold((l) => null, (r) {
      purchasedItems = r;
      emit(PurchasedItemsFetchedState());
    });
  }

  FutureOr<void> fetchSharedPreferencesEvent(FetchSharedPreferencesEvent event,
      Emitter<CardWalletPageState> emit) async {
    emit(FetchingSharedPreferencesState());
    final result = await fetchSharedPreferencesUseCase(
        hushhId: event.hushhId, cardId: event.cardId);
    result.fold((l) => null, (r) {
      sharedPreferences = r;
      emit(SharedPreferencesFetchedState());
    });
  }

  FutureOr<void> addNewPreferenceToCardEvent(AddNewPreferenceToCardEvent event,
      Emitter<CardWalletPageState> emit) async {
    emit(InsertingSharedPreferenceState());
    final result = await insertSharedPreferenceUseCase(
      preference: event.preference,
      cardId: event.cardId,
      hushhId: event.hushhId,
    );
    result.fold((l) => emit(ErrorInsertingSharedPreferenceState()), (r) {
      emit(SharedPreferenceInsertedState());
      add(FetchSharedPreferencesEvent(
        hushhId: AppLocalStorage.hushhId!,
        cardId: event.cardId,
      ));
    });
  }

  FutureOr<void> onClickingSharePreferenceButtonEvent(OnClickingSharePreferenceButtonEvent event, Emitter<CardWalletPageState> emit) async {
    String text = textController.text;
    if(lastRecordedPath != null) {
      String id = const Uuid().v4();
      var extension = 'm4a';
      String path =
          "user-preference-audios/${AppLocalStorage.hushhId}/$id.$extension";

      Uint8List bytes = await File(lastRecordedPath!).readAsBytes();
      final supabase = Supabase.instance.client;
      await supabase.storage.from('audios').uploadBinary(path, bytes);
      String audioUrl = supabase.storage.from('audios').getPublicUrl(path);
      final result = await generateAudioTranscriptionUseCase(audioUrl: audioUrl);
      result.fold((l) {}, (r) async {
        text = r.text;
      });
    }
    Utils().showLoader(event.context);
    const systemPrompt =
    '''You are an intelligent assistant designed to analyze user input, extract preferences, and generate corresponding question-and-answer pairs in JSON format. Your job is to:
Identify the key preference or interest from the user's text. Frame a question that logically matches the identified preference. Return the result strictly as a JSON object.

Guidelines:
1. Always provide the output in JSON format.
2. Ensure the question is specific and directly addresses the identified preference.
3. The answer must be extracted verbatim or paraphrased accurately from the input text.
4. In question generated always refer the user as 'I' meaning first person question.

Example inputs and outputs:

Input 1:
"I love hot chocolate cocoa."
Output 1:
{"question": "Which drink does I like?", "answer": "Hot chocolate cocoa"}

Input 2:
"I enjoy hiking in the mountains during the weekends."
{"question": "What activities do I enjoy over weekends?", "answer": "Hiking in the mountains during the weekends"}

Input 3:
"My favorite color is turquoise."
Output 3:
{"question": "What is my favorite color?", "answer": "Turquoise"}

Now, process the input given by user and generate a question-answer pair in JSON format and only return the JSON:''';
    final response = await AiHandler(systemPrompt)
        .getChatResponse(text);
    Navigator.pop(event.context);
    if (response != null) {
      final parsedEvent =
      extractSingleJSONFromString(response);
      String jsonText = parsedEvent;
      final data = jsonDecode(jsonText);
      final qA = SharedPreferenceQA(
          data['question'], data['answer'], text);
      ToastManager(Toast(
          title:
          'Thanks for sharing your preference with us!',
          duration: const Duration(seconds: 5),
          description:
          'Don\'t worry, We\'ll organise the details for you...'))
          .show(event.context);
      Navigator.pop(event.context,
          SharedPreferenceQA(qA.question, qA.answer, text));
    }
  }
}
