import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hushh_app/currency_converter/currency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:fuzzywuzzy/model/extracted_result.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/agent.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/fetch_agents_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/agent_sign_up_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/delete_user_installed_card_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/fetch_brands_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/fetch_card_market_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/fetch_card_questions_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/generate_plaid_token_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/insert_brand_locations_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/insert_card_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/insert_user_installed_card_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/update_user_installed_card_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_product.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/brand.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/brand_location.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_question.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/user_preference.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/card_wallet_info/card_wallet_info.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:hushh_app/app/shared/core/utils/utils_impl.dart';
import 'package:toastification/toastification.dart';

part 'events.dart';

part 'states.dart';

class CardMarketBloc extends Bloc<CardMarketEvent, CardMarketState> {
  final GeneratePlaidTokenUseCase generatePlaidTokenUseCase;
  final FetchAgentsUseCase fetchAgentsUseCase;

  // final FetchAgentProductsUseCase fetchAgentProductsUseCase;
  final DeleteUserInstalledCardsUseCase deleteUserInstalledCardsUseCase;
  final InsertUserInstalledCardUseCase insertUserInstalledCardsUseCase;
  final InsertCardUseCase insertCardUseCase;
  final UpdateUserInstalledCardUseCase updateUserInstalledCard;
  final FetchCardMarketUseCase fetchCardMarketUseCase;
  final FetchCardQuestionsUseCase fetchCardQuestionsUseCase;
  final FetchBrandsUseCase fetchBrandsUseCase;
  final InsertBrandLocationsUseCase insertBrandLocationsUseCase;

  CardMarketBloc(
    this.generatePlaidTokenUseCase,
    this.fetchAgentsUseCase,
    // this.fetchAgentProductsUseCase,
    this.deleteUserInstalledCardsUseCase,
    this.insertUserInstalledCardsUseCase,
    this.updateUserInstalledCard,
    this.fetchCardMarketUseCase,
    this.fetchCardQuestionsUseCase,
    this.fetchBrandsUseCase,
    this.insertBrandLocationsUseCase,
    this.insertCardUseCase,
  ) : super(CardMarketInitialState()) {
    on<FetchAgentsEvent>(fetchAgentsEvent);
    on<SearchAgentsEvent>(searchAgentsEvent);
    on<DeleteCardEvent>(deleteCardEvent);
    on<InsertCardInUserInstalledCardsEvent>(
        insertCardInUserInstalledCardsEvent);
    on<UpdateMinimumBidValueEvent>(updateMinimumBidValueEvent);
    on<UpdateAnswersEvent>(updateAnswersEvent);
    on<FetchCardMarketEvent>(fetchCardMarketEvent);
    on<SearchCardInCardMarketEvent>(searchCardInCardMarketEvent);
    on<FetchCardQuestionsEvent>(fetchCardQuestionsEvent);
    on<FetchBrandsEvent>(fetchBrandsEvent);
    on<InsertBrandLocationsEvent>(insertBrandLocationsEvent);
    on<InsertCardEvent>(insertCardEvent);
    on<ToggleCardQuestionAnswerSelectionEvent>(
        toggleCardQuestionAnswerSelectionEvent);
  }

  // card market
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  List<CardModel> searchListCards = [];

  // List<CardModel>? receiptRadarCardsToInstall;
  // List<CardModel>? receiptRadarCardsToAdd;
  final _receiptRadarCardsToInstallController =
      StreamController<CardModel>.broadcast();

  Stream<CardModel> get receiptRadarCardsToInstallStream =>
      _receiptRadarCardsToInstallController.stream;

  final _receiptRadarCardsToAddController =
      StreamController<CardModel>.broadcast();

  Stream<CardModel> get receiptRadarCardsToAddStream =>
      _receiptRadarCardsToAddController.stream;
  List<CardModel>? allCards;
  List<CardModel>? brandCardData;
  List<CardModel>? generalCardData;
  List<CardModel>? featuredCard;
  List<Brand>? brands;

