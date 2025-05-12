import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hushh_app/app/platforms/mobile/auth/data/data_sources/auth_page_supabase_data_source_impl.dart';
import 'package:hushh_app/app/platforms/mobile/auth/data/repository_impl/auth_page_repository_impl.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/fetch_agents_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/fetch_brand_categories_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/fetch_categories_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/fetch_user_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/fetch_users_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/insert_agent_role_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/insert_agent_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/insert_brand_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/insert_user_agent_location_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/insert_user_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/update_agent_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/update_user_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/agent_sign_up_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/auth_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/sign_up_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/data_sources/card_market_api_data_source.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/data_sources/card_market_supabase_data_source_impl.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/repository_impl/card_market_repository_impl.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/delete_user_installed_card_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/fetch_agents_who_purchased_the_card_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/fetch_attached_cards_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/fetch_brand_products_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/fetch_brands_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/fetch_card_market_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/fetch_card_questions_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/fetch_customers_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/fetch_insurance_details_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/fetch_purchased_items_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/fetch_travel_details_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/fetch_user_installed_card_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/generate_plaid_token_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/insert_brand_locations_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/insert_card_purchased_by_agent_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/insert_card_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/insert_user_installed_card_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/update_user_installed_card_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/bloc/card_market_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/data/data_sources/card_share_ecosystem_data_source_impl.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/data/repository_impl/card_share_ecosystem_repository_impl.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/domain/usecases/create_new_task_as_user_for_agent_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/domain/usecases/fetch_brand_ids_from_group_id_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/domain/usecases/fetch_brand_offers_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/presentation/bloc/card_share_ecosystem_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/data_sources/card_wallet_page_api_source.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/data_sources/card_wallet_page_supabase_data_source_impl.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/repository_impl/card_wallet_repository_impl.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/accept_data_consent_request_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/card_exists_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/delete_lookbook_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/delete_meet_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/delete_product_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/delete_shared_asset_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/delete_task_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/fetch_agent_notifications_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/fetch_all_assets_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/fetch_brand_info_from_domain_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/fetch_columns_and_data_types_from_google_sheet_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/fetch_inventories_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/fetch_look_books_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/fetch_meet_info_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/fetch_meetings_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/fetch_notifications_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/fetch_products_result_from_inventory_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/fetch_remote_health_data_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/fetch_shared_preferences_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/fetch_tasks_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/generate_audio_transcription_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/insert_agent_products_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/insert_health_data_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/insert_inventory_configuration_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/insert_inventory_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/insert_look_book_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/insert_meet_info_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/insert_meet_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/insert_shared_asset_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/insert_shared_preference_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/insert_task_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/insert_whatsapp_inventory_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/update_business_card_links_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/update_business_card_name_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/update_look_book_field_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/update_meet_info_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/user_installed_card_exists_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/agent_card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/agent_task_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/health_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/hushh_meet_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/inventory_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/lookbook_product_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/notifications_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/plaid_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/shared_assets_receipts_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/chat/data/data_sources/chat_supabase_data_source_impl.dart';
import 'package:hushh_app/app/platforms/mobile/chat/data/repository_impl/chat_repository_impl.dart';
import 'package:hushh_app/app/platforms/mobile/chat/domain/usecases/delete_conversation_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/chat/domain/usecases/fetch_ai_messages_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/chat/domain/usecases/fetch_conversation_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/chat/domain/usecases/fetch_conversations_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/chat/domain/usecases/fetch_messages_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/chat/domain/usecases/fetch_payement_request_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/chat/domain/usecases/insert_conversation_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/chat/domain/usecases/insert_payement_request_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/chat/domain/usecases/send_ai_message_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/chat/domain/usecases/send_message_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/chat/domain/usecases/update_ai_message_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/chat/domain/usecases/update_conversation_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/chat/domain/usecases/update_message_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/chat/domain/usecases/update_payement_request_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/chat/presentation/bloc/ai_chat_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/chat/presentation/bloc/chat_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/data/data_sources/receipt_radar_page_supabase_data_source_impl.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/data/repository_impl/receipt_radar_page_repository_impl.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/domain/usecases/fetch_receipt_radar_insights_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/domain/usecases/insert_receipt_radar_history_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/bloc/receipt_radar_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/pages/receipt_radar_utils.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/data_sources/settings_page_api_data_source.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/data_sources/settings_page_supabase_data_source_impl.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/repository_impl/settings_page_repository_impl.dart';
import 'package:hushh_app/app/platforms/mobile/settings/domain/usecases/after_usage_inserted_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/settings/domain/usecases/delete_account_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/settings/domain/usecases/fetch_app_ids_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/settings/domain/usecases/fetch_app_usage_count_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/settings/domain/usecases/fetch_browsing_behaviour_products_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/settings/domain/usecases/fetch_browsing_behaviour_visit_times_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/settings/domain/usecases/fetch_browsing_behaviour_wish_list_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/settings/domain/usecases/initiate_login_in_extension_with_hushh_qr_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/settings/domain/usecases/insert_browsed_product_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/settings/domain/usecases/insert_multiple_app_usage_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/settings/domain/usecases/link_hushh_id_with_extension_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/bloc/settings_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/splash/data/data_sources/splash_page_supabase_data_source_impl.dart';
import 'package:hushh_app/app/platforms/mobile/splash/data/repository_impl/splash_page_repository_impl.dart';
import 'package:hushh_app/app/platforms/mobile/splash/domain/usecases/fetch_all_nearby_brands_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/splash/domain/usecases/insert_user_brand_location_trigger_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/splash/domain/usecases/share_user_profile_and_requirements_with_agents_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/splash/domain/usecases/update_user_registration_token_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/splash/presentation/bloc/onboarding_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/splash/presentation/bloc/splash_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/backend_controller/auth_controller/auth_controller_impl.dart';
import 'package:hushh_app/app/shared/core/backend_controller/db_controller/db_controller_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/dev_tool.dart';
import 'package:hushh_app/app/shared/core/interceptors/dio_interceptor.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'blocs.dart';

