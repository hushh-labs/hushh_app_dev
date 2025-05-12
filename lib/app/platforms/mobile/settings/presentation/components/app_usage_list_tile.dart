import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/app_usage_info_ui.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/pages/device_activity_details.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';

class AppUsageListTile extends StatelessWidget {
  final AppUsageInfo app;
  final bool isAppConnected;

  const AppUsageListTile(
      {super.key, required this.app, required this.isAppConnected});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DeviceActivityDetailsPage(app: app)));
      },
      title: Row(
        children: [
          Expanded(
            child: Text(app.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                )),
          ),
          const SizedBox(width: 8),
          if (app.canConnect ?? false)
            if (isAppConnected)
              const ConnectedBadge()
            else
              const NotConnectBadge(),
        ],
      ),
      subtitle: Text(app.categoryName ?? ""),
      leading: Image.network(
        app.iconPath,
        width: 36,
      ),
      trailing: Text(app.time),
    );
  }
}

class ConnectedBadge extends StatelessWidget {
  const ConnectedBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [
          Color(0XFFA342FF),
          Color(0XFFE54D60),
        ]),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        'CONNECTED',
        style: context.bodySmall?.copyWith(color: Colors.white),
      ),
    );
  }
}

class NotConnectBadge extends StatelessWidget {
  const NotConnectBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade500,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        'NOT CONNECTED',
        style: context.bodySmall?.copyWith(color: Colors.white),
      ),
    );
  }
}