  // share your preference/questions
  int currentQuestionIndex = 0;
  List<UserPreference> userSelections = [];
  List<CardQuestion>? cardQuestions;

  // agent market
  List<AgentModel>? agents;
  List<AgentProductModel> allAgentsProducts = [];
  List<AgentModel> initialAgents = [];

  void updateReceiptRadarCardsToInstall(CardModel card) {
    _receiptRadarCardsToInstallController.sink.add(card);
  }

  void updateReceiptRadarCardsToAdd(CardModel card) {
    _receiptRadarCardsToAddController.sink.add(card);
  }

  FutureOr<void> fetchAgentsEvent(
      FetchAgentsEvent event, Emitter<CardMarketState> emit) async {
    emit(AgentsFetchingState());
    final result =
        await fetchAgentsUseCase(approvalStatus: AgentApprovalStatus.approved);
    await result.fold((l) {}, (r) async {
      // if (r.isNotEmpty) {
      //   agents = [];
      // }
      // for (var agent in r) {
      //   try {
      //     final result = await fetchAgentProductsUseCase(uid: agent.hushhId!);
      //     await result.fold((l) {}, (r) async {
      //       allAgentsProducts.addAll(r);
      //     });
      //     agents?.add(agent);
      //   } catch (_) {
      //     continue;
      //   }
      // }
      agents = r;
      initialAgents = r;

      emit(FetchedAgentsState());
    });
  }

  FutureOr<void> searchAgentsEvent(
      SearchAgentsEvent event, Emitter<CardMarketState> emit) {
    emit(AgentsFetchingState());
    if (event.value.trim().isEmpty) {
      agents = initialAgents;
    } else {
      List<ExtractedResult<AgentModel>> results1 = extractAllSorted<AgentModel>(
        query: event.value,
        choices: initialAgents,
        getter: (x) => x.agentDesc!,
      );
      List<ExtractedResult<AgentModel>> results2 = extractAllSorted<AgentModel>(
        query: event.value,
        choices: initialAgents,
        getter: (x) => x.agentName!,
      );
      List<ExtractedResult<AgentProductModel>> productResults1 =
          extractAllSorted<AgentProductModel>(
        query: event.value,
        choices: allAgentsProducts,
        getter: (x) => x.productName,
      );

      List<ExtractedResult<AgentProductModel>> productResults2 =
          extractAllSorted<AgentProductModel>(
        query: event.value,
        choices: allAgentsProducts,
        getter: (x) => x.productDescription,
      );

      List<ExtractedResult<dynamic>> mergedResults = [
        ...results1,
        ...results2,
        ...productResults1,
        ...productResults2
      ];
      mergedResults.sort((a, b) => b.score.compareTo(a.score));

      Map<String, ExtractedResult<dynamic>> resultMap = {};
      String? id;
      for (var result in mergedResults) {
        if (result.choice is AgentModel) {
          id = (result.choice as AgentModel).hushhId;
        } else {
          id = (result.choice as AgentProductModel).hushhId;
        }
        if (!resultMap.containsKey(id) || resultMap[id]!.score < result.score) {
          resultMap[id!] = result;
        }
      }

      List<ExtractedResult<dynamic>> uniqueResults = resultMap.values.toList();
      uniqueResults.sort((a, b) => b.score.compareTo(a.score));

      agents = uniqueResults.map((e) {
        if (e.choice is AgentModel) {
          return e.choice as AgentModel;
        } else {
          return agents!
              .where((agent) =>
                  agent.hushhId == (e.choice as AgentProductModel).hushhId)
              .first;
        }
      }).toList();
    }
    emit(FetchedAgentsState());
  }

  FutureOr<void> deleteCardEvent(
      DeleteCardEvent event, Emitter<CardMarketState> emit) async {
    emit(DeletingCardState());
    await deleteUserInstalledCardsUseCase(
      userId: AppLocalStorage.hushhId,
      cardId: event.cardId,
    );
    emit(CardDeletedState());
  }

