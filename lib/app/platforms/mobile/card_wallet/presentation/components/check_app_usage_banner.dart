import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/app_usage_data.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/bloc/settings_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/pages/device_activity.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/utils_impl.dart';
import 'package:tuple/tuple.dart';

class CheckAppUsageBanner extends StatelessWidget {
  const CheckAppUsageBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: InkWell(
        overlayColor: MaterialStateProperty.all(Colors.white),
        onTap: () async {
          if (!AppLocalStorage.isAppUsagePermissionProvided) {
            List<AppUsageData> appUsages = await Utils().fetchAppUsage(
                Tuple2<int, String>(1, AppLocalStorage.hushhId ?? ""));
            sl<SettingsPageBloc>().add(InsertMultipleAppUsagesEvent(appUsages));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DeviceActivityPage()));
          }
        },
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Image.asset(
                'assets/app_usage_icon.png',
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Check App Usage',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'You can get insights on which app you use the most',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                      size: 16,
                    ),
                    SizedBox(width: 4)
                  ],
                ),
              ),
              // ElevatedButton(
              //   onPressed: () {},
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.white,
              //     foregroundColor: Colors.black
              //   ),
              //   child: const Text("Card Marketplace"),
              // )
            ],
          ),
        ),

        // child: Transform.scale(
        //   scale: 1.02,
        //   child: Container(
        //     width: double.infinity,
        //     child: SvgPicture.asset("assets/Makeyour.svg"),
        //   ),
        // ),
      ),
    );
  }
}
