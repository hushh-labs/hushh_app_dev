import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/app_usage_info_ui.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/components/app_usage_list_tile.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/utils_impl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeviceActivityAllAppsPage extends StatefulWidget {
  const DeviceActivityAllAppsPage({super.key});

  @override
  State<DeviceActivityAllAppsPage> createState() =>
      _DeviceActivityAllAppsPageState();
}

class _DeviceActivityAllAppsPageState extends State<DeviceActivityAllAppsPage> {
  List<AppUsageInfo>? apps;
  List<String> connectedAppIds = [];

  @override
  void initState() {
    Supabase.instance.client
        .from('app_connections')
        .select('app_id')
        .eq('hushh_id', AppLocalStorage.hushhId ?? "")
        .then((value) {
      connectedAppIds = value.map((e) => e['app_id'] as String).toList();
      setState(() {});
    });
    Supabase.instance.client.rpc(
      'get_user_app_usage',
      params: {
        'user_hushh_id': AppLocalStorage.hushhId,
      },
    ).then((value) {
      List data = value as List;
      for (var item in data) {
        apps ??= [];
        apps?.add(AppUsageInfo(
            appId: item['app_id'],
            iconPath: item['icon_url'],
            categoryName: item['category_name'],
            canConnect: item['can_connect'],
            name: (item['app_name'] as String).split(':').first.capitalize(),
            time: Utils().formatDuration(item['total_usage'])));
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Usage',
            style: TextStyle(fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: apps?.length ?? 0,
          itemBuilder: (context, index) => AppUsageListTile(
              app: apps![index],
              isAppConnected: connectedAppIds.contains(apps![index].appId))),
    );
  }
}
