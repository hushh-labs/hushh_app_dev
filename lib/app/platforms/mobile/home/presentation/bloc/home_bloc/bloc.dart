import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:hushh_app/currency_converter/currency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:hushh_app/app/platforms/mobile/auth/data/models/countriesModel.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/update_agent_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/update_user_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/hushh_story_editor/vs_story_designer.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/utils_impl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ip_country_lookup/ip_country_lookup.dart';
import 'package:ip_country_lookup/models/ip_country_data_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'events.dart';

part 'states.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final UpdateUserUseCase updateUserUseCase;
  final UpdateAgentUseCase updateAgentUseCase;

  HomePageBloc(this.updateUserUseCase, this.updateAgentUseCase)
      : super(HomePageInitialState()) {
    on<UpdateHomeScreenIndexEvent>(updateHomeScreenIndexEvent);
    on<ConnectChromeExtension>(connectChromeExtension);
    on<UpdateUserProfileEvent>(updateUserProfileEvent);
    on<UpdateAgentProfileEvent>(updateAgentProfileEvent);
  }

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Currency currency = defaultCurrency;
  Country country = defaultCountry;
  Entity entity = defaultEntity;
  int currentIndex = 0;

  bool get isUserFlow => entity == Entity.user;

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, so don't continue
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, so don't continue
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied, so don't continue
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can continue accessing the position
    return await Geolocator.getCurrentPosition();
  }

  Future updateLocation() async {
    try {
      // Position position = await getCurrentLocation();
      // List<Placemark> placemarks =
      //     await placemarkFromCoordinates(position.latitude, position.longitude);
      // String? countryIsoCode = placemarks.first.isoCountryCode;
      IpCountryData countryData = await IpCountryLookup().getIpLocationData();
      String? countryIsoCode = countryData.country_code;
      if (countryIsoCode?.isNotEmpty ?? false) {
        currency = Utils().getCurrencyFromCountrySymbol(countryIsoCode) ??
            defaultCurrency;
        country = countries
                .where((element) => countryIsoCode == element.code)
                .firstOrNull ??
            defaultCountry;
      }
    } catch (_) {}
  }

  FutureOr<void> updateHomeScreenIndexEvent(
      UpdateHomeScreenIndexEvent event, Emitter<HomePageState> emit) {
    emit(ActiveScreenUpdatingState());
    currentIndex = event.index;
    if (event.index == 0) {
      sl<CardWalletPageBloc>().add(CardWalletInitializeEvent(event.context));
    }
    emit(ActiveScreenUpdatedState(event.index));
  }

  FutureOr<void> connectChromeExtension(
      ConnectChromeExtension event, Emitter<HomePageState> emit) {
    final result = event.data;
    // if (result.toString().substring(0, 8) == "chrom-ex") {
    //   try {
    //     FirebaseDatabase.instance
    //         .ref()
    //         .child('qrcodes/${result.toString().substring(8, result!.length)}')
    //         .update({
    //       "userid": AppLocalStorage.hushhId,
    //       "name": sl<CardWalletPageBloc>().user?.name,
    //       "profile_image": sl<CardWalletPageBloc>().user?.avatar,
    //     }).then((value) {
    //       print("db run");
    //     });
    //   } catch (e) {
    //     print(e);
    //     print("its rtb error");
    //   }
    // } else {
    //   ToastManager(
    //           Toast(title: "Invalid QRCode", type: ToastificationType.error))
    //       .show(event.context);
    // }
    // Navigator.pop(event.context);
  }

  FutureOr<void> updateUserProfileEvent(
      UpdateUserProfileEvent event, Emitter<HomePageState> emit) async {
    Future<Uint8List> generateImage(prompt) async {
      final response = await post(
          Uri.parse(
              'https://rpmzykoxqnbozgdoqbpc.supabase.co/functions/v1/generate-image'),
          body: jsonEncode({'prompt': prompt}),
          headers: {'Content-Type': 'application/json'});
      return response.bodyBytes;
    }

    final supabase = Supabase.instance.client;
    Future<String> uploadImage(Uint8List data) async {
      String path =
          "user/${AppLocalStorage.hushhId}/profiles/${DateTime.now().toIso8601String()}.png";

      await supabase.storage.from('profiles').uploadBinary(path, data);

      String url = supabase.storage.from('profiles').getPublicUrl(path);
      return url;
    }

    String? getImage() {
      if (AppLocalStorage.user?.dob?.isEmpty ?? true) {
        return null;
      }
      String keyword = 'normal';
      DateTime today = DateTime.now();
      DateTime dob = DateFormat('yyyy-mm-dd').parse(AppLocalStorage.user!.dob!);
      int age = today.year - dob.year;
      if (today.month < dob.month ||
          (today.month == dob.month && today.day < dob.day)) {
        age--;
      }
      if (age < 20) {
        keyword = 'young';
      } else if (age < 25) {
        keyword = 'genz';
      } else if (age < 50) {
        keyword = 'normal';
      } else if (age < 60) {
        keyword = 'normal';
      } else if (age < 70) {
        keyword = 'older';
      }
      String path = "dummy_profiles/$keyword.png";
      String url = supabase.storage.from('dump').getPublicUrl(path);
      return url;
    }

    String? hushhId = AppLocalStorage.hushhId;
    String? generatedAvatarImageUrl;
    if (hushhId != null) {
      emit(UpdatingProfileImageState());
      // String prompt =
      //     "Generate a profile image for a user. User is 20 male. Generate a modern, genz profile image.";
      // final data = await generateImage(prompt);
      // generatedAvatarImageUrl = await uploadImage(data);
      if (event.bytes != null) {
        generatedAvatarImageUrl = await uploadImage(event.bytes!);
      } else {
        generatedAvatarImageUrl = getImage();
      }
      if (generatedAvatarImageUrl != null) {
        final user =
            AppLocalStorage.user!.copyWith(avatar: generatedAvatarImageUrl);
        await updateUserUseCase(uid: hushhId, user: user);
        AppLocalStorage.updateUser(user);
      }
      emit(ProfileImageUpdatedState());
    }
  }

  FutureOr<void> updateAgentProfileEvent(
      UpdateAgentProfileEvent event, Emitter<HomePageState> emit) async {
    final supabase = Supabase.instance.client;
    Future<String> uploadImage(Uint8List data) async {
      String path =
          "agent/${AppLocalStorage.hushhId}/profiles/${DateTime.now().toIso8601String()}.png";

      await supabase.storage.from('profiles').uploadBinary(path, data);

      String url = supabase.storage.from('profiles').getPublicUrl(path);
      return url;
    }

    String? hushhId = AppLocalStorage.hushhId;
    String imageUrl;
    if (hushhId != null) {
      emit(UpdatingProfileImageState());
      imageUrl = await uploadImage(event.bytes);
      final agent = AppLocalStorage.agent!.copyWith(agentImage: imageUrl);
      await updateAgentUseCase(agent: agent);
      AppLocalStorage.updateAgent(agent);
      emit(ProfileImageUpdatedState());
    }
  }
}
