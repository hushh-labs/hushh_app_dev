import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/agent.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/user.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/fetch_agents_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/fetch_user_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/update_agent_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/update_user_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/models/card_purchased_by_agent.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/fetch_attached_cards_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/fetch_customers_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/fetch_user_installed_card_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/insert_card_purchased_by_agent_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/update_user_installed_card_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_question_answer_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/customer_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/user_request.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/fetch_brand_info_from_domain_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/card_wallet_info/card_wallet_info.dart';
import 'package:hushh_app/app/platforms/mobile/chat/presentation/bloc/chat_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/models/payment_model.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:toastification/toastification.dart';
import 'package:tuple/tuple.dart';

part 'events.dart';

part 'states.dart';

class AgentCardWalletPageBloc
    extends Bloc<AgentCardWalletPageEvent, AgentCardWalletPageState> {
  final FetchBrandInfoFromDomainUseCase fetchBrandInfoFromDomainUseCase;
  final FetchUserUseCase fetchUserUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final FetchUserInstalledCardsUseCase fetchUserInstalledCardsUseCase;
  final UpdateUserInstalledCardUseCase updateUserInstalledCardUseCase;
  final InsertCardPurchasedByAgentUseCase insertCardPurchasedByAgentUseCase;
  final FetchCustomersUseCase fetchCustomersUseCase;
  final UpdateAgentUseCase updateAgentUseCase;
  final FetchAttachedCardsUseCase fetchAttachedCardsUseCase;
  final FetchAgentsUseCase fetchAgentUseCase;

  AgentCardWalletPageBloc(
      this.fetchBrandInfoFromDomainUseCase,
      this.fetchUserUseCase,
      this.updateUserUseCase,
      this.fetchUserInstalledCardsUseCase,
      this.updateUserInstalledCardUseCase,
      this.fetchCustomersUseCase,
      this.updateAgentUseCase,
      this.insertCardPurchasedByAgentUseCase,
      this.fetchAttachedCardsUseCase,
      this.fetchAgentUseCase)
      : super(AgentCardWalletPageInitialState()) {
    on<FetchCustomersEvent>(fetchCustomersEvent);
    on<FetchAgentCardEvent>(fetchAgentCardEvent);
    on<FetchCardInfoEvent>(fetchCardInfoEvent);
    on<OnSuccessCardUnlockEvent>(onSuccessCardUnlockEvent);
    on<OnAttachingCardsEvent>(onAttachingCardsEvent);
    on<ContactAgentEvent>(contactAgentEvent);
    on<FetchAttachedCardsEvent>(fetchAttachedCardsEvent);
    on<FetchAgentToUpdateLocalAgentEvent>(fetchAgentToUpdateLocalAgentEvent);
  }

  late TabController tabController;
  int tabIndex = 0;
  late GlobalKey cardKey;
  late TabController dashboardTabController;
  late TabController profileTabController;

  // Currency? currency;

  String fieldKey = 'hushh_id_card_questions';

  AgentModel? get agent => sl<CardWalletPageBloc>().isAgent
      ? AppLocalStorage.agent
      : sl<CardWalletPageBloc>().selectedAgent;

  final List<Tuple2<String, String>> trends = [
    const Tuple2(
        "https://s3-alpha-sig.figma.com/img/978e/cb97/460128e5765fa0be8a070e109d10a5ec?Expires=1711929600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=JT2vOCsxubrOvUL624suVNyVortB1ur0SJjyzU2wtMj6ynKRGL8OH-5vPKeLITcvchmxQwtVk9krDXvv6Ttx3BKpQldYi2P1Ro82lIs-kgXl-gavTi1BrrUMoidHLrOM6KawkQbLiX623~QPV1GCcE-m1wPmeHRhe50kirvZLZZ2poIYcK3-D2drdidWumdNb9xDsnBLn0U9rCnKcbvhriQWHl~33aRN94QXoSLUJ0RatVtnUp~fqnES~Q6o78ftfvB4IJYFcbAmHYigaJxKz-roXURzzQ1g5O1lSi-HTyRBQ386uH9qLymScFCDfRFTgNTISmRn34X0X2wdcdC6jA__",
        "Dresses"),
    const Tuple2(
        "https://s3-alpha-sig.figma.com/img/a9b6/02f8/9f48bbbd5ebeb2aaf06bc4669601963b?Expires=1711929600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=HhDQrfEdDqXPIoXASt3c9T6LPhpPm3z26kOfcRhlTzGrwMvCf8lBWQ24K4D63A0QRmMvlrymjgdCqC77X1WcNH8ahv735NsUGqUHPXvPIfCEj2EfCKXBNa~4DrceFyClCVDe16glLF~WxlQ-RmLxFzdil5z4gVDCWYsgi5x0-OBEWqflaWweFErJ3yI20mCCR4tZT9OoFhdwAhTvfXl4nvnyLfUCdTlJ1p6y0hX6fAtNT0JBUWWpMwALtHKqmbh1~eVMBEQlGcGPUji4pTwMWoVBtfcZImR96AaQOJ7PfTxPGwrhnZ3nf-ltwyoHuA9AGnPO1oO8t2aXGESOTnb7Bw__",
        "Coats"),
  ];

  List<CustomerModel>? customers;

  final List<Tuple2<String, String>> userPreferences = [
    const Tuple2("assets/standard_icon.png", "Standard"),
    const Tuple2("assets/brands_icon.png", "Brands"),
    const Tuple2("assets/fit_icon.png", "Fit"),
    const Tuple2("assets/budget_icon.png", "Budget"),
  ];

  List<CardModel>? attachedCards;

  Future<UserModel?> getUser(String uid) async {
    final result = await fetchUserUseCase(uid: uid);
    if (result.isRight()) {
      return result.getOrElse(() => null);
    }
    return null;
  }

  // Future updateLocation() async {
  //   if (AppLocalStorage.agent!.agentRecentLat == null ||
  //       AppLocalStorage.agent!.agentRecentLong == null) return;
  //   try {
  //     List<Placemark> placemarks = await placemarkFromCoordinates(
  //         AppLocalStorage.agent!.agentRecentLat!,
  //         AppLocalStorage.agent!.agentRecentLong!);
  //     if (placemarks.first.isoCountryCode?.isNotEmpty ?? false) {
  //       currency = Utils.getCurrencyFromCurrencySymbol(
  //           isoToCurrencyMap[placemarks.first.isoCountryCode]);
  //     } else {
  //       currency = defaultCurrency;
  //     }
  //   } catch (_) {}
  // }

  Future<void> onEditablePromptUpdated(List<CardQuestionAnswerModel> prompts,
      String value, String promptId, BuildContext context) async {
    log('🎯 [GENERAL_PREFERENCE] Starting field update process');
    log('📝 [GENERAL_PREFERENCE] Field ID: $promptId');
    log('💭 [GENERAL_PREFERENCE] New Value: "$value"');
    log('👤 [GENERAL_PREFERENCE] User: ${AppLocalStorage.hushhId}');
    log('🔑 [GENERAL_PREFERENCE] Field Key: $fieldKey');
    
    emit(LoadingState());
    
    Map<String, dynamic>? payload = {
      'name': {'name': value},
      'phone': {'phoneNumber': value},
      'work_email': {'email': value},
      'social_media': null,
      'website': null,
      'dob': {'dob': value},
      'gender': {'gender': value},
      'email': {'email': value},
      'education': null,
      'income': null,
      'blood_type': null,
    }[promptId];
    
    log('📊 [GENERAL_PREFERENCE] Payload for update: $payload');
    
    // Check if this is a tracked preference type for timestamp updates
    String? timestampField;
    if (promptId == 'dob') {
      timestampField = 'dob_updated_at';
      log('🎂 [GENERAL_PREFERENCE] DOB field detected - will update timestamp');
    } else {
      log('❓ [GENERAL_PREFERENCE] Field type not tracked for timestamps: $promptId');
    }
    
    // Add timestamp to payload if this is a tracked field
    if (timestampField != null && payload != null) {
      final now = DateTime.now().toIso8601String();
      payload[timestampField] = now;
      log('⏰ [GENERAL_PREFERENCE] Added timestamp to payload: $timestampField = $now');
    }
    
    try {
      if (fieldKey == 'hushh_id_card_questions') {
        log('🆔 [GENERAL_PREFERENCE] Updating Hushh ID card questions');
        AppLocalStorage.updateUser(
            AppLocalStorage.user!.copyWith(hushhIdCardQuestions: prompts));
      } else {
        log('📋 [GENERAL_PREFERENCE] Updating demographic card questions');
        AppLocalStorage.updateUser(
            AppLocalStorage.user!.copyWith(demographicCardQuestions: prompts));
      }
      
      log('💾 [GENERAL_PREFERENCE] Updating user data in local storage');
      AppLocalStorage.updateUser(AppLocalStorage.user!.copyWithFromJson(payload));
      
      log('🚀 [GENERAL_PREFERENCE] Sending update to backend...');
      await updateUserUseCase(
              uid: AppLocalStorage.hushhId!, user: AppLocalStorage.user!)
          .then((value) {
        log('✅ [GENERAL_PREFERENCE] Backend update successful!');
        if (timestampField != null) {
          log('🎉 [GENERAL_PREFERENCE] Timestamp successfully updated for $promptId');
        }
        ToastManager(
                Toast(title: 'User info updated!', type: ToastificationType.info))
            .show(context);
      });
      
      log('🏁 [GENERAL_PREFERENCE] Field update process completed successfully!');
    } catch (e) {
      log('❌ [GENERAL_PREFERENCE] Error during update process: $e');
      rethrow;
    }
    
    emit(DoneState());
  }

  Future<List<CardQuestionAnswerModel>> getEditablePrompts(
      bool isDemographicCard) async {
    Completer<List<CardQuestionAnswerModel>> completer = Completer();
    if (isDemographicCard) {
      fieldKey = 'demographic_card_questions';
    } else {
      fieldKey = 'hushh_id_card_questions';
    }

    if (AppLocalStorage.user!.toJson().containsKey(fieldKey) &&
        AppLocalStorage.user!.toJson()[fieldKey] != null) {
      List<CardQuestionAnswerModel> prompts =
          AppLocalStorage.user!.toJson()[fieldKey];
      completer.complete(prompts);
    } else {
      List<Map<String, dynamic>> defaultQuestions = isDemographicCard
          ? defaultDemographicCardQuestions(AppLocalStorage.user!.toJson())
          : defaultHushhIdCardQuestions(AppLocalStorage.user!.toJson());
      if (fieldKey == 'hushh_id_card_questions') {
        AppLocalStorage.updateUser(AppLocalStorage.user!.copyWith(
            hushhIdCardQuestions: defaultQuestions
                .map((e) => CardQuestionAnswerModel.fromJson(e))
                .toList()));
      } else {
        AppLocalStorage.updateUser(AppLocalStorage.user!.copyWith(
            demographicCardQuestions: defaultQuestions
                .map((e) => CardQuestionAnswerModel.fromJson(e))
                .toList()));
      }
      updateUserUseCase(
              uid: AppLocalStorage.hushhId!, user: AppLocalStorage.user!)
          .then((value) {
        completer.complete(defaultQuestions
            .map((e) => CardQuestionAnswerModel.fromJson(e))
            .toList());
      });
    }
    return completer.future;
  }

  FutureOr<void> fetchCustomersEvent(
      FetchCustomersEvent event, Emitter<AgentCardWalletPageState> emit) async {
    if(AppLocalStorage.hushhId == null) {
      return;
    }
    emit(FetchingCustomersState());
    final result =
        await fetchCustomersUseCase(agentId: AppLocalStorage.hushhId!);
    result.fold((l) => null, (r) async {
      print("fetched customers::${r.map((e) => e.user?.name).toList()}");
      customers = r;
      emit(FetchedCustomersState());
    });
  }

  FutureOr<void> fetchAgentCardEvent(
      FetchAgentCardEvent event, Emitter<AgentCardWalletPageState> emit) async {
    sl<HomePageBloc>().updateLocation();
    emit(FetchedBrandInfoState());
    add(FetchCustomersEvent());
  }

  FutureOr<void> fetchCardInfoEvent(
      FetchCardInfoEvent event, Emitter<AgentCardWalletPageState> emit) async {
    int cardId = event.cardId;
    String userId = event.userUid;
    final result =
        await fetchUserInstalledCardsUseCase(cardId: cardId, userId: userId);

    result.fold((l) {}, (r) async {
      if (r.isNotEmpty) {
        final brand = r.first;
        final result = await fetchUserUseCase(uid: userId);
        await result.fold((l) => null, (user) async {
          final customer = CustomerModel(user: user!, brand: brand);
          final args = CardWalletInfoPageArgs(
              cardData: brand,
              customer: customer,
              userRequest: event.query != null
                  ? UserRequest(userId, brand.id!, event.query!)
                  : null);
          if (event.replace) {
            Navigator.pushReplacementNamed(
                event.context, AppRoutes.cardWallet.info.main,
                arguments: args);
          } else {
            Navigator.pushNamed(event.context, AppRoutes.cardWallet.info.main,
                arguments: args);
          }
        });
      }
    });
  }

  stripeCreatePaymentIntent(double amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': (amount * 100).toInt().toString(),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${Constants.StripeSecretKeyTest}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  FutureOr<void> onSuccessCardUnlockEvent(OnSuccessCardUnlockEvent event,
      Emitter<AgentCardWalletPageState> emit) async {
    if (kIsWeb) {
      ToastManager(Toast(
              title: 'Transaction success!',
              notification: CustomNotification(
                title: 'Payment successful!',
                description:
                    '${event.customer?.user.name}\'s card details purchased',
              ),
              type: ToastificationType.success))
          .show(event.context);
      Navigator.pop(event.context);
      Navigator.pushReplacementNamed(
          event.context, AppRoutes.cardWallet.info.main,
          arguments: CardWalletInfoPageArgs(
              cardData: event.cardData!,
              customer: event.customer,
              overrideAccess: true));
      return;
    }
    CardModel? cardData = event.cardData;
    if (cardData == null &&
        event.cardInfoUnlockMethod == CardInfoUnlockMethod.byUser) {
      // fetch card
      final result = await fetchUserInstalledCardsUseCase(
          cardInstalledId: event.payment!.sharedCardId!);
      result.fold((l) => throw Exception("Error occurred while fetching card"),
          (r) {
        if (r.isEmpty) {
          throw Exception("Error occurred while fetching card. Empty list");
        }
        cardData = r.first;
      });
    } else if (cardData == null &&
        event.cardInfoUnlockMethod == CardInfoUnlockMethod.byAgent) {
      throw Exception(
          'Pass cardData to OnSuccessCardUnlockEvent from the Agent App');
    }

    List<String> accessAgents = cardData!.accessList ?? [];
    accessAgents.add(AppLocalStorage.hushhId!);
    DateTime paymentTime = DateTime.now();
    final cardPurchasedByAgent = CardPurchasedByAgent(
        agentId: event.cardInfoUnlockMethod == CardInfoUnlockMethod.byUser
            ? event.payment!.initiatedUuid!
            : AppLocalStorage.hushhId!,
        cardId: cardData!.cid!,
        createdAt: paymentTime);
    insertCardPurchasedByAgentUseCase(
            cardPurchasedByAgent: cardPurchasedByAgent)
        .then((value) {
      if (event.cardInfoUnlockMethod == CardInfoUnlockMethod.byAgent) {
        sl<AgentCardWalletPageBloc>()
            .customers
            ?.firstWhere((element) => element.brand.cid == element.brand.cid)
            .brand
            .accessList = accessAgents;
        cardData!.accessList = accessAgents;
      }
      if (event.customer != null) {
        add(FetchAgentCardEvent());
        ToastManager(Toast(
                title: 'Transaction success!',
                notification: CustomNotification(
                  title: 'Payment successful!',
                  description:
                      '${event.customer!.user.name}\'s card details purchased',
                ),
                type: ToastificationType.success))
            .show(event.context);
        Navigator.pop(event.context);
        Navigator.pushNamed(event.context, AppRoutes.cardWallet.info.main,
            arguments: CardWalletInfoPageArgs(
                cardData: cardData!, customer: event.customer));
      }
    });
  }

  FutureOr<void> onAttachingCardsEvent(OnAttachingCardsEvent event,
      Emitter<AgentCardWalletPageState> emit) async {
    bool isBrandCard = event.isBrandCard;
    CardModel cardData = event.cardData;
    List<CardModel> selectedCards = event.selectedCards;
    emit(LoadingState());
    if (isBrandCard) {
      cardData.attachedCardIds =
          selectedCards.map((e) => e.cid.toString()).toList();
    } else {
      cardData.attachedPrefCardIds =
          selectedCards.map((e) => e.cid.toString()).toList();
    }
    int incrementCoinsCount = (isBrandCard
            ? sl<CardWalletPageBloc>().brandCardList
            : sl<CardWalletPageBloc>().preferenceCards)
        .map((element) => (isBrandCard
                    ? cardData.attachedCardIds ?? []
                    : cardData.attachedPrefCardIds ?? [])
                .contains(element.cid.toString())
            ? (int.tryParse(element.coins ?? '') ?? 0)
            : 0)
        .fold(0, (previousValue, element) => previousValue + element);
    if (isBrandCard) {
      cardData.attachedBrandCardsCoins = incrementCoinsCount.toString();
    } else {
      cardData.attachedPrefCardsCoins = incrementCoinsCount.toString();
    }

    emit(DoneState());

    log("cardData: ${cardData.toJson()}");

    updateUserInstalledCardUseCase(card: cardData).then((value) {
      value.fold(
          (l) => ToastManager(Toast(
                title: 'Some error occurred',
                type: ToastificationType.error,
              )).show(event.context),
          (r) =>
              ToastManager(Toast(title: 'Cards updated')).show(event.context));
    });
  }

  FutureOr<void> contactAgentEvent(
      ContactAgentEvent event, Emitter<AgentCardWalletPageState> emit) async {
    emit(LoadingState());

    final data = await sl<ChatPageBloc>().initiateChat(InitiateChatEvent(
      event.context,
      null,
      sl<CardWalletPageBloc>().selectedAgent!.hushhId!,
    ));

    data.fold((l) => null, (data) async {
      sl<ChatPageBloc>().updateChatsInRealtime();
      Navigator.pushNamed(event.context, AppRoutes.chat.main, arguments: data);
    });
  }

  void updateCoins(int coins) async {
    emit(LoadingState());
    final agent = AppLocalStorage.agent!.copyWith(
        agentCoins: ((AppLocalStorage.agent?.agentCoins ?? 0) + coins).toInt());
    AppLocalStorage.updateAgent(agent);
    await updateAgentUseCase(agent: agent);
    emit(DoneState());
  }

  void updateStatus(AgentApprovalStatus status) async {
    emit(LoadingState());
    final agent = AppLocalStorage.agent!.copyWith(agentApprovalStatus: status);
    AppLocalStorage.updateAgent(agent);
    await updateAgentUseCase(agent: agent);
    emit(DoneState());
  }

  FutureOr<void> fetchAttachedCardsEvent(FetchAttachedCardsEvent event,
      Emitter<AgentCardWalletPageState> emit) async {
    emit(FetchingAttachedCardsState());
    final result = await fetchAttachedCardsUseCase(cid: event.cid!);
    result.fold((l) => null, (r) async {
      attachedCards = r;
      emit(FetchedAttachedCardsState());
    });
  }

  FutureOr<void> fetchAgentToUpdateLocalAgentEvent(
      FetchAgentToUpdateLocalAgentEvent event,
      Emitter<AgentCardWalletPageState> emit) async {
    emit(FetchingAgentState());

    final result = await fetchAgentUseCase(uid: AppLocalStorage.hushhId);
    result.fold((l) => null, (r) {
      final agent = r.firstOrNull;
      if (agent != null) {
        AppLocalStorage.updateAgent(agent);
      }
      emit(AgentFetchedState());
    });
  }
}
