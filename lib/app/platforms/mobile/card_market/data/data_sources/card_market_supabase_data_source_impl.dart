import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/data_sources/card_market_supabase_data_source.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/models/card_purchased_by_agent.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/brand_location.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/customer_model.dart';
import 'package:hushh_app/app/shared/core/backend_controller/db_controller/db_tables.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CardMarketSupabaseDataSourceImpl extends CardMarketSupabaseDataSource {
  final supabase = Supabase.instance.client;

  @override
  Future<Map<String, dynamic>> fetchBrandProducts(int brandId) async {
    final data = await supabase.rpc('fetch_brand_inventory', params: {
      'p_brand_id': brandId,
    }).single();
    return data;
  }

  @override
  Future<List<Map<String, dynamic>>> fetchUserInstalledCards(
      String? userId, int? cardId, int? cardInstalledId) async {
    if(cardInstalledId != null) {
      return await supabase
          .from(DbTables.installedCardsTable)
          .select()
          .eq('cid', cardInstalledId);
    }
    else if (userId != null && cardId != null) {
      return await supabase
          .from(DbTables.installedCardsTable)
          .select()
          .eq('id', cardId)
          .eq('user_id', userId);
    } else {
      return await supabase
          .from(DbTables.installedCardsTable)
          .select()
          .eq(cardId != null ? 'id' : 'user_id', cardId ?? userId!);
    }
  }

  @override
  Future<void> deleteUserInstalledCards(String? userId, int? cardId) async {
    if (userId != null && cardId != null) {
      await supabase
          .from(DbTables.userInstalledCardsTable)
          .delete()
          .eq('id', cardId)
          .eq('user_id', userId);
    } else {
      await supabase
          .from(DbTables.userInstalledCardsTable)
          .delete()
          .eq(cardId != null ? 'id' : 'user_id', cardId ?? userId!);
    }
  }

  @override
  Future<int> insertUserInstalledCard(CardModel cardModel) async {
    final data = cardModel.toInsertJson();
    log(data.toString());
    return (await supabase
            .from(DbTables.userInstalledCardsTable)
            .insert(data)
            .select())
        .first['cid'];
  }

  @override
  Future<void> insertBrandLocations(List<BrandLocation> locations) async {
    // if(locations.isNotEmpty) {
    //   final data = locations[0].toJson();
    //   data.remove('location_id');
    //   data.remove('brand_name');
    //   (await supabase
    //       .from(DbTables.brandLocationsTable)
    //       .insert(data));
    // }
    (await supabase
        .from(DbTables.brandLocationsTable)
        .insert(locations.map((e) {
          var locationMap = e.toJson();
          locationMap.remove('location_id');
          locationMap.remove('brand_name');
          return locationMap;
        }).toList()));
  }

  @override
  Future<void> updateUserInstalledCard(CardModel cardModel) async {
    return await supabase
        .from(DbTables.userInstalledCardsTable)
        .update(cardModel.toInsertJson())
        .match({'cid': cardModel.cid!});
  }

  @override
  Future<List<Map<String, dynamic>>> fetchCardMarket() async {
    return await supabase
        .from(DbTables.cardMarketTable)
        .select()
        .order('brand_name', ascending: true);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchCardQuestions(int cardId) async {
    List<Map<String, dynamic>> result = await supabase
        .from(DbTables.cardMarketQuestionnaireTable)
        .select()
        .eq('card_market_id', cardId);

    return result;
  }

  @override
  Future<List<Map<String, dynamic>>> fetchBrands() async {
    List<Map<String, dynamic>> result = await supabase
        .from(DbTables.brandsView)
        .select()
        .order('created_at', ascending: false);

    return result;
  }

  @override
  Future<List<Map<String, dynamic>>> fetchCustomers(String agentId) async {
    if (AppLocalStorage.agent?.agentCard?.id == null) {
      return [];
    }
    List<Map<String, dynamic>> removeDuplicates(
        List<Map<String, dynamic>> cards) {
      final Set<int> seenCids = {};
      List<Map<String, dynamic>> uniqueCards = [];

      for (var card in cards) {
        if (seenCids.add(card['cid'])) {
          uniqueCards.add(card);
        } else {}
      }

      return uniqueCards;
    }

    List<Map<String, dynamic>> r1 = await supabase
        .from(DbTables.installedCardsTable)
        .select('*')
        .filter('access_list', 'cs', [agentId]).order('payment_time');
    List<Map<String, dynamic>> r2 = await supabase
        .from(DbTables.installedCardsTable)
        .select('*')
        .eq('id', AppLocalStorage.agent!.agentCard!.id!)
        .order('installed_time');

    List<Map<String, dynamic>> mergedList = [...r1, ...r2];

    return removeDuplicates(mergedList);
  }

  @override
  Future<void> insertCardPurchasedByAgent(
      CardPurchasedByAgent cardPurchasedByAgent) async {
    final data = cardPurchasedByAgent.toJson();
    data.remove('id');
    return await supabase
        .from(DbTables.cardsPurchasedByAgentTable)
        .insert(data);
  }

  @override
  Future<void> insertCard(CardModel card) async {
    final data = card.toJson();
    data.remove('id');
    data.remove('cid');
    data.remove('coins');
    data.remove('access_list');
    data.remove('answers');
    data.remove('name');
    data.remove('team_id');
    data.remove('user_id');
    data.remove('attached_brand_cards_coins');
    data.remove('attached_pref_cards_coins');
    data.remove('attached_card_ids');
    data.remove('attached_pref_card_ids');
    data.remove('installed_time');
    data.remove('brand_category');
    data.remove('card_value');
    data.remove('audio_transcription');
    data.remove('card_currency');
    return await supabase.from(DbTables.cardMarketInsertTable).insert(data);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchAgentsWhoPurchasedTheCard(
      int cardId) async {
    return await supabase
        .from(DbTables.cardsPurchasedByAgentTable)
        .select('*, agent: agents ( * )')
        .eq('card_id', cardId);
  }

  @override
  Stream<List<CustomerModel>> fetchCustomersAsStream(String agentId) {
    if (AppLocalStorage.agent!.agentCard?.id == null) {
      return Stream.fromIterable([]);
    }
    final stream1 = supabase
        .from(DbTables.installedCardsTable)
        .stream(primaryKey: ['cid'])
        .eq('access_list', [agentId])
        .order('payment_time')
        .map((snap) => snap.map((data) => data).toList());

    final stream2 = supabase
        .from(DbTables.installedCardsTable)
        .stream(primaryKey: ['cid'])
        .eq('id', AppLocalStorage.agent!.agentCard!.id!)
        .order('installed_time')
        .map((snap) => snap.map((data) => data).toList());

    return Rx.combineLatest2(
      stream1,
      stream2,
      (List<Map<String, dynamic>> r1, List<Map<String, dynamic>> r2) {
        List<Map<String, dynamic>> mergedList = [...r1, ...r2];
        List<Map<String, dynamic>> uniqueMergedList =
            mergedList.toSet().toList();
        return uniqueMergedList
            .map((data) => CustomerModel.fromJson(data))
            .toList();
      },
    );
  }

  @override
  Future<List<Map<String, dynamic>>> fetchAttachedCards(int cid) async {
    List<Map<String, dynamic>> cardIdsResponse = await supabase
        .from(DbTables.userInstalledCardsTable)
        .select('attached_card_ids, attached_pref_card_ids')
        .eq('cid', cid);
    if (cardIdsResponse.isNotEmpty) {
      List<String> attachedBrandCardIds =
          List<String>.from(cardIdsResponse.firstOrNull?['attached_card_ids'] ?? []);
      List<String> attachedPrefCardIds =
          List<String>.from(cardIdsResponse.firstOrNull?['attached_pref_card_ids'] ?? []);
      List<int> mergedCardIds = (attachedBrandCardIds + attachedPrefCardIds)
          .toSet()
          .map((e) => int.parse(e))
          .toList();
      cardIdsResponse = await supabase
          .from(DbTables.installedCardsTable)
          .select()
          .inFilter('cid', mergedCardIds);
      return cardIdsResponse;
    }
    return [];
  }

  @override
  Future<List<Map<String, dynamic>>> fetchInsuranceDetails(
      CardModel? card) async {
    final url =
        'https://omkar008-insurance-analytics.hf.space/insurance_data?hushh_id=${card?.userId ?? AppLocalStorage.hushhId}';
    final response = await sl<Dio>().getUri(Uri.parse(url));
    final res = Map<String, List<dynamic>>.from(response.data);
    List<Map<String, dynamic>> data = [];
    res.forEach((key, value) {
      for (var element in value) {
        final json = Map<String, dynamic>.from(element);
        json['insurance_type'] = key;
        data.add(json);
      }
    });
    return data;
  }

  @override
  Future<Map<String, dynamic>?> fetchTravelDetails(CardModel card) async {
    final url =
        'https://omkar008-travel-analytics.hf.space/get_travel_data?hushh_id=${card.userId!}';
    final response = await sl<Dio>().getUri(Uri.parse(url));
    final res = Map<String, dynamic>.from(response.data);
    if(res.isEmpty) return null;
    return res;
  }

  @override
  Future<List<Map<String, dynamic>>> fetchPurchasedItems(String userId) async {
    final data = await supabase
        .rpc('fetch_purchased_items', params: {'_user_id': userId}).select();
    return data;
  }
}
