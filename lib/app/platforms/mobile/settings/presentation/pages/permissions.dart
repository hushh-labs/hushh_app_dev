import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  importance: Importance.high,
);

class PermissionsView extends StatefulWidget {
  const PermissionsView({super.key});

  @override
  State<PermissionsView> createState() => _PermissionsViewState();
}

class _PermissionsViewState extends State<PermissionsView> {
  bool allPermissionsGranted = false;
  final Map<String, bool> permissionStatuses = {
    'notification': false,
    'contact': false,
    'location': false,
    'camera': false,
    'media': false,
    'microphone': false,
  };

  @override
  void initState() {
    super.initState();
    _initializePermissionStatuses();
  }

  Future<void> _initializeNotificationPermission() async {
    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } else {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
    permissionStatuses['notification'] = await Permission.notification.isGranted;
    _checkAllPermissionStatuses();
  }

  Future<void> _requestPermission(Permission permission, String key) async {
    bool early = await permission.isGranted;
    await permission.request();
    bool now = await permission.isGranted;
    if(!early && !now) {
      await openAppSettings();
    }
    permissionStatuses[key] = await permission.isGranted;
    _checkAllPermissionStatuses();
  }

  Future<void> _checkPermissionStatus(Permission permission, String key) async {
    permissionStatuses[key] = await permission.isGranted;
    _checkAllPermissionStatuses();
  }

  Future<void> _initializePermissionStatuses() async {
    permissionStatuses['notification'] = await Permission.notification.isGranted;
    permissionStatuses['contact'] = await Permission.contacts.isGranted;
    permissionStatuses['location'] = (await Permission.locationWhenInUse.isGranted) || (await Permission.locationAlways.isGranted) || (await Permission.location.isGranted);
    permissionStatuses['camera'] = await Permission.camera.isGranted;
    permissionStatuses['media'] = await Permission.photos.isGranted;
    permissionStatuses['microphone'] = await Permission.microphone.isGranted;

    _checkAllPermissionStatuses();
  }

  Future<void> _checkAllPermissionStatuses() async {
    setState(() {
      allPermissionsGranted = permissionStatuses.values.every((status) => status);
    });
  }

  void _toggleAllPermissions(bool value) async {
    if (value) {
      await _initializeNotificationPermission();
      await _requestPermission(Permission.contacts, 'contact');
      await _requestPermission(Permission.locationWhenInUse, 'location');
      await _requestPermission(Permission.camera, 'camera');
      await _requestPermission(Permission.photos, 'media');
      await _requestPermission(Permission.microphone, 'microphone');
    } else {
      permissionStatuses.updateAll((key, value) => false);
      await openAppSettings();
    }
    _checkAllPermissionStatuses();
  }

  Widget _buildPermissionTile({
    required String title,
    required String description,
    required String key,
    required Permission permission,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xffE0E0E0), width: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 24, color: Colors.black),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  Text(description, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
          CupertinoSwitch(
            value: permissionStatuses[key] ?? false,
            onChanged: (value) async {
              if (value) {
                await _requestPermission(permission, key);
              } else {
                await openAppSettings();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F7),
      appBar: AppBar(
        title: const Text('App Access', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xffF2F2F7),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Hushh may ask for access to information from your device, such as your contacts, photos, or location.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Turn on all', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                CupertinoSwitch(
                  value: allPermissionsGranted,
                  onChanged: _toggleAllPermissions,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildPermissionTile(
            title: 'Notifications',
            description: 'Enable app notifications',
            key: 'notification',
            permission: Permission.notification,
            icon: Icons.notifications,
          ),
          _buildPermissionTile(
            title: 'Contacts',
            description: 'Access your contacts',
            key: 'contact',
            permission: Permission.contacts,
            icon: Icons.contacts,
          ),
          _buildPermissionTile(
            title: 'Location',
            description: 'Access your location',
            key: 'location',
            permission: Permission.locationWhenInUse,
            icon: Icons.location_on,
          ),
          _buildPermissionTile(
            title: 'Camera',
            description: 'Access your camera',
            key: 'camera',
            permission: Permission.camera,
            icon: Icons.camera_alt,
          ),
          _buildPermissionTile(
            title: 'Media',
            description: 'Access your photos and videos',
            key: 'media',
            permission: Permission.photos,
            icon: Icons.photo_library,
          ),
          _buildPermissionTile(
            title: 'Microphone',
            description: 'Access your microphone',
            key: 'microphone',
            permission: Permission.microphone,
            icon: Icons.mic,
          ),
        ],
      ),
    );
  }
}
