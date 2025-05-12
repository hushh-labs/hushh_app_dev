import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/app_usage_info_ui.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/app_usage_insights.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/pages/device_activity_details.dart';
import 'package:hushh_app/app/shared/core/utils/utils_impl.dart';

class UsageCard extends StatelessWidget {
  final String title;
  final String hours;
  final String percentage;
  final Color color;
  final List<AppInfo> apps;

  const UsageCard({
    super.key,
    required this.title,
    required this.hours,
    required this.percentage,
    required this.color,
    required this.apps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style:
                    TextStyle(color: Utils().getTextColor(color), fontSize: 16),
              ),
              Text(
                hours,
                style: TextStyle(
                  color: Utils().getTextColor(color),
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                percentage,
                style: TextStyle(color: Utils().getTextColor(color)),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
                apps.length,
                (index) => Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DeviceActivityDetailsPage(
                                          app: AppUsageInfo(
                                              appId: apps[index].appId,
                                              iconPath: apps[index].iconUrl,
                                              name: apps[index].appName,
                                              time: ""))));
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 15,
                          child: CircleAvatar(
                            radius: 14,
                            backgroundImage: NetworkImage(apps[index].iconUrl),
                          ),
                        ),
                      ),
                    )),
          )
        ],
      ),
    );
  }
}
