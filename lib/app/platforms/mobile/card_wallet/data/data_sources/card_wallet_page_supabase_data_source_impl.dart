import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:health/health.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/data_sources/card_wallet_page_supabase_data_source.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_lookbook.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_meeting.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_product.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/inventory_schema_response.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/meeting_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/shared_asset.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/task.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/user_preference.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/backend_controller/db_controller/db_tables.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class CardWalletPageSupabaseDataSourceImpl
    extends CardWalletPageSupabaseDataSource {
  final supabase = Supabase.instance.client;

  @override
  Future<Map<String, dynamic>?> fetchMeeting(String uid) async {

    final data = await supabase
        .from(DbTables.agentSetupMeetsTable)
        .select()
        .eq('hushh_id', uid)
        .limit(1);
    return data.isEmpty ? null : data.first;
  }

  @override
  Future<void> insertMeeting(AgentMeeting meeting) async {
    await supabase.from(DbTables.agentSetupMeetsTable).insert(meeting.toJson());
  }

  @override
  Future<void> updateMeeting(AgentMeeting meeting, String? uid) async {
    await supabase
        .from(DbTables.agentSetupMeetsTable)
        .update(meeting.toJson())
        .eq('hushh_id', uid ?? meeting.hushhId);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchAgentNotifications(String uid) async {
    return await supabase
        .from(DbTables.notificationsTable)
        .select()
        .eq('user_id', uid)
        .order('created_at', ascending: false);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchNotifications(String uid) async {
    return await supabase
        .from(DbTables.notificationsTable)
        .select()
        .eq('user_id', uid)
        .order('created_at', ascending: false);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchSharedPreferences(
      String hushhId, int cardId) async {
    return await supabase
        .from(DbTables.sharedPreferencesTable)
        .select()
        .eq('hushh_id', hushhId)
        .eq('card_id', cardId)
        .order('created_at', ascending: false);
  }

  @override
  Future<void> insertSharedPreference(
      UserPreference preference, String hushhId, int cardId) async {
    log('🔄 [PREFERENCE_UPDATE] Starting preference insertion for user: $hushhId, card: $cardId');
    log('📝 [PREFERENCE_UPDATE] Question: "${preference.question}"');
    log('💬 [PREFERENCE_UPDATE] Answer: "${preference.answers.join(', ')}"');
    
    final data = preference.toJson();
    data.remove('mandatory');
    data.remove('question_id');
    data.addEntries([MapEntry('hushh_id', hushhId), MapEntry('card_id', cardId)]);
    
    try {
      // Insert preference data
      await supabase.from(DbTables.sharedPreferencesTable).insert(data);
      log('✅ [PREFERENCE_UPDATE] Preference data inserted successfully into shared_preferences table');
      
      // Update timestamp in users table based on preference type
      await _updateUserTimestamp(preference.question, hushhId);
      
      log('🎉 [PREFERENCE_UPDATE] Preference update completed successfully!');
    } catch (e) {
      log('❌ [PREFERENCE_UPDATE] Error inserting preference: $e');
      rethrow;
    }
  }

  Future<void> _updateUserTimestamp(String question, String hushhId) async {
    log('⏰ [TIMESTAMP_UPDATE] Analyzing question for timestamp update: "$question"');
    
    final now = DateTime.now().toIso8601String();
    Map<String, dynamic> updateData = {};
    String detectedType = 'unknown';
    
    // Check question type and update corresponding timestamp
    if (question.toLowerCase().contains('date of birth') || question.toLowerCase().contains('dob')) {
      updateData['dob_updated_at'] = now;
      detectedType = 'Date of Birth';
      log('🎂 [TIMESTAMP_UPDATE] Detected DOB preference - updating dob_updated_at timestamp');
    } else {
      log('❓ [TIMESTAMP_UPDATE] No specific timestamp field detected for this question type');
    }
    
    // Update users table if we have data to update
    if (updateData.isNotEmpty) {
      log('📊 [TIMESTAMP_UPDATE] Updating users table with timestamp data: $updateData');
      log('👤 [TIMESTAMP_UPDATE] Target user: $hushhId');
      
      try {
        await supabase
            .from(DbTables.usersTable)
            .update(updateData)
            .eq('hushh_id', hushhId);
        
        log('✅ [TIMESTAMP_UPDATE] Successfully updated $detectedType timestamp in users table!');
        log('🕐 [TIMESTAMP_UPDATE] Timestamp value: $now');
      } catch (e) {
        log('❌ [TIMESTAMP_UPDATE] Error updating timestamp in users table: $e');
        rethrow;
      }
    } else {
      log('⚠️ [TIMESTAMP_UPDATE] No timestamp update needed - question type not tracked');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> fetchAllAssets(
      String uid, int cardId) async {
    return await supabase
        .from(DbTables.sharedAssetsReceiptsTable)
        .select()
        .eq('hushhId', uid)
        .eq('cardId', cardId)
        .order('createdTime', ascending: false);
  }

  @override
  Future<void> deleteMeeting(MeetingModel meeting) async {
    await supabase
        .from(DbTables.agentMeetingsTable)
        .delete()
        .match({'id': meeting.id});
  }

  @override
  Future<void> deleteTask(TaskModel task) async {
    await supabase
        .from(DbTables.agentServices)
        .delete()
        .eq('id', task.id)
        .eq('hushh_id', AppLocalStorage.agent!.hushhId!);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchMeetings(String uid) async {
    return await supabase
        .from(DbTables.agentMeetingsTable)
        .select()
        .eq('organizerId', uid);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchTasks(String uid) async {
    return await supabase
        .from(DbTables.agentServices)
        .select()
        .eq('hushh_id', uid);
  }

  @override
  Future<void> insertTask(TaskModel task) async {
    await supabase.from(DbTables.agentServices).insert(task.toJson());
  }

  @override
  Future<void> deleteProduct(AgentProductModel product) async {
    await supabase.from(DbTables.agentProductsTable).delete().match({
      'productId': product.productId!,
      'hushh_id': AppLocalStorage.agent!.hushhId!
    });
  }

  @override
  Future<List<Map<String, dynamic>>> fetchLookBooks(String uid) async {
    return await supabase
        .from(DbTables.agentLookBooksTable)
        .select()
        .eq('hushhId', uid);
  }

  @override
  Future<void> insertAgentProducts(List<AgentProductModel> products) async {
    final data = products
        .map((product) => product.toJson(
            hushhId: AppLocalStorage.hushhId, productId: const Uuid().v4()))
        .toList();
    log(data.toString());
    await supabase.from(DbTables.agentProductsTable).insert(data);
  }

  @override
  Future<void> insertLookBook(
      AgentLookBook lookBook, List<AgentProductModel> products) async {
    final data = lookBook.toJson();
    log(data.toString());
    await supabase.from(DbTables.agentLookBooksTable).insert(data);
    for (var product in products) {
      await supabase
          .from(DbTables.agentProductsTable)
          .update({'lookbook_id': lookBook.id}).match({
        'productId': product.productId!,
        'hushh_id': AppLocalStorage.agent!.hushhId!
      });
    }
  }

  @override
  Future<void> updateLookBookField(
      String lookbookId, Map<String, dynamic> field) async {
    await supabase
        .from(DbTables.agentLookBooksTable)
        .update(field)
        .eq('id', lookbookId);
  }

  @override
  Future<bool> userInstalledCardExists(int id, String hushhId) async {
    final data = await supabase
        .from(DbTables.installedCardsTable)
        .select()
        .eq('id', id)
        .eq('user_id', hushhId)
        .count();
    return data.count != 0;
  }

  @override
  Future<Map<String, dynamic>> insertSharedAsset(SharedAsset asset) async {
    final data = asset.toJson();
    data.remove('fileData');
    data.remove('id');
    data.remove('name');
    final res = await supabase
        .from(DbTables.sharedAssetsReceiptsTable)
        .insert(data)
        .select();
    return res.first;
  }

  @override
  Future<void> deleteSharedAsset(SharedAsset asset) async {
    await supabase
        .from(DbTables.sharedAssetsReceiptsTable)
        .delete()
        .match({'id': asset.id!});
  }

  @override
  Future<void> insertMeet(MeetingModel meeting) async {
    await supabase.from(DbTables.agentMeetingsTable).insert(meeting.toJson());
  }

  @override
  Future<void> deleteLookBook(AgentLookBook lookBook) async {
    await supabase
        .from(DbTables.agentLookBooksTable)
        .delete()
        .match({'id': lookBook.id});
  }

  @override
  Future<List<Map<String, dynamic>>> fetchInventories(int brandId) async {
    return await supabase
        .from(DbTables.brandConfigurations)
        .select()
        .eq('brand_id', brandId);
  }

  @override
  Future<Map<String, dynamic>?> fetchProductsResultFromInventory(
      int brandId, int configurationId) async {
    final data = await supabase.rpc('fetch_brand_inventory_by_config', params: {
      'p_brand_id': brandId,
      'p_configuration_id': configurationId,
    }).single();
    return data;
  }

  @override
  Future<int> insertInventoryConfiguration(
    int brandId,
    InventoryServer inventoryServer,
    Map<String, InventoryColumn> mappedColumns,
  ) async {
    final data = {
      'configuration_server_type': inventoryServer.name,
      'brand_id': brandId,
      'inventory_name': 'Inventory',
      'product_image_identifier':
          mappedColumns['product_image_identifier']?.name,
      'product_name_identifier': mappedColumns['product_name_identifier']?.name,
      'product_sku_unique_id_identifier':
          mappedColumns['product_sku_unique_id_identifier']?.name,
      'product_price_identifier':
          mappedColumns['product_price_identifier']?.name,
      'product_currency_identifier':
          mappedColumns['product_currency_identifier']?.name,
      'product_description_identifier':
          mappedColumns['product_description_identifier']?.name,
    };
    return (await supabase
            .from(DbTables.brandConfigurations)
            .insert(data)
            .select())
        .first['configuration_id'];
  }

  @override
  Future<void> insertInventory(
    dynamic payload,
    int configurationId,
    int brandId,
    InventoryServer inventoryServer,
    Map<String, InventoryColumn> mappedColumns,
  ) async {
    final columns = mappedColumns.values
        .map((col) => {
              'name': col.name,
              'fieldType': col.fieldType.toString().split('.').last,
            })
        .toList();

    await supabase.rpc('create_foreign_inventory_table', params: {
      'table_name': '$configurationId',
      'columns': columns,
      'sheet_id': payload,
      'p_brand_id': brandId,
    });
  }

  @override
  Future<void> insertWhatsappInventory(
      int configurationId, dynamic payload, int brandId) async {
    await supabase.functions.invoke('insert-whatsapp-inventory', body: {
      'configuration_id': '$configurationId',
      'phone_number': payload,
      'brand_id': brandId
    });
  }

  @override
  Future<List<Map<String, dynamic>>> fetchColumnsAndDataTypesFromGoogleSheet(
      String sheetId) async {
    String mapDataType(String googleDataType) {
      switch (googleDataType) {
        case 'string':
          return 'text';
        case 'number':
          return 'numeric';
        case 'boolean':
          return 'boolean';
        case 'date':
          return 'date';
        default:
          return 'text';
      }
    }

    List<Map<String, dynamic>> parseGoogleSheetsResponse(
        String responseString) {
      // Extract the JSON part from the response string
      final jsonString = responseString.substring(
          responseString.indexOf('{'), responseString.lastIndexOf('}') + 1);

      // Parse the JSON
      final jsonData = json.decode(jsonString);

      // Extract the columns information
      final cols = jsonData['table']['cols'] as List;

      // Create the resColumns list
      List<Map<String, dynamic>> resColumns = [];

      for (var col in cols) {
        String columnName = col['label'];
        String dataType = mapDataType(col['type']);

        resColumns.add({'name': columnName, 'field_type': dataType});
      }

      return resColumns;
    }

    final url =
        'https://docs.google.com/spreadsheets/d/$sheetId/gviz/tq?tqx=out:json';
    log(url);
    final response = await sl<Dio>().getUri(Uri.parse(url));
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> resColumns =
          parseGoogleSheetsResponse(response.data.toString());
      return resColumns;
    }

    return [];
  }

  @override
  Future<void> updateBusinessCardName(
      CardModel businessCard, String name) async {
    businessCard.brandPreferences.firstOrNull?.metadata?['answers']
        ['business_name'] = name;
    final data = businessCard.toInsertJson();
    return await supabase
        .from(DbTables.userInstalledCardsTable)
        .update(data)
        .match({'cid': businessCard.cid!});
  }

  @override
  Future<void> updateBusinessCardLinks(
      CardModel businessCard, List<String> links) async {
    businessCard.brandPreferences.firstOrNull?.metadata?['answers']['links'] =
        links;
    final data = businessCard.toInsertJson();
    return await supabase
        .from(DbTables.userInstalledCardsTable)
        .update(data)
        .match({'cid': businessCard.cid!});
  }

  @override
  Future<void> insertHealthData(
      Map<HealthDataType, List<Map<String, dynamic>>> data) async {
    for (var dataType in data.keys) {
      final typeName =
          dataType.toString().split('.').last; // Convert enum to string
      final dataList = data[dataType] ?? [];

      for (var dataEntry in dataList) {
        try {
          await supabase.from('health_data').upsert({
            'hushh_id': AppLocalStorage.hushhId,
            'data_type': typeName,
            'date_from': dataEntry['dateFrom'].toIso8601String(),
            'date_to': dataEntry['dateTo'].toIso8601String(),
            'value': dataEntry['value'].runtimeType is String
                ? (double.tryParse(dataEntry['value']) ?? 0)
                : dataEntry['value'],
          });
        } catch (_) {
          continue;
        }
      }
    }
  }

  @override
  Future<Map<String, dynamic>?> fetchRemoteHealthData(String hushhId) async {
    final response = await supabase
        .from('health_data')
        .select()
        .eq('hushh_id', hushhId)
        .select();

    Map<String, List<Map<String, dynamic>>> result = {};

    for (var item in response) {
      if (item['data_type'] != null) {
        String dataType = item['data_type'];
        result[dataType] ??= [];
        result[dataType]!.add(item);
      }
    }

    return result;
  }

  @override
  Future<Map<String, dynamic>?> cardExists(int id) async {
    return (await supabase
            .from(DbTables.cardMarketTable)
            .select('brand_id')
            .eq('brand_id', id)
            .select())
        .firstOrNull;
  }
}
