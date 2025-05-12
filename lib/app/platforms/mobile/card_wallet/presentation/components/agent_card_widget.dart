import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/agent_sign_up_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/agent_card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/qr_code_widget.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/share_earn_bottom_sheet_agent.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:screenshot/screenshot.dart';
import 'package:uuid/uuid.dart';

class AgentCardWidget extends StatefulWidget {
  final bool ignore;

  const AgentCardWidget({super.key, this.ignore = false});

  @override
  State<AgentCardWidget> createState() => _AgentCardWidgetState();
}

class _AgentCardWidgetState extends State<AgentCardWidget> {
  final controller = sl<AgentCardWalletPageBloc>();
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    controller.cardKey = _globalKey;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: controller.cardKey,
      child: InkWell(
        onTap: () {
          if (AppLocalStorage.user != null) {
            Navigator.pushNamed(context, AppRoutes.agentProfile);
          }
        },
        child: BlocBuilder(
            bloc: sl<AgentCardWalletPageBloc>(),
            builder: (context, state) {
              return Container(
                height: 25.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 4,
                        blurRadius: 4,
                        offset: const Offset(0, 3))
                  ],
                ),
                child: Stack(
                  children: [
                    Container(
                      height: 25.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage("assets/agent_card.png"),
                                ),
                              ),
                            ),
                          ),
                          BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: .5, sigmaY: .5),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0),
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25.h,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 18),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(width: 8),
                                Expanded(
                                  child: BlocBuilder(
                                      bloc: controller,
                                      builder: (context, state) {
                                        return BlocBuilder(
                                            bloc: sl<AgentSignUpPageBloc>(),
                                            builder: (context, state) {
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        AppLocalStorage.agent
                                                                ?.agentName ??
                                                            "Daniel",
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      if (AppLocalStorage.agent
                                                              ?.agentApprovalStatus ==
                                                          AgentApprovalStatus
                                                              .approved)
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 4.0),
                                                          child: Icon(
                                                            Icons.verified,
                                                            size: 16,
                                                            color: Colors.blue,
                                                          ),
                                                        )
                                                    ],
                                                  ),
                                                  if (AppLocalStorage
                                                          .agent?.agentBrand !=
                                                      null)
                                                    Text(
                                                      '${AppLocalStorage.agent?.agentBrand!.brandName.trim()}\'s Agent',
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12),
                                                    )
                                                  else
                                                    const Text(
                                                      "Independent agent",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12),
                                                    )
                                                ],
                                              );
                                            });
                                      }),
                                ),
                                if (!widget.ignore &&
                                    AppLocalStorage.agent?.agentCard != null)
                                  InkWell(
                                    onTap: () async {
                                      sl<CardWalletPageBloc>().cardData =
                                          AppLocalStorage.agent?.agentCard;
                                      ScreenshotController
                                          screenshotController =
                                          ScreenshotController();
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child:
                                                    const CupertinoActivityIndicator(),
                                                // You can customize the dialog further if needed
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      final data = await screenshotController
                                          .captureFromWidget(const Material(
                                        child: AgentCardWidget(
                                          ignore: true,
                                        ),
                                      ));
                                      Navigator.pop(context);

                                      Directory tempDir =
                                          await getTemporaryDirectory();
                                      String tempPath = tempDir.path;

                                      String filePath =
                                          '$tempPath/${const Uuid().v4()}.png';
                                      File file = File(filePath);
                                      await file.writeAsBytes(data);

                                      showModalBottomSheet(
                                        isDismissible: true,
                                        enableDrag: true,
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (_context) {
                                          return ShareAndEarnBottomSheetAgent(
                                            file: file,
                                          );
                                        },
                                      );
                                    },
                                    child: SvgPicture.asset(
                                        'assets/share_button.svg'),
                                  )
                              ],
                            ),
                            Row(
                              mainAxisAlignment:
                                  AppLocalStorage.agent?.agentCard != null
                                      ? MainAxisAlignment.spaceBetween
                                      : MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (AppLocalStorage.agent?.agentCard != null)
                                  QrCodeWidget(
                                      brand: AppLocalStorage.agent!.agentCard!),
                                SvgPicture.asset('assets/hushhWhiteLogo.svg'),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