part 'data_sources.dart';

part 'repositories.dart';

part 'usecases.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerSingleton<Talker>(customLogger());
  sl<Talker>().cleanHistory();
  sl.registerSingleton<Dio>(customDio());
  Bloc.observer = TalkerBlocObserver(
    talker: sl<Talker>(),
    settings: const TalkerBlocLoggerSettings(
      printCreations: false,
      printClosings: false,
      printStateFullData: false,
    ),
  );
  sl.registerSingleton<DbController>(DbControllerImpl());
  sl.registerSingleton<AuthController>(AuthControllerImpl());
  await injectDataSources();
  await injectRepositories();
  await injectUseCases();
  await injectBlocs();
  sl.registerSingleton<ReceiptRadarUtils>(ReceiptRadarUtils(sl()));
  await sl.allReady();
}

Future<void> clearAndReinitializeDependencies() async {
  Entity currentEntity = sl<HomePageBloc>().entity;
  await sl.reset();
  await initializeDependencies();
  sl<HomePageBloc>().entity = currentEntity;
}

Future<AuthPageBloc> resetAuthPageBlocInstance() async {
  if (sl.isRegistered<AuthPageBloc>()) {
    await sl.unregister<AuthPageBloc>();
  }
  sl.registerSingleton<AuthPageBloc>(AuthPageBloc(
    sl(),
    sl(),
    sl(),
    sl(),
  ));
  return sl<AuthPageBloc>();
}

Future<SignUpPageBloc> resetSignUpPageBlocInstance() async {
  if (sl.isRegistered<SignUpPageBloc>()) {
    await sl.unregister<SignUpPageBloc>();
  }
  sl.registerSingleton<SignUpPageBloc>(SignUpPageBloc(
    sl(),
    sl(),
  ));
  return sl<SignUpPageBloc>();
}
