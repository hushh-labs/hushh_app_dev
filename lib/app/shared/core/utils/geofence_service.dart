import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:geofence_foreground_service/constants/geofence_event_type.dart'
    as et;
import 'package:geofence_foreground_service/exports.dart';
import 'package:geofence_foreground_service/geofence_foreground_service.dart';
import 'package:geofence_foreground_service/models/zone.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/user_brand_location_trigger_model.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/core/backend_controller/db_controller/db_tables.dart';
import 'package:hushh_app/app/shared/core/utils/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Callback function type for geofence events
typedef GeofenceEventCallback = void Function(
    String zoneId, et.GeofenceEventType eventType);

class GeofenceService {
  static final GeofenceService _instance = GeofenceService._internal();
  final GeofenceForegroundService _geofenceService =
      GeofenceForegroundService();

  // Stream controller for broadcasting geofence events
  final _geofenceEventController =
      StreamController<Map<int, et.GeofenceEventType>>.broadcast();

  // Getter for the event stream
  Stream<Map<int, et.GeofenceEventType>> get geofenceStream =>
      _geofenceEventController.stream;

  factory GeofenceService() {
    return _instance;
  }

  GeofenceService._internal();

  /// Initialize the geofence service
  /// Returns true if service started successfully
  Future<bool> initialize({
    required String notificationTitle,
    required String notificationText,
    required String channelId,
    int serviceId = 525600,
  }) async {
    // Skip geofencing initialization on iOS to prevent crashes
    if (Platform.isIOS) {
      log('Geofencing service disabled on iOS');
      return true; // Return true to not break the app flow
    }

    await Permission.location.request();
    await Permission.locationAlways.request();
    await Permission.notification.request();

    try {
      return await _geofenceService.startGeofencingService(
        contentTitle: notificationTitle,
        contentText: notificationText,
        notificationChannelId: channelId,
        serviceId: serviceId,
        callbackDispatcher: _geofenceCallback,
      );
    } catch (e) {
      log('Error starting geofencing service: $e');
      return false;
    }
  }

  /// Add a new geofence zone
  Future<bool> addGeofence({
    required int brandLocationId,
    required int brandId,
    required String brandName,
    required List<LatLng> coordinates,
    required double radiusInMeters,
  }) async {
    // Skip geofencing operations on iOS
    if (Platform.isIOS) {
      log('Geofence add operation skipped on iOS');
      return true;
    }

    try {
      await _geofenceService.addGeofenceZone(
        zone: Zone(
          id: 'zone#${brandLocationId}_${brandId}_$brandName',
          radius: radiusInMeters,
          coordinates: coordinates,
        ),
      );
      return true;
    } catch (e) {
      log('Error adding geofence: $e');
      return false;
    }
  }

  /// Remove a geofence zone by ID
  Future<bool> removeGeofence(String zoneId) async {
    // Skip geofencing operations on iOS
    if (Platform.isIOS) {
      log('Geofence remove operation skipped on iOS');
      return true;
    }

    try {
      await _geofenceService.removeGeofenceZone(zoneId: zoneId);
      return true;
    } catch (e) {
      log('Error removing geofence: $e');
      return false;
    }
  }

  /// Remove all geofence zones
  Future<bool> removeAllGeoFences() async {
    // Skip geofencing operations on iOS
    if (Platform.isIOS) {
      log('Geofence remove all operation skipped on iOS');
      return true;
    }

    try {
      return await _geofenceService.removeAllGeoFences();
    } catch (e) {
      log('Error removing all geofences: $e');
      return false;
    }
  }

  /// Stop the geofence service
  Future<void> stopService() async {
    // Skip geofencing operations on iOS
    if (Platform.isIOS) {
      log('Geofence stop service operation skipped on iOS');
      return;
    }

    try {
      await _geofenceService.stopGeofencingService();
    } catch (e) {
      log('Error stopping geofencing service: $e');
    }
  }

  /// Dispose the service and close streams
  void dispose() {
    _geofenceEventController.close();
  }
}

