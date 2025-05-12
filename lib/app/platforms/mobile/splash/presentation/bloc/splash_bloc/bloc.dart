import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geofence_foreground_service/constants/geofence_event_type.dart';
import 'package:geofence_foreground_service/exports.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/location.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/fetch_agents_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/insert_user_agent_location_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/presentation/bloc/card_share_ecosystem_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/brand_location.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/generate_audio_transcription_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/splash/domain/usecases/fetch_all_nearby_brands_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/splash/domain/usecases/insert_user_brand_location_trigger_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/splash/domain/usecases/share_user_profile_and_requirements_with_agents_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/splash/domain/usecases/update_user_registration_token_use_case.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/ai_handler/ai_handler.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/geofence_service.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'events.dart';

part 'states.dart';

class SplashPageBloc extends Bloc<SplashPageEvent, SplashPageState> {
  // late VideoPlayerController videoController;
  // ChewieController? player;
  double visibility = 0;
  List<BrandLocation> nearbyBrandLocations = [];

  final geofenceService = GeofenceService();

  UserOnboardStatus get onboardStatus => AppLocalStorage.userOnboardStatus;

  final FetchAgentsUseCase fetchAgentsUseCase;
  final UpdateUserRegistrationTokenUseCase updateUserRegistrationTokenUseCase;
  final InsertUserAgentLocationUseCase insertUserAgentLocationUseCase;
  final FetchAllNearbyBrandsUseCase fetchAllNearbyBrandsUseCase;
  final InsertUserBrandLocationTriggerUseCase
      insertUserBrandLocationTriggerUseCase;
  final ShareUserProfileAndRequirementsWithAgentsUseCase
      shareUserProfileAndRequirementsWithAgentsUseCase;
  final GenerateAudioTranscriptionUseCase generateAudioTranscriptionUseCase;

  SplashPageBloc(
      this.fetchAgentsUseCase,
      this.updateUserRegistrationTokenUseCase,
      this.insertUserAgentLocationUseCase,
      this.fetchAllNearbyBrandsUseCase,
      this.insertUserBrandLocationTriggerUseCase,
      this.shareUserProfileAndRequirementsWithAgentsUseCase,
      this.generateAudioTranscriptionUseCase)
      : super(SplashPageInitialState()) {
    on<InitializeEvent>(initializeEvent);
    on<DisposeEvent>(disposeEvent);
    on<OnVideoEndEvent>(onVideoEndEvent);
    on<UpdateUserRegistrationTokenEvent>(updateUserRegistrationTokenEvent);
    on<InsertUserAgentNewLocationEvent>(insertUserAgentNewLocationEvent);
    on<FetchAndLoadAllBrandsInCityEvent>(fetchAndLoadAllBrandsInCityEvent);
    on<OnUserTriggerGeoFenceEvent>(onUserTriggerGeoFenceEvent);
    on<ShareUserProfileAndRequirementsWithAgentsEvent>(
        shareUserProfileAndRequirementsWithAgentsEvent);
  }

  Future<void> _initialize() async {
    await cancelAllNotifications();
    FlutterImageCompress.showNativeLog = true;
  }

  FutureOr<void> initializeEvent(
      InitializeEvent event, Emitter<SplashPageState> emit) async {
    emit(SplashPageLoadingState());
    bool isLoggedInAgentFlow =
        AppLocalStorage.isUserLoggedIn && !sl<HomePageBloc>().isUserFlow;
    await Future.wait([
      _initialize(),
      Future.delayed(Duration(milliseconds: isLoggedInAgentFlow ? 1200 : 1800))
      // _initializePlayer(emit),
    ]);
    if (isLoggedInAgentFlow) {
      try {
        final result = await fetchAgentsUseCase(uid: AppLocalStorage.hushhId);
        result.fold((l) => null, (r) {
          if (r.isNotEmpty) {
            print(r.first.toJson());
            AppLocalStorage.updateAgent(r.first);
          }
        });
      } catch(_) {}
    }
    emit(SplashPageLoadedState());
  }

  FutureOr<void> disposeEvent(
      DisposeEvent event, Emitter<SplashPageState> emit) {
    // videoController.dispose();
    // player?.dispose();
  }

  FutureOr<void> onVideoEndEvent(
      OnVideoEndEvent event, Emitter<SplashPageState> emit) {
    emit(SplashPageLoadedState());
  }

  FutureOr<void> updateUserRegistrationTokenEvent(
      UpdateUserRegistrationTokenEvent event,
      Emitter<SplashPageState> emit) async {
    final token = event.token ?? await FirebaseMessaging.instance.getToken();
    final hushhId = event.hushhId ?? AppLocalStorage.hushhId!;
    if (token != null) {
      final result = await updateUserRegistrationTokenUseCase(
        token: token,
        hushhId: hushhId,
      );
      result.fold((l) => null, (r) {});
    }
  }

  FutureOr<void> insertUserAgentNewLocationEvent(
      InsertUserAgentNewLocationEvent event,
      Emitter<SplashPageState> emit) async {
    final lastKnownLocation = event.position;
    insertUserAgentLocationUseCase(
        location: LocationModel(
            location:
                'POINT(${lastKnownLocation.latitude} ${lastKnownLocation.longitude})',
            createdAt: DateTime.now(),
            hushhId: event.hushhId));
  }

