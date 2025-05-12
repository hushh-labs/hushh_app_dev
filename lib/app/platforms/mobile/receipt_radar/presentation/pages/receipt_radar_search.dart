import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/data/models/receipt_radar_history.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/bloc/receipt_radar_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/components/receipt_filters/filters_bottom_sheet.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/components/receipt_radar_app_bar.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/components/receipt_radar_button.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/components/receipt_radar_text_field.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/pages/receipt_radar_utils.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tuple/tuple.dart';

class ReceiptRadarSearchArgs {
  final EmailProvider provider;

  ReceiptRadarSearchArgs({required this.provider});
}

class ReceiptRadarSearchPage extends StatefulWidget {
  const ReceiptRadarSearchPage({super.key});

  @override
  State<ReceiptRadarSearchPage> createState() => _ReceiptRadarSearchPageState();
}

class _ReceiptRadarSearchPageState extends State<ReceiptRadarSearchPage> {
  bool isNotificationsAllowed = false;
  final controller = TextEditingController();

  @override
  void initState() {
    requestPermission();
    super.initState();
  }

  requestPermission() {
    Permission.notification.isDenied.then((value) {
      if (value) {
        Permission.notification.request().then((value) {
          if (value.isDenied) {
            isNotificationsAllowed = false;
          } else {
            isNotificationsAllowed = true;
          }
          setState(() {});
        });
      } else {
        isNotificationsAllowed = true;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final args =
        ModalRoute.of(context)!.settings.arguments! as ReceiptRadarSearchArgs;
    final provider = args.provider;
    return Scaffold(
      appBar: const ReceiptRadarAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Text(
                'Search Receipts',
                style: textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "You can either search a Pdf or receipt or if you want we can sync them all up automatically for you ",
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              ReceiptRadarTextField(
                  controller: controller,
                  showFilter: false,
                  filtersPageType: FiltersPageType.individual,
                  onChanged: (_) {
                    setState(() {});
                  }),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  if (!isNotificationsAllowed) {
                    requestPermission();
                  }
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IgnorePointer(
                      ignoring: true,
                      child: Checkbox(
                        value: isNotificationsAllowed,
                        onChanged: (_) {},
                        shape: const CircleBorder(),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        'Allow notifications and we\'ll notify you when finished 🕘',
                        style:
                            textTheme.titleSmall?.copyWith(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              if (controller.text.trim().isNotEmpty) ...[
                ReceiptRadarButton(
                  text: 'Sync ${controller.text} receipts',
                  filled: true,
                  onTap: () async {
                    Tuple2<String?, String?>? data =
                        await sl<ReceiptRadarUtils>().googleAuth();
                    if (data != null) {
                      sl<ReceiptRadarBloc>().add(UpdateReceiptRadarHistoryEvent(
                          ReceiptRadarHistory(
                              accessToken: data.item2!,
                              email: data.item1!,
                              hushhId: AppLocalStorage.hushhId!)));
                    }
                    Navigator.pop(context);
                    Navigator.pop(context);
                    ToastManager(Toast(
                            title: 'Running receipt radar...',
                            description:
                                'We are syncing all your receipts in the background and will notify you once the processing is done'))
                        .show(context, alignment: Alignment.bottomRight);
                  },
                ),
                const SizedBox(height: 16),
              ],
              ReceiptRadarButton(
                text: 'Sync all receipts automatically',
                onTap: () async {
                  Tuple2<String?, String?>? data =
                      await sl<ReceiptRadarUtils>().googleAuth();
                  if (data != null) {
                    ToastManager(Toast(
                            title: 'Running receipt radar...',
                            description:
                                'We are syncing all your receipts in the background and will notify you once the processing is done'))
                        .show(context, alignment: Alignment.bottomRight);
                    sl<ReceiptRadarBloc>().add(UpdateReceiptRadarHistoryEvent(
                        ReceiptRadarHistory(
                            accessToken: data.item2,
                            email: data.item1!,
                            hushhId: AppLocalStorage.hushhId!)));
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
