import 'package:dartz/dartz.dart';
import 'package:health/health.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/models/audio_transcription.dart';
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
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';

abstract class CardWalletPageRepository {
  Future<Either<ErrorState, CardModel?>> fetchBrandInfoFromDomain(
      String domain);

  Future<Either<ErrorState, AgentMeeting?>> fetchHushhMeetInfo(String uid);

  Future<Either<ErrorState, void>> insertHushhMeet(AgentMeeting meeting);

  Future<Either<ErrorState, void>> updateMeeting(
    AgentMeeting meeting,
    String? uid,
  );

  Future<Either<ErrorState, List<CustomNotification>>> fetchNotifications(
      String uid);

  Future<Either<ErrorState, List<CustomNotification>>> fetchAgentNotifications(
      String uid);

  Future<Either<ErrorState, List<SharedAsset>>> fetchAllAssets(
      String uid, int cardId);

  Future<Either<ErrorState, void>> insertTask(TaskModel task);

  Future<Either<ErrorState, void>> deleteTask(TaskModel task);

  Future<Either<ErrorState, List<TaskModel>>> fetchTasks(String uid);

  Future<Either<ErrorState, void>> insertMeet(MeetingModel meeting);

  Future<Either<ErrorState, void>> deleteMeet(MeetingModel meeting);

  Future<Either<ErrorState, void>> deleteProduct(AgentProductModel product);

  Future<Either<ErrorState, List<MeetingModel>>> fetchMeetings(String uid);

  Future<Either<ErrorState, List<AgentLookBook>>> fetchLookBooks(String uid);

  Future<Either<ErrorState, void>> insertLookBook(
      AgentLookBook lookBook, List<AgentProductModel> products);

  Future<Either<ErrorState, void>> insertAgentProducts(
      List<AgentProductModel> products);

  Future<Either<ErrorState, void>> updateLookBookField(
    String lookbookId,
    Map<String, dynamic> field,
  );

  Future<Either<ErrorState, bool>> userInstalledCardExists(
      int id, String hushhId);

  Future<Either<ErrorState, SharedAsset>> insertSharedAsset(SharedAsset asset);

  Future<Either<ErrorState, void>> deleteSharedAsset(SharedAsset asset);

  Future<Either<ErrorState, void>> deleteLookBook(AgentLookBook lookBook);

  Future<Either<ErrorState, List<InventoryConfiguration>>> fetchInventories(
      int brandId);

  Future<Either<ErrorState, CachedInventoryModel?>>
      fetchProductsResultFromInventory(int brandId, int configurationId);

  Future<Either<ErrorState, void>> insertInventory(
      dynamic payload,
      int configurationId,
      int brandId,
      InventoryServer inventorySever,
      Map<String, InventoryColumn> mappedColumns);

  Future<Either<ErrorState, void>> insertWhatsappInventory(
      payload, int configurationId, int brandId);

  Future<Either<ErrorState, InventorySchemaResponse>>
      fetchColumnsAndDataTypesFromGoogleSheet(String sheetId);

  Future<Either<ErrorState, int>> insertInventoryConfiguration(
      int brandId,
      InventoryServer inventorySever,
      Map<String, InventoryColumn> mappedColumns);

  Future<Either<ErrorState, void>> updateBusinessCardName(
      CardModel businessCard, String name);

  Future<Either<ErrorState, void>> updateBusinessCardLinks(
      CardModel businessCard, List<String> links);

  Future<Either<ErrorState, CardModel?>> cardExists(int id);

  Future<Either<ErrorState, List<UserPreference>>> fetchSharedPreferences(
      String hushhId, int cardId);

  Future<Either<ErrorState, void>> insertSharedPreference(
      UserPreference preference, String hushhId, int cardId);

  Future<Either<ErrorState, AudioTranscription>> generateAudioTranscription(
      String audioUrl);

  Future<Either<ErrorState, void>> insertHealthData(
      Map<HealthDataType, List<Map<String, dynamic>>> data);

  Future<Either<ErrorState, Map<HealthDataType, List<Map<String, dynamic>>>>>
      fetchRemoteHealthData(String hushhId);

  Future<Either<ErrorState, void>> acceptDataConsentRequest(String requestId);
}
