// app/platforms/mobile/card_wallet/data/repository_impl/card_wallet_repository_impl.dart
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:health/health.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/models/audio_transcription.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/data_sources/card_wallet_page_api_source.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/data_sources/card_wallet_page_supabase_data_source_impl.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_lookbook.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_meeting.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_product.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/cached_inventory_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/inventory_configuration.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/inventory_schema_response.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/meeting_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/shared_asset.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/task.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/user_preference.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/repository/card_wallet_page_repository.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_handler.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';
import 'package:hushh_app/app/shared/core/firebase_config/firebase_remote_config_service.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';

class CardWalletPageRepositoryImpl extends CardWalletPageRepository {
  final CardWalletPageApiDataSourceImpl cardWalletPageApiDataSource;
  final CardWalletPageSupabaseDataSourceImpl cardWalletPagesSupabaseDataSource;

  CardWalletPageRepositoryImpl(
      this.cardWalletPageApiDataSource, this.cardWalletPagesSupabaseDataSource);

  @override
  Future<Either<ErrorState, CardModel?>> fetchBrandInfoFromDomain(
      String domain) async {
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var data = {'card_id': domain};
    var dio = Dio();
    var response = await dio.request(
      'https://hushhdevenv.hushh.ai/admin/v1/get_card_data',
      options: Options(
        method: 'POST',
        headers: headers,
      ),
      data: data,
    );
    return right(CardModel.fromJson(response.data['data']));
  }

  @override
  Future<Either<ErrorState, AgentMeeting?>> fetchHushhMeetInfo(
      String uid) async {
    return await ErrorHandler.callSupabase(
        () => cardWalletPagesSupabaseDataSource.fetchMeeting(uid), (value) {
      final result = value as Map<String, dynamic>?;
      return result != null ? AgentMeeting.fromJson(result) : null;
    });
  }

  @override
  Future<Either<ErrorState, void>> insertHushhMeet(AgentMeeting meeting) async {
    return await ErrorHandler.callSupabase(
        () => cardWalletPagesSupabaseDataSource.insertMeeting(meeting),
        (value) {});
  }

  @override
  Future<Either<ErrorState, void>> updateMeeting(
      AgentMeeting meeting, String? uid) async {
    return await ErrorHandler.callSupabase(
        () => cardWalletPagesSupabaseDataSource.updateMeeting(meeting, uid),
        (value) {});
  }

  @override
  Future<Either<ErrorState, List<CustomNotification>>> fetchNotifications(
      String uid) async {
    return await ErrorHandler.callSupabase(
        () => cardWalletPagesSupabaseDataSource.fetchNotifications(uid),
        (value) {
      final result = value as List<Map<String, dynamic>>;
      return result.map((e) => CustomNotification.fromJson(e)).toList();
    });
  }

  @override
  Future<Either<ErrorState, List<CustomNotification>>> fetchAgentNotifications(
      String uid) async {
    return await ErrorHandler.callSupabase(
        () => cardWalletPagesSupabaseDataSource.fetchAgentNotifications(uid),
        (value) {
      final result = value as List<Map<String, dynamic>>;
      return result.map((e) => CustomNotification.fromJson(e)).toList();
    });
  }

  @override
  Future<Either<ErrorState, List<SharedAsset>>> fetchAllAssets(
      String uid, int cardId) async {
    return await ErrorHandler.callSupabase(
        () => cardWalletPagesSupabaseDataSource.fetchAllAssets(uid, cardId),
        (value) {
      final result = value as List<Map<String, dynamic>>;
      return result.map((e) => SharedAsset.fromJson(e)).toList();
    });
  }

  @override
  Future<Either<ErrorState, void>> deleteMeet(MeetingModel meeting) async {
    return await ErrorHandler.callSupabase(
      () => cardWalletPagesSupabaseDataSource.deleteMeeting(meeting),
      (value) {},
    );
  }