  FutureOr<void> insertCardInUserInstalledCardsEvent(
      InsertCardInUserInstalledCardsEvent event,
      Emitter<CardMarketState> emit) async {
    emit(InsertingCardState());
    await insertUserInstalledCardsUseCase(card: event.card).then((value) {
      value.fold((l) => null, (r) {
        sl<CardWalletPageBloc>().cardData = event.card.copyWith(cid: r);
        sl<CardWalletPageBloc>().add(CardWalletInitializeEvent(event.context,
            refresh: true, reload: true));
        sl<CardWalletPageBloc>()
            .addCoins(int.tryParse(event.card.coins ?? "0") ?? 0);
        Navigator.pushNamedAndRemoveUntil(event.context,
            AppRoutes.cardWallet.info.main, ModalRoute.withName(AppRoutes.home),
            arguments: CardWalletInfoPageArgs(
              cardData: event.card.copyWith(cid: r),
              toast: Toast(
                  title: 'Card added successfully!',
                  notification: CustomNotification(
                    title: 'Card added successfully!',
                    description:
                        'Your ${event.card.brandName} card is added to the wallet.',
                    route: '/NewWallet?cardId=${event.card.id}',
                  ),
                  type: ToastificationType.success),
            ));
        emit(CardInsertedState());
      });
    });
  }

  FutureOr<void> updateAnswersEvent(
      UpdateAnswersEvent event, Emitter<CardMarketState> emit) async {
    emit(UpdatingAnswersState());
    final data = event.cardData.brandPreferences[event.index];
    data.answers = event.answers;
    sl<CardWalletPageBloc>().cardData?.brandPreferences[event.index] = data;
    final result = await updateUserInstalledCard(card: event.cardData);
    result.fold((l) {}, (r) {
      emit(AnswerUpdatedSuccessfullyState());
      ToastManager(Toast(
              title: "Preference updated successfully!",
              type: ToastificationType.success))
          .show(event.context);
    });

    Navigator.pop(event.context);
  }

  FutureOr<void> updateMinimumBidValueEvent(
      UpdateMinimumBidValueEvent event, Emitter<CardMarketState> emit) async {
    if (event.bidValue.isEmpty) {
      ToastManager(Toast(
              title: "Invalid value provided", type: ToastificationType.error))
          .show(event.context);
      return;
    }
    emit(UpdatingBidValueState());
    sl<CardWalletPageBloc>().cardData?.cardValue = event.bidValue;
    sl<CardWalletPageBloc>().cardData?.cardCurrency = event.currency.name;
    final result =
        await updateUserInstalledCard(card: sl<CardWalletPageBloc>().cardData!);
    result.fold((l) {
      emit(SomeErrorOccurredWhileUpdatingBidValueState());
    }, (r) {
      emit(BidValueUpdatedState());
      ToastManager(Toast(
              title: "Bid value updated successfully!",
              type: ToastificationType.success))
          .show(event.context);
    });

    Navigator.pop(event.context);
  }

  FutureOr<void> fetchCardMarketEvent(
      FetchCardMarketEvent event, Emitter<CardMarketState> emit) async {
    emit(FetchingCardMarketState());
    final result = await fetchCardMarketUseCase();
    result.fold((l) {}, (cards) {
      // cards.removeWhere((element) =>
      //     element.category == "Hushh ID Card" ||
      //     element.category == "Demographic Card");
      if (Platform.isIOS) {
        cards.removeWhere((element) => element.id == Constants.appUsageCardId);
      }
      brandCardData = cards
          .where((element) =>
              ((element.type == 1) && element.featured == 1) ||
              element.type == 3)
          .toList();
      allCards = List.from(cards);
      generalCardData =
          cards.where((element) => element.isPreferenceCard).toList();
      featuredCard = cards.where((element) => element.featured == 2).toList();

      // brandCardData!.removeWhere((element) =>
      //     element.brandName.toLowerCase() == "hushh ID card".toLowerCase());
      // featuredCard!.removeWhere((element) => element.featured != 2);
      // brandCardData!.removeWhere((element) =>
      //     element.brandName.toLowerCase() == "PII Card".toLowerCase());
      // brandCardData!.removeWhere((element) => element.featured == 2);
      // brandCardData!.removeWhere((element) => element.isPreferenceCard);
      // generalCardData!.removeWhere((element) => element.type == 1);
      // brandCardData!.removeWhere((element) => element.type == 3);
      // generalCardData!.removeWhere((element) => element.type == 3);
      emit(FetchedCardMarketState());
    });
  }

