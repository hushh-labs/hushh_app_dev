import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:hushh_app/app/platforms/mobile/auth/data/models/agent_category.dart';
import 'package:hushh_app/app/platforms/mobile/auth/data/models/brand_category.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/agent.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/location.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/user.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/models/card_purchased_by_agent.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_question.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_lookbook.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_meeting.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_product.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/brand_location.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/inventory_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/meeting_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/shared_asset.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/task.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/user_preference.dart';
import 'package:hushh_app/app/platforms/mobile/chat/data/models/conversation.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/data/models/insights.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/data/models/receipt_radar_history.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/app_usage_data.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/brand.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/browsed_collection.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/browsed_product_model.dart';
import 'package:hushh_app/app/shared/core/models/payment_model.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';

class DbTables {
  /// [UserModel]
  static const String usersTable = 'users';
  /// [CustomNotification]
  // static const String userNotificationsTable = 'user_notifications';
  /// [CardModel]
  static const String userInstalledCardsTable = 'user_installed_cards';
  /// [CardPurchasedByAgent]
  static const String cardsPurchasedByAgentTable = 'cards_purchased_by_agent';
  /// [CardModel]
  static const String installedCardsTable = 'installed_cards';
  /// [CardModel]
  static const String cardMarketTable = 'card_market_with_category';
  /// [CardModel]
  static const String cardMarketInsertTable = 'card_market';
  /// [CardQuestion]
  static const String cardMarketQuestionnaireTable = 'card_market_questionnaire';
  /// []
  static const String browsingBehaviorTable = 'browsing_behavior';
  /// [BrowsedProduct]
  static const String browsingProductsTable = 'products';
  /// [Brand]
  static const String browsingBrandsTable = 'brands';
  /// [BrowsedCollection]
  static const String browsingCollectionsTable = 'collection_products_view';
  /// [AppUsageData]
  static const String appUsageTable = 'app_usage';
  /// [AppUsageData]
  static const String userAppsTable = 'user_apps';
  /// [_]
  static const String appExtensionQrLogin = 'app_extension_qr_login';
  /// [UserPreference]
  static const String sharedPreferencesTable = 'shared_preferences';

  /// [PaymentModel]
  static const String paymentRequestsTable = 'payment_requests';
  /// [ReceiptInsights]
  static const String receiptRadarTable = 'receipt_radar';
  /// [ReceiptRadarHistory]
  static const String receiptRadarHistory = 'user_gmail_token_details';
  /// [SharedAsset]
  static const String sharedAssetsReceiptsTable = 'shared_assets_receipts';
  /// [Conversation]
  static const String conversationsTable = 'conversations';
  /// [Message]
  static const String aiMessagesTable = 'ai_messages';
  /// [Message]
  static const String messagesTable = 'messages';
  static const String registrationTokensTable = 'registration_tokens';
  static const String userBrandLocationTriggersTable = 'user_brand_location_triggers';
  static const String notificationsTable = 'notifications';

  /// [AgentModel]
  static const String agentsTable = 'agents';
  /// [AgentModel]
  static const String agentsView = 'agents_view';
  /// [LocationModel]
  static const String locationsTable = 'locations';
  /// [Brand]
  static const String brandsTable = 'brand_details';
  static const String brandTeamsTable = 'brand_teams';
  /// [Brand]
  static const String brandsView = 'brands_view';
  /// [BrandLocation]
  static const String brandLocationsTable = 'brand_locations';
  /// [CustomNotification]
  // static const String agentNotificationsTable = 'agent_notifications';
  /// [AgentCategory]
  static const String agentCategoriesTable = 'agent_categories';
  /// [BrandCategory]
  static const String brandCategoriesTable = 'brand_categories';
  /// [AgentLookBook]
  static const String agentLookBooksTable = 'agent_lookbooks';
  /// [InventoryModel]
  static const String brandConfigurations = 'brand_configurations';
  /// [AgentProductModel]
  static const String agentProductsTable = 'agent_products';
  /// [AgentMeeting]
  static const String agentSetupMeetsTable = 'agent_setup_meets';
  /// [MeetingModel]
  static const String agentMeetingsTable = 'agent_meetings';
  /// [TaskModel]
  static const String agentServices = 'agent_services';
}