  FutureOr<void> fetchAndLoadAllBrandsInCityEvent(
      FetchAndLoadAllBrandsInCityEvent event,
      Emitter<SplashPageState> emit) async {
    final position = await Geolocator.getCurrentPosition();
    List<Placemark> placemarks = [];
    if (event.place == null) {
      placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
    }

    Placemark place =
        placemarks.firstOrNull ?? Placemark(locality: event.place);
    AppLocalStorage.updateLastSyncedPlaceName(
        place.locality ?? place.administrativeArea);
    print(
        "PLACE: ${place.locality ?? place.administrativeArea}, INSTALLED:${event.installedBrandCards.length}");
    final result = await fetchAllNearbyBrandsUseCase(
        place: place, installedBrandCards: event.installedBrandCards);
    result.fold((l) {
    }, (r) async {
      nearbyBrandLocations = r;
      bool started = await geofenceService.initialize(
        notificationTitle: 'Hushh Wallet Running...',
        notificationText: 'Monitoring location in background',
        channelId: 'com.hushhone.hushh',
      );
      if (started) {
        for (var location in nearbyBrandLocations) {
          await geofenceService.addGeofence(
            brandName: location.brandName!,
            brandId: location.brandId,
            brandLocationId: location.locationId!,
            coordinates: GeofenceUtils.generateCircularGeofence(
              center: LatLng(
                Angle.degree(location.location['latitude']),
                Angle.degree(location.location['longitude']),
              ),
              radiusInMeters: 40,
            ),
            radiusInMeters: 40,
          );
        }
      }
    });
  }

  FutureOr<void> onUserTriggerGeoFenceEvent(
      OnUserTriggerGeoFenceEvent event, Emitter<SplashPageState> emit) async {
    // final brandLocationId = event.brandLocationId;
    // final brandId = event.brandId;
    // final eventType = event.eventType;
    // await insertUserBrandLocationTriggerUseCase(
    //     userBrandLocationTriggerModel: UserBrandLocationTriggerModel(
    //   brandId: brandId,
    //   brandLocationId: brandLocationId,
    //   triggerType: eventType.name,
    //   userId: AppLocalStorage.hushhId!,
    // ));
    // switch (eventType) {
    //   case GeofenceEventType.enter:
    //     NotificationService().showNotification(
    //         0,
    //         'What are you looking to purchase?',
    //         'Tell us what are you looking for today.',
    //         {'zone_id': brandLocationId});
    //     break;
    //   case GeofenceEventType.exit:
    //     print('Exited $brandLocationId');
    //     break;
    //   case GeofenceEventType.dwell:
    //     print('Dwelling $brandLocationId');
    //     break;
    //   default:
    //     break;
    // }
  }

  FutureOr<void> shareUserProfileAndRequirementsWithAgentsEvent(
      ShareUserProfileAndRequirementsWithAgentsEvent event,
      Emitter<SplashPageState> emit) async {
    emit(SharingUserProfileAndRequirementsWithAgentsState());
    final result = await fetchAgentsUseCase(brandId: event.brandId);
    result.fold((l) {
    }, (r) async {
      String? text;
      if (r.isNotEmpty) {
        if (event.audioPath != null) {
          text = null;
          final supabase = Supabase.instance.client;
          // upload audio to supabase storage
          String path =
              "user-audio-requests-to-agents/${AppLocalStorage.hushhId}/${event.brandId}/${DateTime.now().toIso8601String()}.m4a";
          final data = File(event.audioPath!).readAsBytesSync();
          await supabase.storage.from('audios').uploadBinary(path, data);
          // get uploaded audio url
          String audioUrl = supabase.storage.from('audios').getPublicUrl(path);
          // call whisper api to transcribe url
          final result =
              await generateAudioTranscriptionUseCase(audioUrl: audioUrl);
          result.fold((l) => null, (r) {
            // assign the transcription to the result text
            text = r.text;
          });
        } else {
          text = event.query;
        }
      }
      if (text != null) {
        String systemPrompt = """You are an expert assistant helping to create concise, attention-grabbing titles based on user-provided text. The input text describes services or needs that users are looking for from agents. Your task is to summarize the input text into a short, clear, and engaging title, ideally 3-7 words long. The title should capture the essence of the user's request in a professional and appealing manner, suitable for display in a user interface.

Examples:
'Looking for a professional real estate agent to help find a 2BHK apartment in the city center.' -> 'Find 2BHK Apartment Agent'

'Need assistance with personal tax filing for this financial year.' -> 'Tax Filing Assistance Needed'

'Seeking a graphic designer to create a modern logo for my new startup.' -> 'Logo Design for Startup'

Now, generate a short and engaging title for this input text provided by user and make sure to only return the shorten summarized title in output:
""";
        final response = await AiHandler(systemPrompt).getChatResponse(text!);
        if(response != null) {
          final parsedEvent = extractSingleJSONFromString(response);
          text = parsedEvent;
        }
        Future.wait(List.generate(r.length, (index) {
          sl<CardShareEcosystemBloc>().add(CreateNewTaskAsUserForAgentEvent(
            query: text,
            brandId: event.brandId,
            cardId: event.cardId
          ));
          return shareUserProfileAndRequirementsWithAgentsUseCase(
              query: text!,
              agentId: r[index].hushhId!,
              cardId: event.cardId,
              senderHushhId: AppLocalStorage.hushhId!);
        }));
      }
    });

    emit(UserProfileAndRequirementsSharedWithAgentsState());
    Navigator.pop(event.context);
  }
}
