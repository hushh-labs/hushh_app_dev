import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/fetch_agents_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/data/models/nearby_found_brand.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/domain/usecases/create_new_task_as_user_for_agent_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/domain/usecases/fetch_brand_ids_from_group_id_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/domain/usecases/fetch_brand_offers_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/presentation/pages/all_stores_page.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/presentation/pages/single_store_page.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/task.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

part 'events.dart';

part 'states.dart';

class CardShareEcosystemBloc
    extends Bloc<CardShareEcosystemEvent, CardShareEcosystemState> {
  final FetchBrandOffersUseCase fetchBrandOffersUseCase;
  final FetchBrandIdsFromGroupIdUseCase fetchBrandIdsFromGroupIdUseCase;
  final CreateNewTaskAsUserForAgentUseCase createNewTaskAsUserForAgentUseCase;
  final FetchAgentsUseCase fetchAgentsUseCase;

  CardShareEcosystemBloc(
    this.fetchBrandOffersUseCase,
    this.fetchBrandIdsFromGroupIdUseCase,
    this.createNewTaskAsUserForAgentUseCase,
    this.fetchAgentsUseCase,
  ) : super(CardShareEcosystemInitialState()) {
    on<FetchBrandOfferEvent>(fetchBrandOfferEvent);
    on<FetchAllNearbyBrandsOfferEvent>(fetchAllNearbyBrandsOfferEvent);
    on<FetchBrandIdsFromGroupIdEvent>(fetchBrandIdsFromGroupIdEvent);
    on<CreateNewTaskAsUserForAgentEvent>(createNewTaskAsUserForAgentEvent);
  }

  List<NearbyFoundBrandOffers>? allNearbyBrandOffers;
  List<int>? brandIds;

  FutureOr<void> fetchBrandOfferEvent(
      FetchBrandOfferEvent event, Emitter<CardShareEcosystemState> emit) async {
    emit(FetchingBrandOffersState());
    final result = await fetchBrandOffersUseCase(brandIds: [event.brandId]);
    result.fold((l) {}, (offers) {
      if (offers.isNotEmpty) {
        Navigator.push(
            event.context,
            MaterialPageRoute(
                builder: (context) => SingleStorePage(
                      brandOffer: offers.first,
                    )));
      }
      emit(BrandOffersFetchedState());
    });
  }

  FutureOr<void> fetchAllNearbyBrandsOfferEvent(
      FetchAllNearbyBrandsOfferEvent event,
      Emitter<CardShareEcosystemState> emit) async {
    emit(FetchingAllNearbyBrandsOffersState());
    final result = await fetchBrandOffersUseCase(brandIds: event.brandIds);
    result.fold((l) {}, (offers) {
      allNearbyBrandOffers = offers;
      final currentState = navigatorKey.currentState;
      Navigator.pop(currentState!.context);
      Navigator.push(
          currentState.context,
          MaterialPageRoute(
              builder: (context) => AllStoresPage(brands: offers)));
      emit(AllNearbyBrandsOffersFetchedState());
    });
  }

  FutureOr<void> fetchBrandIdsFromGroupIdEvent(
      FetchBrandIdsFromGroupIdEvent event,
      Emitter<CardShareEcosystemState> emit) async {
    emit(FetchingBrandIdsState());
    final result = await fetchBrandIdsFromGroupIdUseCase(gId: event.gId);
    result.fold((l) {}, (brandIds) {
      this.brandIds = brandIds;
      add(FetchAllNearbyBrandsOfferEvent(brandIds, event.context));
      emit(BrandIdsFetchedState());
    });
  }

  FutureOr<void> createNewTaskAsUserForAgentEvent(
      CreateNewTaskAsUserForAgentEvent event,
      Emitter<CardShareEcosystemState> emit) async {
    emit(NewTaskCreatingState());

    final result = await fetchAgentsUseCase(brandId: event.brandId);
    result.fold((l) => null, (r) async {
      String? text = event.query;
      for (var agent in r) {
        // String text = 'Looking for shoes';
        // await Supabase.instance.client.functions
        //     .invoke('notification-sender', body: {
        //   'userId': agent.hushhId,
        //   'notification': {
        //     'id': NotificationsConstants.INFORMING_AGENT_ABOUT_USER_REQUEST,
        //     'title': 'User interest 📣',
        //     'description': text,
        //     'route': '',
        //     'status': 'success',
        //     'notification_type': 'location',
        //     'payload': {
        //       'query': text,
        //       'cardId': agent.agentCard?.id,
        //       'userId': AppLocalStorage.hushhId
        //     },
        //   }
        // });

        final result = await createNewTaskAsUserForAgentUseCase(
            task: TaskModel(
                title: 'User request: $text',
                dateTime: DateTime.now(),
                registeredByHushhId: AppLocalStorage.hushhId!,
                desc: AppLocalStorage.user!.name,
                id: const Uuid().v4(),
                taskType: TaskType.meeting,
                cardId: event.cardId,
                isCardSharedWithService: event.cardId != null,
                hushhId: agent.hushhId!));
        result.fold((l) {}, (r) {
          // emit(NewTaskCreatedState());
        });
      }
    });
  }
}
