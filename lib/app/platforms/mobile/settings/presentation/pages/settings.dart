// app/platforms/mobile/settings/presentation/pages/settings.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/settings/data/models/app_usage_data.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/bloc/settings_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/components/chrome_extension_bottom_sheet.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/components/logout_alert_dialog.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/components/settings_app_bar.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/pages/device_activity.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/utils_impl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tuple/tuple.dart';
import 'package:wiredash/wiredash.dart';

class Section {
  final String heading;
  final List<SectionItem> items;

  Section({required this.heading, required this.items});
}

class SectionItem {
  final String label;
  final bool showArrow;
  final VoidCallback? onTap;

  SectionItem({required this.label, this.onTap, this.showArrow = true});
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final controller = sl<SettingsPageBloc>();

  @override
  void initState() {
    controller.add(IsUserUsingChromeExtensionEvent());
    controller.add(CheckForAnyDeviceActivityDataStoredInDbEvent());
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SettingsAppBar(),
      body: BlocBuilder(
          bloc: controller,
          builder: (context, state) {
            final sections = defaultSections;
            return Padding(
              padding: const EdgeInsets.all(15.5),
              child: SingleChildScrollView(
                child: Column(
                  children: sections.map((section) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              section.heading,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color(0xff8A8A8A),
                                fontSize: 12,
                              ),
                            ),
                          ),
                          ...section.items.map((item) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: InkWell(
                                onTap: item.onTap ?? () {},
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  width: 90.w,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 19.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            item.label,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        if (item.showArrow)
                                          SvgPicture.asset(
                                            "assets/rightArrow.svg",
                                            color: Colors.black,
                                            width: 18,
                                            height: 18,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          }),
    );
  }

  List<Section> get defaultSections => [
        Section(
          heading: 'GENERAL',
          items: [
            SectionItem(
              label: 'Permissions',
              onTap: () => Navigator.pushNamed(context, AppRoutes.permissions),
            ),
          ],
        ),
        // if (sl<CardWalletPageBloc>().isUser)
        //   Section(
        //     heading: 'CHROME EXTENSION',
        //     items: [
        //       if (!(AppLocalStorage.user?.isHushhExtensionUser ?? false))
        //         SectionItem(
        //           label: 'Connect to chrome extension',
        //           onTap: () => showModalBottomSheet(
        //             backgroundColor: Colors.white,
        //             constraints: BoxConstraints(maxHeight: 70.h),
        //             context: context,
        //             isDismissible: true,
        //             builder: (context) => ChromeExtensionBottomSheet(
        //               onScanned: (_) {},
        //             ),
        //           ),
        //         )
        //       else
        //         SectionItem(
        //           label: 'View your Browsing Analytics',
        //           onTap: () => Navigator.pushNamed(
        //               context, AppRoutes.browsingAnalytics,
        //               arguments: AppLocalStorage.hushhId),
        //         ),
        //     ],
        //   ),
        // if (Platform.isAndroid && sl<CardWalletPageBloc>().isUser)
        //   Section(
        //     heading: 'DEVICE ACTIVITY',
        //     items: [
        //       if (!AppLocalStorage.isAppUsagePermissionProvided)
        //         SectionItem(
        //           label: 'Device Activity',
        //           onTap: () async {
        //             List<AppUsageData> appUsages = await Utils.fetchAppUsage(
        //                 Tuple2<int, String>(1, AppLocalStorage.hushhId ?? ""));
        //             controller.add(InsertMultipleAppUsagesEvent(appUsages));
        //           },
        //         )
        //       else
        //         SectionItem(
        //           label: 'View your Device Activity',
        //           onTap: () => Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                   builder: (context) => const DeviceActivityPage())),
        //         ),
        //     ],
        //   ),
        Section(
          heading: 'HELP',
          items: [
            SectionItem(
              label: 'Send Feedback',
              onTap: () => Wiredash.of(context).show(
                  options: WiredashFeedbackOptions(
                      collectMetaData: (metaData) => metaData
                        ..userEmail = AppLocalStorage.user?.email
                        ..userId = AppLocalStorage.hushhId)),
            ),
            SectionItem(
              label: 'Delete my Account',
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.deleteAccount),
            ),
            SectionItem(
              label: 'Logout',
              onTap: () => showDialog(
                context: context,
                builder: (BuildContext _context) {
                  return LogoutAlertDialog(
                    context: context,
                  );
                },
              ),
            ),
          ],
        ),
        Section(
          heading: 'ABOUT',
          items: [
            SectionItem(
              showArrow: false,
              label: sl<HomePageBloc>().isUserFlow
                  ? 'Build version: 1.0.0(71) / Release date: 27-04-2024'
                  : 'Build version: 1.0.0(71) / Release date: 27-04-2024',
            ),
          ],
        ),
      ];
}