/// Top-level callback function for handling geofence events
@pragma('vm:entry-point')
void _geofenceCallback() async {
  GeofenceForegroundService().handleTrigger(
    backgroundTriggerHandler: (data, triggerType) async {
      int brandLocationId =
          int.parse(data.replaceAll('zone#', '').split('_')[0]);
      int brandId = int.parse(data.replaceAll('zone#', '').split('_')[1]);
      String brandName = data.replaceAll('zone#', '').split('_')[2];

      if (!Platform.isIOS) {
        await Supabase.initialize(
          url: const String.fromEnvironment('supabase_url'),
          anonKey: const String.fromEnvironment('supabase_anon_key'),
        );

        String? userId = Supabase.instance.client.auth.currentUser?.id;

        log("userID: $userId");

        if (userId != null) {
          final data = UserBrandLocationTriggerModel(
                  triggerType: triggerType.name,
                  userId: userId,
                  brandId: brandId,
                  brandLocationId: brandLocationId)
              .toJson();
          data.remove('created_at');
          log(data.toString());
          try {
            await Supabase.instance.client
                .from(DbTables.userBrandLocationTriggersTable)
                .insert(data);
          } catch (err, s) {
            log(err.toString());
            log(s.toString());
          }
        }

        switch (triggerType) {
          case et.GeofenceEventType.enter:
            NotificationService().showNotification(
                NotificationsConstants
                    .ASKING_USER_REASON_TO_ENTER_IN_BRAND_STORE,
                'Glad to have you at $brandName!',
                'Looking for something specific? Let us know how we can help during your visit!',
                {'brand_location_id': brandLocationId, 'brandId': brandId, 'userId': userId});
            log('Entered $brandLocationId');
            break;
          case et.GeofenceEventType.exit:
            NotificationService().showNotification(
                NotificationsConstants
                    .ASKING_USER_REASON_TO_ENTER_IN_BRAND_STORE,
                'Sorry to see you leave $brandName!',
                '',
                {'brand_location_id': brandLocationId, 'brandId': brandId, 'userId': userId});
            log('Exited $brandLocationId');
            break;
          case et.GeofenceEventType.dwell:
            log('Dwelling $brandLocationId');
            break;
          default:
            break;
        }
      }

      return Future.value(true);
    },
  );
}

class GeofenceUtils {
  /// Earth's radius in meters
  static const double _earthRadius = 6371000;

  /// Generates a list of LatLng points forming a circle around a center point
  /// [center] - The center point of the circle
  /// [radiusInMeters] - The radius of the circle in meters
  /// [numberOfPoints] - Number of points to generate (more points = smoother circle)
  static List<LatLng> generateCircularGeofence({
    required LatLng center,
    required double radiusInMeters,
    int numberOfPoints = 32,
  }) {
    List<LatLng> coordinates = [];

    // Convert center point to radians for calculations
    final centerLatRad = center.latitude.radians;
    final centerLonRad = center.longitude.radians;

    for (int i = 0; i < numberOfPoints; i++) {
      // Calculate point on circle
      final angle = (i * 2 * math.pi) / numberOfPoints;

      // Calculate offset from center
      final dx = radiusInMeters * math.cos(angle);
      final dy = radiusInMeters * math.sin(angle);

      // Convert offset to lat/lon
      // Using approximation valid for small distances
      final newLat = centerLatRad + (dy / _earthRadius);
      final newLon =
          centerLonRad + (dx / (_earthRadius * math.cos(centerLatRad)));

      // Convert back to degrees and create LatLng
      coordinates.add(LatLng(
        Angle.radian(newLat),
        Angle.radian(newLon),
      ));
    }

    return coordinates;
  }

  /// Calculate distance between two points in meters
  static double calculateDistance(LatLng point1, LatLng point2) {
    final lat1 = point1.latitude.radians;
    final lon1 = point1.longitude.radians;
    final lat2 = point2.latitude.radians;
    final lon2 = point2.longitude.radians;

    final dLat = lat2 - lat1;
    final dLon = lon2 - lon1;

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return _earthRadius * c;
  }
}
