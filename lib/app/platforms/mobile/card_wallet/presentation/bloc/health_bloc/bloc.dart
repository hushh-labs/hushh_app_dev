import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/health.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/fetch_remote_health_data_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/insert_health_data_use_case.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:permission_handler/permission_handler.dart';

part 'events.dart';

part 'states.dart';

class HealthBloc extends Bloc<HealthEvent, HealthState> {
  final InsertHealthDataUseCase insertHealthDataUseCase;
  final FetchRemoteHealthDataUseCase fetchRemoteHealthDataUseCase;

  HealthBloc(
    this.insertHealthDataUseCase,
    this.fetchRemoteHealthDataUseCase,
  ) : super(HealthInitialState()) {
    on<FetchHealthDataEvent>(fetchHealthDataEvent);
    on<InsertHealthDataEvent>(insertHealthDataEvent);
    on<FetchRemoteHealthDataEvent>(fetchRemoteHealthDataEvent);
  }

  Map<HealthDataType, List<Map<String, dynamic>>> healthDataMap = {};
  List<HealthDataType> healthDataTypes = [];
  List<HealthDataType> gridAHealthDataTypes = [
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.BLOOD_GLUCOSE,
    HealthDataType.HEART_RATE,
    HealthDataType.BLOOD_PRESSURE_SYSTOLIC
  ];
  List<HealthDataAccess> permissions = [];
  bool healthGrantedStatus = false;

  FutureOr<void> fetchHealthDataEvent(
      FetchHealthDataEvent event, Emitter<HealthState> emit) async {
    emit(FetchingDataHealth());

    await _configureHealthPermissions();
    healthGrantedStatus = await _requestHealthPermissions();

    if (healthGrantedStatus) {
      await _fetchHealthData();
      if (event.refresh) {
        ToastManager(Toast(
                title: 'Health data updated!',
                description:
                    'We have updated the health data to today\'s data'))
            .show(event.context!);
      }
      emit(DataReadyHealth());
    } else {
      emit(DataNotFetchedHealth());
    }
  }

  Future<void> _configureHealthPermissions() async {
    if (Platform.isAndroid) {
      healthDataTypes = [
        HealthDataType.STEPS,
        // HealthDataType.DISTANCE_WALKING_RUNNING,
        HealthDataType.ACTIVE_ENERGY_BURNED,
        HealthDataType.BLOOD_GLUCOSE,
        HealthDataType.HEART_RATE,
        HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
        // HealthDataType.FLIGHTS_CLIMBED,
      ];
      permissions = List.filled(healthDataTypes.length, HealthDataAccess.READ);
    } else if (Platform.isIOS) {
      healthDataTypes = [
        HealthDataType.STEPS,
        HealthDataType.DISTANCE_WALKING_RUNNING,
        HealthDataType.ACTIVE_ENERGY_BURNED,
        HealthDataType.BLOOD_GLUCOSE,
        HealthDataType.HEART_RATE,
        HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
        HealthDataType.FLIGHTS_CLIMBED,
      ];
      permissions = List.filled(healthDataTypes.length, HealthDataAccess.READ);
    }
  }

  Future<bool> _requestHealthPermissions() async {
    Health health = Health();
    health.configure();
    if (Platform.isAndroid) {
      await Permission.activityRecognition.request();
      await Permission.location.request();
    }
    return await health.requestAuthorization(healthDataTypes,
        permissions: permissions);
  }

  Future<void> _fetchHealthData() async {
    Health health = Health();
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    try {
      List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
        startTime: midnight,
        endTime: now,
        types: healthDataTypes,
      );

      // Initialize map entries for each HealthDataType
      for (var type in healthDataTypes) {
        healthDataMap[type] = [];
      }

      for (var data in healthData) {
        print(data.toJson());

        // Extract required data
        final value = data.value.toJson()['numeric_value'] ?? 0.0;
        final type = data.type;

        // Check if the type exists in the map
        if ((healthDataMap[type]?.isEmpty ?? true)) {
          // Initialize with the first entry
          healthDataMap[type] = [
            {
              "dateFrom": data.dateFrom,
              "dateTo": data.dateTo,
              "value": value,
            }
          ];
        } else {
          // Update the existing entry for this type
          var aggregatedData = healthDataMap[type]![0];

          // Update the sum
          aggregatedData["value"] += value;

          // Update dateFrom (minimum date)
          aggregatedData["dateFrom"] = data.dateFrom
              .isBefore(aggregatedData["dateFrom"])
              ? data.dateFrom
              : aggregatedData["dateFrom"];

          // Update dateTo (maximum date)
          aggregatedData["dateTo"] = data.dateTo
              .isAfter(aggregatedData["dateTo"])
              ? data.dateTo
              : aggregatedData["dateTo"];
        }
      }

      add(InsertHealthDataEvent(healthDataMap));

      log("Health Data Map: $healthDataMap");
    } catch (e) {
      log("Error fetching health data: $e");
    }
  }

  FutureOr<void> insertHealthDataEvent(
      InsertHealthDataEvent event, Emitter<HealthState> emit) async {
    emit(InsertingHealthDataState());
    final result = await insertHealthDataUseCase(data: event.data);
    result.fold((l) => null, (r) {
      emit(HealthDataInsertedState());
    });
  }

  FutureOr<void> fetchRemoteHealthDataEvent(
      FetchRemoteHealthDataEvent event, Emitter<HealthState> emit) async {
    emit(FetchingRemoteHealthDataState());
    final result =
        await fetchRemoteHealthDataUseCase(hushhId: AppLocalStorage.hushhId!);

    result.fold(
      (l) => emit(RemoteHealthDataFetchFailedState()),
      (r) {
        healthDataMap = r;
        emit(RemoteHealthDataFetchedState());
      },
    );
  }
}
