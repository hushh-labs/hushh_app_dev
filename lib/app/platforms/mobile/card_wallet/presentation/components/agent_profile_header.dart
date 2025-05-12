import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/agent.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/agent_card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/brand_card_list_view.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/brand_sign_up_list_view.dart';
import 'package:hushh_app/app/platforms/mobile/chat/presentation/bloc/chat_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:readmore/readmore.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:screenshot/screenshot.dart';
import 'package:uuid/uuid.dart';

double topSpacing = 5.h;
double kChipHeight = 32;
double verticalPadding = 15;
double imageHeight = 30.w;
double basicInfoVerticalPadding = 10;
double actionButtonsVerticalPadding = 20;
double actionButtonHeight = 45;
double categoriesSpacing = 15;

class AgentProfileHeader extends StatelessWidget {
  final AgentModel agent;

  const AgentProfileHeader({super.key, required this.agent});

  bool get isAgent => sl<CardWalletPageBloc>().isAgent;

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      collapseMode: CollapseMode.parallax,
      background: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.symmetric(vertical: verticalPadding, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: topSpacing),
              CircleAvatar(
                radius: imageHeight / 2,
                backgroundImage: CachedNetworkImageProvider(agent.agentImage!),
              ),
              Padding(
                padding: EdgeInsets.only(top: basicInfoVerticalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      agent.agentName!,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff1C140D)),
                    ),
                    Text(
                      "${agent.agentBrand!.brandName.trim()}'s Agent",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xffC0C0C0)),
                    ),
                  ],
                ),
              ),
              if (agent.agentDesc?.isNotEmpty ?? false)
                Padding(
                  padding: EdgeInsets.only(top: basicInfoVerticalPadding),
                  child: ReadMoreText(
                    agent.agentDesc!,
                    trimMode: TrimMode.Line,
                    trimLines: 2,
                    trimCollapsedText: " read more",
                    trimExpandedText: " read less",
                    lessStyle: const TextStyle(color: Color(0xFFE51A5E)),
                    moreStyle: const TextStyle(color: Color(0xFFE51A5E)),
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff171717)),
                  ),
                ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: actionButtonsVerticalPadding),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          if (isAgent) {
                            Navigator.pushNamed(
                                context, AppRoutes.agentEditProfile,
                                arguments: AppLocalStorage.agent!);
                            return;
                          }
                          CardModel? selectedBrand = await showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              constraints: BoxConstraints(maxHeight: 80.h),
                              builder: (context) => BrandSignUpListView(
                                    brands:
                                        sl<CardWalletPageBloc>().brandCardList,
                                  ));
                          if (selectedBrand != null) {
                            ScreenshotController screenshotController =
                                ScreenshotController();
                            final data = await screenshotController
                                .captureFromWidget(Material(
                              child: BrandCardWidget(
                                brand: selectedBrand,
                                ignore: true,
                                isDetailsScreen: false,
                              ),
                            ));

                            Directory tempDir = await getTemporaryDirectory();
                            String tempPath = tempDir.path;

                            String filePath =
                                '$tempPath/${const Uuid().v4()}.png';
                            File file = File(filePath);
                            await file.writeAsBytes(data);
                            sl<CardWalletPageBloc>().cardData = selectedBrand;
                            sl<ChatPageBloc>().add(InitiateChatEvent(
                              context,
                              file,
                              sl<CardWalletPageBloc>().selectedAgent!.hushhId!,
                            ));
                          }
                        },
                        child: Container(
                          height: actionButtonHeight,
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                              color: const Color(0xffE7E7E7),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: Center(
                            child: Text(
                              isAgent ? "Edit Profile" : "Share card",
                              style: context.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (isAgent) {
                            Navigator.pushNamed(
                                context, AppRoutes.agentLookbook);
                          } else {
                            sl<AgentCardWalletPageBloc>()
                                .add(ContactAgentEvent(context));
                          }
                        },
                        child: Container(
                          height: actionButtonHeight,
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                              color: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: Center(
                            child: Text(
                              isAgent ? "View Lookbook" : "Contact agent",
                              style: context.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Text(
                "Categories",
                style: context.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Colors.black),
              ),
              SizedBox(height: categoriesSpacing),
              Wrap(
                spacing: 8.0,
                children: List<Widget>.from(agent.agentCategories
                        ?.take(3)
                        .map((data) {
                      return Chip(
                        label: Text(data.name),
                        side: BorderSide.none,
                        backgroundColor: Colors.grey.shade400.withOpacity(0.7),
                        labelStyle: const TextStyle(
                            color: Colors.black), // Customize label text color
                      );
                    }).toList() ??
                    [])
                  ..add((agent.agentCategories?.length ?? 0) > 3
                      ? Chip(
                          label: Text("+${agent.agentCategories!.length - 3}"),
                          side: BorderSide.none,
                          backgroundColor:
                              Colors.grey.shade400.withOpacity(0.7),
                          labelStyle: const TextStyle(
                              color:
                                  Colors.black), // Customize label text color
                        )
                      : const SizedBox()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
