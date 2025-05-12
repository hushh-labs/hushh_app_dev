import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/app_usage_info_ui.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/pages/device_activity_details.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';

class AppUsageGridTile extends StatelessWidget {
  final AppUsageInfo app;

  const AppUsageGridTile({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DeviceActivityDetailsPage(app: app)));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFDBE0E5))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Image.network(app.iconPath)),
            const SizedBox(height: 10),
            Text(app.name,
                style: context.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ), maxLines: 1),
            Text(app.time),
          ],
        ),
      ),
    );
  }
}
