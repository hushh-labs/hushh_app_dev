import 'dart:io';

import 'package:geocoding_platform_interface/src/models/placemark.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/user_brand_location_trigger_model.dart';
import 'package:hushh_app/app/platforms/mobile/splash/data/data_sources/splash_page_supabase_data_source.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/backend_controller/db_controller/db_tables.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashPageSupabaseDataSourceImpl extends SplashPageSupabaseDataSource {
  final supabase = Supabase.instance.client;

  @override
  Future<void> updateUserRegistrationToken(String token, String hushhId) async {
    final res = await supabase.from(DbTables.registrationTokensTable).upsert({
      'token': token,
      'hushh_id': hushhId,
      'device': Platform.isIOS ? 'iOS' : 'android'
    }, onConflict: 'hushh_id');
  }

  @override
  Future<List<Map<String, dynamic>>> fetchAllNearbyBrands(
      Placemark place, List<CardModel> installedBrandCards) async {
    final brandIds = installedBrandCards.map((e) {
      return e.brandId;
    }).toList();
    brandIds.removeWhere((element) => element == null);
    if (brandIds.isNotEmpty) {
      return List<Map<String, dynamic>>.from((await supabase.functions
              .invoke('fetch-nearby-brand-locations', body: {
        'city': place.locality ?? place.administrativeArea,
        'brandIds': brandIds
      }))
          .data['brandLocations']);
    }
    return [];
  }

  @override
  Future<void> insertUserBrandLocationTrigger(
      UserBrandLocationTriggerModel userBrandLocationTrigger) async {
    await supabase
        .from(DbTables.userBrandLocationTriggersTable)
        .insert(userBrandLocationTrigger.toJson());
  }

  @override
  Future<void> shareUserProfileAndRequirementsWithAgent(
      String agentId, String query, int cardId, String senderHushhId) async {
    try {
      await supabase.functions.invoke('notification-sender', body: {
        'userId': agentId,
        'notification': {
          'id': NotificationsConstants.INFORMING_AGENT_ABOUT_USER_REQUEST,
          'title': 'You\'ve got a new customer!',
          'description': 'Tap now to find out more details',
          'route': '/${AppRoutes.cardWallet.info.main}',
          'status': 'success',
          'notification_type': 'location',
          'payload': {
            'query': query,
            'cardId': cardId,
            'userId': senderHushhId
          },
        }
      });
    } catch (_) {}
  }
}