  @override
  Future<Either<ErrorState, void>> deleteTask(TaskModel task) async {
    return await ErrorHandler.callSupabase(
      () => cardWalletPagesSupabaseDataSource.deleteTask(task),
      (value) {},
    );
  }

  @override
  Future<Either<ErrorState, List<MeetingModel>>> fetchMeetings(
      String uid) async {
    return await ErrorHandler.callSupabase(
      () => cardWalletPagesSupabaseDataSource.fetchMeetings(uid),
      (value) {
        final result = value as List<Map<String, dynamic>>;
        return result.map((e) => MeetingModel.fromJson(e)).toList();
      },
    );
  }

  @override
  Future<Either<ErrorState, List<TaskModel>>> fetchTasks(String uid) async {
    return await ErrorHandler.callSupabase(
      () => cardWalletPagesSupabaseDataSource.fetchTasks(uid),
      (value) {
        final result = value as List<Map<String, dynamic>>;
        return result.map((e) => TaskModel.fromJson(e)).toList();
      },
    );
  }

  @override
  Future<Either<ErrorState, void>> insertMeet(MeetingModel meeting) async {
    return await ErrorHandler.callSupabase(
      () => cardWalletPagesSupabaseDataSource.insertMeet(meeting),
      (value) {},
    );
  }

  @override
  Future<Either<ErrorState, void>> insertTask(TaskModel task) async {
    return await ErrorHandler.callSupabase(
      () => cardWalletPagesSupabaseDataSource.insertTask(task),
      (value) {},
    );
  }

  @override
  Future<Either<ErrorState, void>> deleteProduct(
      AgentProductModel product) async {
    return await ErrorHandler.callSupabase(
      () => cardWalletPagesSupabaseDataSource.deleteProduct(product),
      (value) {},
    );
  }

  @override
  Future<Either<ErrorState, List<AgentLookBook>>> fetchLookBooks(
      String uid) async {
    return await ErrorHandler.callSupabase(
      () => cardWalletPagesSupabaseDataSource.fetchLookBooks(uid),
      (value) {
        final result = value as List<Map<String, dynamic>>;
        return result.map((e) => AgentLookBook.fromJson(e)).toList();
      },
    );
  }

  @override
  Future<Either<ErrorState, void>> insertAgentProducts(
      List<AgentProductModel> products) async {
    return await ErrorHandler.callSupabase(
      () => cardWalletPagesSupabaseDataSource.insertAgentProducts(products),
      (value) {},
    );
  }

  @override
  Future<Either<ErrorState, void>> insertLookBook(
      AgentLookBook lookBook, List<AgentProductModel> products) async {
    return await ErrorHandler.callSupabase(
      () =>
          cardWalletPagesSupabaseDataSource.insertLookBook(lookBook, products),
      (value) {},
    );
  }

  @override
  Future<Either<ErrorState, void>> updateLookBookField(
      String lookbookId, Map<String, dynamic> field) async {
    return await ErrorHandler.callSupabase(
      () => cardWalletPagesSupabaseDataSource.updateLookBookField(
          lookbookId, field),
      (value) {},
    );
  }

  @override
  Future<Either<ErrorState, bool>> userInstalledCardExists(
      int id, String hushhId) async {
    return await ErrorHandler.callSupabase(
      () => cardWalletPagesSupabaseDataSource.userInstalledCardExists(
          id, hushhId),
      (value) => value as bool,
    );
  }

  @override
  Future<Either<ErrorState, SharedAsset>> insertSharedAsset(
      SharedAsset asset) async {
    return await ErrorHandler.callSupabase(
      () => cardWalletPagesSupabaseDataSource.insertSharedAsset(asset),
      (value) {
        final result = value as Map<String, dynamic>;
        return SharedAsset.fromJson(value);
      },
    );
  }

  @override
  Future<Either<ErrorState, void>> deleteSharedAsset(SharedAsset asset) async {
    return await ErrorHandler.callSupabase(
      () => cardWalletPagesSupabaseDataSource.deleteSharedAsset(asset),
      (value) {},
    );
  }

