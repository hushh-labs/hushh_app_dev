import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/chat/presentation/pages/ai_chat.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:latlong2/latlong.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TravelInsights extends StatelessWidget {
  final bool fromHome;

  const TravelInsights({super.key, this.fromHome = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 14.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: FlutterMap(
          options: const MapOptions(
              initialCenter: LatLng(51.509364, -0.128928),
              initialZoom: 0,
              interactionOptions:
                  InteractionOptions(flags: ~InteractiveFlag.rotate)),
          children: [
            TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.hushhone.hushh',
                maxNativeZoom: 19),
            MarkerLayer(
                markers: sl<CardWalletPageBloc>()
                        .travelInsights
                        ?.map((e) => Marker(
                            point: LatLng(e.latitude, e.longitude),
                            width: 5,
                            child: const CircleAvatar(
                              backgroundColor: primaryColor,
                            )))
                        .toList() ??
                    [])
          ],
        ),
      ),
    );
  }
}
