import 'package:blur/blur.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/health.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/health_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HealthInsights extends StatefulWidget {
  const HealthInsights({Key? key}) : super(key: key);

  @override
  State<HealthInsights> createState() => _HealthInsightsState();
}

class _HealthInsightsState extends State<HealthInsights> {
  final HealthBloc controller = sl<HealthBloc>();

  @override
  void initState() {
    super.initState();
    if (AppLocalStorage.hasUserConnectedHealthInsights) {
      controller.add(FetchHealthDataEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HealthBloc, HealthState>(
      bloc: controller,
      builder: (context, state) {
        final bool isFetching = state is FetchingDataHealth ||
            state is FetchingRemoteHealthDataState;
        final bool showBlurAndAskForPermission =
            state is! DataReadyHealth && controller.healthDataMap.isEmpty;
        return Stack(
          children: [
            HealthInsightComponent(
              showBlurAndAskForPermission: showBlurAndAskForPermission,
            ).blurred(
                blur: showBlurAndAskForPermission ? 5 : 0,
                colorOpacity: showBlurAndAskForPermission ? 0.5 : 0),
            if (showBlurAndAskForPermission)
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
                          color: const Color(0xFF0e3470),
                        ),
                      ),
                      const SizedBox(height: 16),
                      isFetching
                          ? const CupertinoActivityIndicator()
                          : ElevatedButton.icon(
                              onPressed: () {
                                controller.add(FetchHealthDataEvent());
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                foregroundColor: const Color(0xFFE51A5E),
                              ),
                              icon: const Icon(Icons.perm_identity),
                              label: const Text('Grant permission'),
                            ),
                      const SizedBox(height: 8),
                      Text(
                        'Connect & earn $healthInsightsCoins Hushh coins 🤫',
                        style: context.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}

class HealthInsightComponent extends StatelessWidget {
  final bool showBlurAndAskForPermission;

  const HealthInsightComponent({
    Key? key,
    required this.showBlurAndAskForPermission,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HealthBloc controller = sl<HealthBloc>();

    // Extracting available health data types from the map
    final healthDataTypes = controller.gridAHealthDataTypes;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          GridView.builder(
            itemCount: healthDataTypes.length,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1),
            itemBuilder: (context, index) {
              final type = healthDataTypes[index];
              final typeName =
                  _getHealthDataTypeName(type); // Mapping enum to name
              final typeSlugName =
                  _getHealthDataTypeSlugName(type); // Mapping enum to name
              final typeData = controller.healthDataMap[type] ?? [];
              final latestData = typeData.isNotEmpty
                  ? typeData.last
                  : {"value": "--", "date_from": null, "date_to": null};
              final dt = latestData["dateTo"].runtimeType == String
                  ? DateTime.tryParse(
                      latestData["dateTo"] ?? latestData["date_to"] ?? "")
                  : latestData["dateTo"];

              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xffE7E7E7).withOpacity(0.4),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      typeName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff171717),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "${latestData["value"]?.toString().split('.')[0]} ", // Main value
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff171717),
                        ),
                        children: [
                          TextSpan(
                            text: typeSlugName, // Slug name
                            style: const TextStyle(
                              fontSize: 16, // Smaller font for the slug
                              fontWeight: FontWeight
                                  .w400, // Regular weight for the slug
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (dt != null)
                      Text(
                        "Updated: ${DateFormat('dd MMM, yyyy hh:mm aa').format(dt)}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          if (!showBlurAndAskForPermission)
            Container(
              width: 100.w,
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: const Color(0xffE7E7E7).withOpacity(0.4),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Steps",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff171717),
                    ),
                  ),
                  Text(
                    controller.healthDataMap[HealthDataType.STEPS]
                                ?.isNotEmpty ==
                            true
                        ? "${controller.healthDataMap[HealthDataType.STEPS]!.last["value"]} steps completed so far today."
                        : "0 steps completed so far today.",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff171717),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Helper function to map HealthDataType enums to user-friendly names
  String _getHealthDataTypeName(HealthDataType type) {
    switch (type) {
      case HealthDataType.STEPS:
        return "Steps";
      case HealthDataType.DISTANCE_WALKING_RUNNING:
        return "Distance";
      case HealthDataType.ACTIVE_ENERGY_BURNED:
        return "Active Energy Burned";
      case HealthDataType.BLOOD_GLUCOSE:
        return "Blood Glucose";
      case HealthDataType.HEART_RATE:
        return "Heart Rate";
      case HealthDataType.BLOOD_PRESSURE_SYSTOLIC:
        return "Blood Pressure";
      case HealthDataType.FLIGHTS_CLIMBED:
        return "Flights Climbed";
      default:
        return "Unknown Data";
    }
  }

  String _getHealthDataTypeSlugName(HealthDataType type) {
    switch (type) {
      case HealthDataType.STEPS:
        return "";
      case HealthDataType.DISTANCE_WALKING_RUNNING:
        return "km"; // Assuming distance in kilometers
      case HealthDataType.ACTIVE_ENERGY_BURNED:
        return "kcal"; // Kilocalories
      case HealthDataType.BLOOD_GLUCOSE:
        return "mg/dl"; // Blood glucose in milligrams per deciliter
      case HealthDataType.HEART_RATE:
        return "bpm"; // Beats per minute
      case HealthDataType.BLOOD_PRESSURE_SYSTOLIC:
        return "mmHg"; // Millimeters of mercury for blood pressure
      case HealthDataType.FLIGHTS_CLIMBED:
        return ""; // Flights of stairs climbed
      default:
        return ""; // Fallback for unknown data types
    }
  }
}
