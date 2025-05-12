import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/health_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/app_usage_data.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/app_usage_insights.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/bloc/settings_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/components/app_usage_card.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/pages/device_activity.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/utils_impl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tuple/tuple.dart';

class AppUsageInsightsComponent extends StatelessWidget {
  final bool fromHome;

  AppUsageInsightsComponent({super.key, this.fromHome = false});

  final controller = sl<SettingsPageBloc>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: BlocBuilder(
        bloc: controller,
        builder: (context, state) {
          bool showBlurAndAskForPermission =
              !AppLocalStorage.isAppUsagePermissionProvided;
          final colors = [
            const Color(0xFF29F6A4),
            const Color(0xFF3029F6),
            const Color(0xFFF6297B)
          ];
          return showBlurAndAskForPermission
              ? Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                            Colors.grey.shade50,
                            Colors.grey.shade300,
                            Colors.grey.shade50,
                          ])),
                      child: Column(
                        children: [
                          UsageCard(
                            title: 'Music',
                            apps: [],
                            hours: '12 hours',
                            percentage: 'Last week',
                            color: colors[2],
                          ),
                          SizedBox(height: 10),
                          UsageCard(
                            title: 'Games',
                            apps: [],
                            hours: '3.5 hours',
                            percentage: 'Last week',
                            color: colors[0],
                          ),
                          SizedBox(height: 10),
                          UsageCard(
                            title: 'Entertainment',
                            apps: const [],
                            hours: '1 hour',
                            percentage: 'Last week',
                            color: colors[1],
                          ),
                        ],
                      ).blurred(),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset('assets/lock_3d_icon.png', width: 64),
                            const SizedBox(height: 8),
                            Text(
                              'Insights Locked',
                              style: context.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF0e3470)),
                            ),
                            const SizedBox(height: 16),
                            Transform.scale(
                              scale: 0.9,
                              child: ElevatedButton(
                                onPressed: () async {
                                  List<AppUsageData> appUsages =
                                      await Utils().fetchAppUsage(
                                          Tuple2<int, String>(1,
                                              AppLocalStorage.hushhId ?? ""));
                                  controller.add(
                                      InsertMultipleAppUsagesEvent(appUsages));
                                },
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    foregroundColor: const Color(0xFFE51A5E)),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.perm_identity),
                                    SizedBox(width: 4),
                                    Text('Grant permission')
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Connect & earn $healthInsightsCoins Hushh coins 🤫',
                              style: context.bodyMedium,
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )
              : FutureBuilder(
                  future: getUserAppUsageSummary(),
                  builder: (context, state) {
                    List<AppUsageInsights>? appUsageInsights;
                    if (state.connectionState == ConnectionState.done) {
                      appUsageInsights = (state.data as List)
                          .map((e) => AppUsageInsights.fromJson(e))
                          .toList();
                    } else if (state.connectionState ==
                        ConnectionState.waiting) {
                      appUsageInsights = (sl<SettingsPageBloc>().appUsage)
                              ?.map((e) => AppUsageInsights.fromJson(e))
                              .toList() ??
                          [];
                    }

                    return Column(
                      children: List.generate(
                        appUsageInsights?.length ?? 0,
                        (index) => UsageCard(
                          title: appUsageInsights![index].categoryName,
                          apps: appUsageInsights[index].apps,
                          hours: Utils().formatDuration(
                              appUsageInsights[index].totalTimeSpent),
                          percentage: 'Last week',
                          color: [
                            const Color(0xFF29F6A4),
                            const Color(0xFF3029F6),
                            const Color(0xFFF6297B)
                          ][index],
                        ),
                      ),
                    );
                  });
        },
      ),
    );
  }
}
