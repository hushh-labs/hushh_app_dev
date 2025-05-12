import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/shared_assets_receipts_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/brand_card_list_view.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/preference_card_list_view.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/components/file_preview.dart';
import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';
import 'package:hushh_app/app/shared/core/components/smooth_carousel_slider.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:path/path.dart' show extension;
import 'package:responsive_sizer/responsive_sizer.dart';

class CardAssetsImportPage extends StatefulWidget {
  final List<File> files;

  const CardAssetsImportPage({super.key, required this.files});

  @override
  State<CardAssetsImportPage> createState() => _CardAssetsImportPageState();
}

class _CardAssetsImportPageState extends State<CardAssetsImportPage> {
  final controller = sl<CardWalletPageBloc>();
  bool isUploading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.add(CardWalletInitializeEvent(context));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    File? file = widget.files.firstOrNull;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload to Hushh wallet'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    'FILE PREVIEW',
                    style: context.titleSmall?.copyWith(
                      color: const Color(0xFF737373),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.3,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 20.h,
                    child: InkWell(
                      onTap: () async {},
                      borderRadius: BorderRadius.circular(8),
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        strokeWidth: 1,
                        dashPattern: const [8],
                        color: const Color(0xFFE54D60),
                        radius: const Radius.circular(8),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (file == null)
                                const Center(
                                  child: Text(
                                    'No File Found!',
                                    style: TextStyle(color: Color(0xFF4A789C)),
                                  ),
                                )
                              else
                                FilePreview(width: 20.w, filePath: file.path)
                                    .preview()
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Center(
                    child: BlocBuilder(
                      bloc: controller,
                      builder: (context, state) {
                        if (state is InitializingState) {
                          return const Center(
                              child: CupertinoActivityIndicator());
                        } else if (state is InitializedState &&
                            (controller.allCards.isNotEmpty)) {
                          CardModel card = controller.allCards
                              .elementAt(
                                  controller.selectedShareScreenCardIndex)
                              .item2;
                          CardType cardType = controller.allCards
                              .elementAt(
                                  controller.selectedShareScreenCardIndex)
                              .item1;
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (cardType == CardType.preferenceCard)
                                PreferenceCardWidget(
                                    cardData: card,
                                    isDetailsScreen: false,
                                    userName:
                                        AppLocalStorage.user?.name ?? 'N/A')
                              else
                                BrandCardWidget(
                                    brand: card, isDetailsScreen: false),
                              const SizedBox(height: 32),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: HushhLinearGradientButton(
                                  text: 'Upload in ${card.brandName} card',
                                  height: 48,
                                  loader: isUploading,
                                  onTap: () async {
                                    if (file == null) return;
                                    String filePath = file.path;
                                    isUploading = true;
                                    setState(() {});
                                    sl<CardWalletPageBloc>().cardData = card;
                                    switch (extension(filePath).toLowerCase()) {
                                      case '.png':
                                      case '.jpg':
                                      case '.jpeg':
                                        sl<SharedAssetsReceiptsBloc>().add(
                                            ShareImagesVideosEvent(
                                                context,
                                                card, pop: false, files: [XFile(filePath)]));
                                    }
                                  },
                                  radius: 6,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Upload & earn 1 Hushh coin 🥳',
                                style: context.bodyMedium
                                    ?.copyWith(color: const Color(0xFF575757)),
                                textAlign: TextAlign.center,
                              )
                            ],
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            ),
            BlocBuilder(
                bloc: controller,
                builder: (context, state) {
                  if (controller.allCards.isEmpty) return const SizedBox();
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 25.h,
                      child: SmoothCarouselSlider(
                        itemCount: controller.allCards.length,
                        initialSelectedIndex:
                            controller.selectedShareScreenCardIndex,
                        itemExtent: 80,
                        selectedWidget: (index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  controller.allCards[index].item2.image),
                            )),
                        unSelectedWidget: (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                controller.allCards[index].item2.image),
                            onBackgroundImageError: (_, b) {},
                          ),
                        ),
                        onSelectedItemChanged: (index) {
                          controller.selectedShareScreenCardIndex = index;
                          setState(() {});
                        },
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
