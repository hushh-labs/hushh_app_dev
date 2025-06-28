import 'package:health/health.dart';
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

abstract class CardWalletPageSupabaseDataSource {
  Future<Map<String, dynamic>?> fetchMeeting(String uid);

  Future<void> insertMeeting(AgentMeeting meeting);

  Future<void> updateMeeting(AgentMeeting meeting, String? uid);

  Future<List<Map<String, dynamic>>> fetchNotifications(String uid);

  Future<List<Map<String, dynamic>>> fetchAgentNotifications(String uid);

  Future<List<Map<String, dynamic>>> fetchAllAssets(String uid, int cardId);

  Future<void> deleteMeeting(MeetingModel meeting);

  Future<void> deleteTask(TaskModel task);

  Future<List<Map<String, dynamic>>> fetchMeetings(String uid);

  Future<List<Map<String, dynamic>>> fetchTasks(String uid);

  Future<void> insertTask(TaskModel task);

  Future<void> deleteProduct(AgentProductModel product);

  Future<List<Map<String, dynamic>>> fetchLookBooks(String uid);

  Future<void> insertAgentProducts(List<AgentProductModel> products);

  Future<void> insertLookBook(
      AgentLookBook lookBook, List<AgentProductModel> products);

  Future<void> updateLookBookField(
      String lookbookId, Map<String, dynamic> field);

  Future<bool> userInstalledCardExists(int id, String hushhId);

  Future<Map<String, dynamic>> insertSharedAsset(SharedAsset asset);

  Future<void> deleteSharedAsset(SharedAsset asset);

  Future<void> insertMeet(MeetingModel meeting);

  Future<void> deleteLookBook(AgentLookBook lookBook);

  Future<List<Map<String, dynamic>>> fetchInventories(int brandId);

  Future<Map<String, dynamic>?> fetchProductsResultFromInventory(
      int brandId, int configurationId);
  
  Future<List<Map<String, dynamic>>> fetchAgentProducts(String hushhId);

  Future<void> insertInventory(
      dynamic payload,
      int configurationId,
      int brandId,
      InventoryServer inventoryServer,
      Map<String, InventoryColumn> mappedColumns);

  Future<void> insertWhatsappInventory(
      int configurationId, dynamic payload, int brandId);

  Future<void> insertInventoryConfiguration(
      int brandId,
      InventoryServer inventoryServer,
      Map<String, InventoryColumn> mappedColumns);

  Future<List<Map<String, dynamic>>> fetchColumnsAndDataTypesFromGoogleSheet(
      String sheetId);

  Future<void> updateBusinessCardName(CardModel businessCard, String name);

  Future<void> updateBusinessCardLinks(
      CardModel businessCard, List<String> links);

  Future<Map<String, dynamic>?> cardExists(int id);

  Future<void> insertHealthData(
      Map<HealthDataType, List<Map<String, dynamic>>> data);

  Future<Map<String, dynamic>?> fetchRemoteHealthData(String hushhId);

  Future<List<Map<String, dynamic>>> fetchSharedPreferences(
      String hushhId, int cardId);

  Future<void> insertSharedPreference(UserPreference preference, String hushhId, int cardId);
}