  @override
  Future<Either<ErrorState, void>> deleteLookBook(
      AgentLookBook lookBook) async {
    return await ErrorHandler.callSupabase(
      () => cardWalletPagesSupabaseDataSource.deleteLookBook(lookBook),
      (value) {},
    );
  }

  @override
  Future<Either<ErrorState, List<InventoryConfiguration>>> fetchInventories(
      int brandId) async {
    return await ErrorHandler.callSupabase(
      () => cardWalletPagesSupabaseDataSource.fetchInventories(brandId),
      (value) {
        final result = value as List<Map<String, dynamic>>;
        return result.map((e) => InventoryConfiguration.fromJson(e)).toList();
      },
    );
  }

  @override
  Future<Either<ErrorState, CachedInventoryModel?>>
      fetchProductsResultFromInventory(int brandId, int configurationId) async {
    return await ErrorHandler.callSupabase(
      () => cardWalletPagesSupabaseDataSource.fetchProductsResultFromInventory(
          brandId, configurationId),
      (value) {
        if (value == null) {
          return CachedInventoryModel(0, []);
        }
        return CachedInventoryModel.fromJson(value);
      },
    );
  }

  Future<Either<ErrorState, CachedInventoryModel>> fetchAgentProducts(
      String hushhId) async {
    return await ErrorHandler.callSupabase(
      () => cardWalletPagesSupabaseDataSource.fetchAgentProducts(hushhId),
      (value) {
        print('📊 [REPOSITORY] Raw data from Supabase: ${value.length} items');
        if (value.isNotEmpty) {
          print('📊 [REPOSITORY] First item structure: ${value.first.keys}');
          print('📊 [REPOSITORY] First item data: ${value.first}');
        }
        
        List<AgentProductModel> products = [];
        for (int i = 0; i < value.length; i++) {
          try {
            final product = AgentProductModel.fromCachedInventoryJson(value[i]);
            products.add(product);
          } catch (e) {
            print('📊 [REPOSITORY] Error parsing product $i: $e');
            print('📊 [REPOSITORY] Problematic data: ${value[i]}');
            // Continue with next product instead of failing completely
          }
        }
        
        print('📊 [REPOSITORY] Successfully parsed ${products.length} products out of ${value.length}');
        return CachedInventoryModel(products.length, products);
      },
    );
  }

  @override
  Future<Either<ErrorState, void>> insertInventory(
      dynamic payload,
      int configurationId,
      int brandId,
      InventoryServer inventorySever,
      Map<String, InventoryColumn> mappedColumns) async {
    return await ErrorHandler.callSupabase(
      () => cardWalletPagesSupabaseDataSource.insertInventory(
          payload, configurationId, brandId, inventorySever, mappedColumns),
      (value) {},
    );
  }

  @override
  Future<Either<ErrorState, void>> insertWhatsappInventory(
      payload, int configurationId, int brandId) async {
    return await ErrorHandler.callSupabase(
      () => cardWalletPagesSupabaseDataSource.insertWhatsappInventory(
          configurationId, payload, brandId),
      (value) {},
    );
  }

  @override
  Future<Either<ErrorState, int>> insertInventoryConfiguration(
      int brandId,
      InventoryServer inventorySever,
      Map<String, InventoryColumn> mappedColumns) async {
    return await ErrorHandler.callSupabase(
      () => cardWalletPagesSupabaseDataSource.insertInventoryConfiguration(
          brandId, inventorySever, mappedColumns),
      (value) {
        final result = value as int;
        return result;
      },
    );
  }

  @override
  Future<Either<ErrorState, void>> updateBusinessCardName(
      CardModel businessCard, String name) async {
    return await ErrorHandler.callSupabase(
      () => cardWalletPagesSupabaseDataSource.updateBusinessCardName(
          businessCard, name),
      (value) {},
    );
  }

