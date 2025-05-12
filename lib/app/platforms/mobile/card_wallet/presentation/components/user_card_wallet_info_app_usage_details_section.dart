import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/app_usage_info_ui.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/app_usage_insights.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/components/app_usage_card.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/components/app_usage_grid_tile.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/pages/device_activity.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/pages/device_activity_all_apps.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:hushh_app/app/shared/core/utils/utils_impl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

class UserCardWalletInfoAppUsageDetailsSection extends StatefulWidget {
  final CardModel cardData;

  const UserCardWalletInfoAppUsageDetailsSection(
      {super.key, required this.cardData});

  @override
  State<UserCardWalletInfoAppUsageDetailsSection> createState() =>
      _UserCardWalletInfoAppUsageDetailsSectionState();
}

class _UserCardWalletInfoAppUsageDetailsSectionState
    extends State<UserCardWalletInfoAppUsageDetailsSection> {
  List<AppUsageInfo>? apps;

  @override
  void initState() {
    Supabase.instance.client.rpc(
      'get_app_usage_by_user',
      params: {
        'p_hushh_id': AppLocalStorage.hushhId,
      },
    ).then((value) {
      List data = value as List;
      for (var item in data) {
        apps ??= [];
        apps?.add(AppUsageInfo(
            appId: item['app_id'],
            iconPath: item['icon_url'],
            name: (item['app_name'] as String).split(':').first.capitalize(),
            time: Utils().formatDuration(item['total_usage'])));
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          StreamBuilder(
              stream: getUserAppUsageSummaryStream(),
              builder: (context, state) {
                List<AppUsageInsights>? appUsageInsights;
                if (state.data != null) {
                  appUsageInsights = (state.data as List)
                      .map((e) => AppUsageInsights.fromJson(e))
                      .toList();
                }

                return Padding(
                  padding: EdgeInsets.only(
                      bottom: (appUsageInsights?.isNotEmpty ?? false) ? 16 : 0),
                  child: Column(
                    children: List.generate(
                      appUsageInsights?.length ?? 0,
                      (index) => UsageCard(
                        title: appUsageInsights![index].categoryName,
                        apps: appUsageInsights[index].apps,
                        hours: Utils().formatDuration(
                            appUsageInsights[index].totalTimeSpent),
                        percentage: 'Last 24 hours',
                        color: [
                          const Color(0xFF29F6A4),
                          const Color(0xFF3029F6),
                          const Color(0xFFF6297B)
                        ][index],
                      ),
                    ),
                  ),
                );
              }),
          ListTile(
            contentPadding: EdgeInsets.zero,
            onTap: () {
              ToastManager(
                      Toast(title: "Coming Soon", type: ToastificationType.info))
                  .show(context);
            },
            title: const Text(
              'Check Vibes With Friends',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Text(
              'See how your time spent compares to friends',
              style: TextStyle(color: Color(0xFF61758A)),
            ),
            trailing: SvgPicture.asset('assets/right_arrow.svg'),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'App Usage',
                style: context.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const DeviceActivityAllAppsPage()));
                },
                child: Text('See all',
                    style: context.bodyMedium?.copyWith(
                        color: Colors.blue,
                        decoration: TextDecoration.underline)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: apps?.length ?? 0,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) =>
                  AppUsageGridTile(app: apps![index])),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
