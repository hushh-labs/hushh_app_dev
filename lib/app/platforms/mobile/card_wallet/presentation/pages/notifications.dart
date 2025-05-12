import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/notifications_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/notifications_app_bar.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/request_user_data_access_bottom_sheet.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:toastification/toastification.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final controller = sl<NotificationsBloc>();

  @override
  void initState() {
    controller.add(FetchNotificationsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const NotificationsAppBar(),
      body: BlocBuilder(
          bloc: controller,
          builder: (context, state) {
            return Padding(
                padding: const EdgeInsets.only(top: 25, right: 15, left: 15),
                child: controller.notifications == null
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : controller.noNotificationFound
                        ? const Center(
                            child: Text('No notifications found!'),
                          )
                        // ? Center(
                        //     child: ElevatedButton(
                        //       child: const Text('click'),
                        //       onPressed: () async {
                        //         await Supabase.instance.client.functions.invoke('notification-sender', body: {
                        //           'userId': 'f0b161e1-613b-4b15-8dee-1a753928fec4',
                        //           'notification': {
                        //             'id': 200,
                        //             'title': 'You\'ve got a new customer!',
                        //             'description': 'Tap now to find out more details',
                        //             'route': '/${AppRoutes.cardWallet.info.main}',
                        //             'status': 'success',
                        //             'notification_type': 'location',
                        //             'payload': {},
                        //           }
                        //         });
                        //       }
                        //     ),
                        //   )
                        : SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: 90.h,
                                  child: ListView.builder(
                                      itemCount:
                                          controller.notifications!.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Card(
                                          elevation: 2,
                                          child: ListTile(
                                            // onTap: () async {
                                            //   if (controller
                                            //           .notifications![index]
                                            //           .notificationType ==
                                            //       NotificationType
                                            //           .data_consent) {
                                            //     final qA =
                                            //         await showModalBottomSheet(
                                            //             isDismissible: true,
                                            //             enableDrag: true,
                                            //             backgroundColor:
                                            //                 Colors.transparent,
                                            //             isScrollControlled:
                                            //                 true,
                                            //             context: context,
                                            //             builder: (BuildContext
                                            //                     context) =>
                                            //                 RequestUserDataAccessBottomSheet(notification: controller
                                            //                     .notifications![index]));
                                            //   }
                                            // },
                                            leading: controller
                                                        .notifications![index]
                                                        .type ==
                                                    ToastificationType.success
                                                ? const Icon(
                                                    Icons.check_circle_outline,
                                                    color: Colors.green)
                                                : null,
                                            title: Text(controller
                                                .notifications![index].title),
                                            subtitle: controller
                                                        .notifications![index]
                                                        .description !=
                                                    null
                                                ? Text(controller
                                                    .notifications![index]
                                                    .description!)
                                                : null,
                                          ),
                                        );
                                      }),
                                ),
                              ],
                            ),
                          ));
          }),
    );
  }
}