  @override
  Future<Either<ErrorState, void>> updateBusinessCardLinks(
      CardModel businessCard, List<String> links) async {
    return await ErrorHandler.callSupabase(
      () => cardWalletPagesSupabaseDataSource.updateBusinessCardLinks(
          businessCard, links),
      (value) {},
    );
  }

  @override
  Future<Either<ErrorState, InventorySchemaResponse>>
      fetchColumnsAndDataTypesFromGoogleSheet(String sheetId) async {
    return await ErrorHandler.callSupabase(
      () => cardWalletPagesSupabaseDataSource
          .fetchColumnsAndDataTypesFromGoogleSheet(sheetId),
      (value) {
        final result = value as List<Map<String, dynamic>>;
        return InventorySchemaResponse(result
            .map((e) => InventoryColumn(
                e['name'], parseInventoryFieldType(e['field_type'])))
            .toList());
      },
    );
  }

  @override
  Future<Either<ErrorState, CardModel?>> cardExists(int id) async {
    return await ErrorHandler.callSupabase(
      () => cardWalletPagesSupabaseDataSource.cardExists(id),
      (value) {
        final res = value as Map<String, dynamic>?;
        if (res != null) {
          return CardModel.fromJson(res);
        } else {
          return null;
        }
      },
    );
  }

  @override
  Future<Either<ErrorState, List<UserPreference>>> fetchSharedPreferences(
      String hushhId, int cardId) async {
    return await ErrorHandler.callSupabase(
      () => cardWalletPagesSupabaseDataSource.fetchSharedPreferences(
          hushhId, cardId),
      (value) {
        final res = value as List<Map<String, dynamic>>;
        return res.map((e) => UserPreference.fromJson(e)).toList();
      },
    );
  }

  @override
  Future<Either<ErrorState, void>> insertSharedPreference(
      UserPreference preference, String hushhId, int cardId) async {
    return await ErrorHandler.callSupabase(
      () => cardWalletPagesSupabaseDataSource.insertSharedPreference(
          preference, hushhId, cardId),
      (value) {},
    );
  }

  @override
  Future<Either<ErrorState, AudioTranscription>> generateAudioTranscription(
      String audioUrl) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var data = jsonEncode({"file": audioUrl});
      var dio = Dio();
      var response = await dio.request(
        '${FirebaseRemoteConfigService().sttUrl}/transcription/url',
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: data,
      );
      return right(AudioTranscription.fromJson(response.data));
    } catch (err) {
      return left(DataParseError(Exception('err: $err')));
    }
  }

  @override
  Future<Either<ErrorState, void>> insertHealthData(
      Map<HealthDataType, List<Map<String, dynamic>>> data) async {
    return await ErrorHandler.callSupabase(
      () => cardWalletPagesSupabaseDataSource.insertHealthData(data),
      (value) {},
    );
  }

  @override
  Future<Either<ErrorState, Map<HealthDataType, List<Map<String, dynamic>>>>>
      fetchRemoteHealthData(String hushhId) async {
    return await ErrorHandler.callSupabase(
      () => cardWalletPagesSupabaseDataSource.fetchRemoteHealthData(hushhId),
      (value) {
        if (value != null && value is Map<String, dynamic>) {
          final result = value.entries
              .map((entry) {
                final type = HealthDataType.values.firstWhereOrNull(
                  (e) {
                    return e.name == entry.key;
                  },
                );
                if (type != null) {
                  return MapEntry(
                      type, List<Map<String, dynamic>>.from(entry.value));
                } else {
                  return null;
                }
              })
              .where((entry) => entry != null)
              .cast<MapEntry<HealthDataType, List<Map<String, dynamic>>>>()
              .toList();
          return Map.fromEntries(result);
        }
        return {};
      },
    );
  }

  @override
  Future<Either<ErrorState, void>> acceptDataConsentRequest(
      String requestId) async {
    return await ErrorHandler.callSupabase(
      () => cardWalletPageApiDataSource.acceptDataConsentRequest(requestId),
      (value) {},
    );
  }
}