  FutureOr<void> searchCardInCardMarketEvent(
      SearchCardInCardMarketEvent event, Emitter<CardMarketState> emit) {
    emit(SearchingForCardsState());
    // searchListCards = (generalCardData!)
    searchListCards = (brandCardData! + generalCardData! + featuredCard!)
        .where((element) =>
            element.brandName.toLowerCase().contains(event.text.toLowerCase()))
        .toList();
    emit(SearchCompletedForCardsState());
  }

  FutureOr<void> fetchCardQuestionsEvent(
      FetchCardQuestionsEvent event, Emitter<CardMarketState> emit) async {
    emit(FetchingCardQuestionsState());
    userSelections = [];
    Utils().showLoader(event.context);
    final result = await fetchCardQuestionsUseCase(cardId: event.cardId);
    Navigator.pop(event.context);
    result.fold((l) => null, (r) {
      cardQuestions = r;
      for (int i = 0; i < r.length; i++) {
        userSelections.add(UserPreference(
          question: r[i].questionText,
          questionType: r[i].cardQuestionType,
          mandatory: true,
          questionId: r[i].questionId,
        ));
      }
      if (event.question != null) {
        currentQuestionIndex = cardQuestions?.indexWhere(
              (question) => question.questionText == event.question,
            ) ??
            0;
      }
      emit(CardQuestionsFetchedState(event.cardId));
    });
  }

  FutureOr<void> fetchBrandsEvent(
      FetchBrandsEvent event, Emitter<CardMarketState> emit) async {
    emit(FetchingBrandsState());
    final result = await fetchBrandsUseCase();
    result.fold((l) {}, (brands) {
      this.brands = brands;
      emit(BrandsFetchedState());
    });
  }

  FutureOr<void> insertBrandLocationsEvent(
      InsertBrandLocationsEvent event, Emitter<CardMarketState> emit) async {
    emit(InsertingBrandLocationsState());
    final result =
        await insertBrandLocationsUseCase(locations: event.locations);
    result.fold((l) {}, (brands) {
      emit(BrandLocationInsertedState());
    });
  }

  FutureOr<void> insertCardEvent(
      InsertCardEvent event, Emitter<CardMarketState> emit) async {
    emit(InsertingBrandState());
    final result = await insertCardUseCase(card: event.brandCard);
    result.fold((l) {}, (brands) {
      if (event.afterInsertingCardSignUpAgent) {
        sl<AgentSignUpPageBloc>().selectedBrand = event.brand!;
        sl<AgentSignUpPageBloc>()
            .add(AgentSignUpEvent(AppLocalStorage.user!, event.context));
      }
      emit(BrandInsertingState());
    });
  }

  FutureOr<void> toggleCardQuestionAnswerSelectionEvent(
      ToggleCardQuestionAnswerSelectionEvent event,
      Emitter<CardMarketState> emit) {
    emit(CardQuestionAnswerUpdatingState());
    final answer = event.answer;
    final questionIndex = event.questionIndex;
    if (answer.runtimeType != String) {
      if (userSelections[questionIndex].answers.contains(jsonEncode(answer)) &&
          !event.onlyAdd) {
        userSelections[questionIndex].answers.remove(jsonEncode(answer));
      } else {
        userSelections[questionIndex].answers.add(jsonEncode(answer));
      }
    } else {
      if (userSelections[questionIndex].answers.contains(answer) &&
          !event.onlyAdd) {
        userSelections[questionIndex].answers.remove(answer);
      } else {
        userSelections[questionIndex].answers.add(answer);
      }
    }
    emit(CardQuestionAnswerUpdatedState());
  }
}
