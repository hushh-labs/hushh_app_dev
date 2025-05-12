import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/app_usage_data.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/app_usage_info_ui.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/components/app_usage_bar_chart.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:hushh_app/app/shared/core/utils/utils_impl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

class DeviceActivityDetailsPage extends StatefulWidget {
  final AppUsageInfo app;

  const DeviceActivityDetailsPage({super.key, required this.app});

  @override
  State<DeviceActivityDetailsPage> createState() =>
      _DeviceActivityDetailsPageState();
}

class _DeviceActivityDetailsPageState extends State<DeviceActivityDetailsPage> {
  double? averageAppUsage;

  @override
  void initState() {
    Supabase.instance.client.rpc(
      'get_daily_average_app_usage',
      params: {
        'p_hushh_id': AppLocalStorage.hushhId,
        'p_app_id': widget.app.appId,
        'p_interval': '7 days'
      },
    ).then((value) {
      averageAppUsage = value;
      setState(() {});
    });
    super.initState();
  }

  AppUsageInfo get app => widget.app;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.app.name,
            style: const TextStyle(fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: app.canConnect ?? false
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    ToastManager(Toast(
                            title: 'Coming Soon',
                            type: ToastificationType.info))
                        .show(context);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0XFFA342FF),
                          Color(0XFFE54D60),
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Connect ${app.name}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18),
                            ),
                            const Icon(
                              Icons.arrow_right_alt_sharp,
                              color: Colors.white,
                              size: 20,
                            )
                          ],
                        ),
                        const Text(
                          'Connect & earn 30 Hushh coins 💰',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                children: [
                  Image.network(
                    app.iconPath,
                    width: 36 * 1.8,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(app.name,
                            style: context.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis),
                        Text(
                          'Your time spent on ${app.name}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Daily average',
              style: context.titleLarge,
            ),
            Text(
              Utils().formatDuration(averageAppUsage?.toInt() ?? 0),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Text('Last 7 days'),
            const SizedBox(height: 26),
            FutureBuilder(
                future: Supabase.instance.client
                    .from('app_usage')
                    .select()
                    .eq('app_id', app.appId)
                    .eq('hushh_id', AppLocalStorage.hushhId ?? ""),
                builder: (context, state) {
                  return AppUsageBarChart(
                      allAppUsageData: state.data
                              ?.map((e) => AppUsageData.fromJson(e))
                              .toList() ??
                          []);
                })
          ],
        ),
      ),
    );
  }
}
