import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:http/http.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/shared_asset.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/shared_assets_receipts_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/upload_your_vibe_bottom_sheet.dart';
import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uuid/uuid.dart';

class UserCardWalletInfoUploadsSection extends StatefulWidget {
  final CardModel cardData;

  const UserCardWalletInfoUploadsSection({super.key, required this.cardData});

  @override
  State<UserCardWalletInfoUploadsSection> createState() =>
      _UserCardWalletInfoUploadsSectionState();
}

class _UserCardWalletInfoUploadsSectionState
    extends State<UserCardWalletInfoUploadsSection> {
  final controller = sl<SharedAssetsReceiptsBloc>();

  List<SharedAsset>? get assets => controller.fileDataAssets;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: controller,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: assets?.isEmpty ?? true
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/uploads_placeholder.png',
                            width: 60.w,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Upload and store your images here for sellers and Hushh to understand your preferences better',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Color(0xFF939393)),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: HushhLinearGradientButton(
                              text: 'Upload Images/Documents',
                              onTap: () {
                                sl<CardWalletPageBloc>().cardData =
                                    widget.cardData;
                                showModalBottomSheet(
                                  isDismissible: true,
                                  enableDrag: true,
                                  // constraints: BoxConstraints(maxHeight: 49.h),
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (_context) {
                                    return UploadYourVibeBottomSheet(
                                      cardData: widget.cardData,
                                      context: context,
                                    );
                                  },
                                );
                              },
                              height: 46,
                              radius: 5,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : GridView.custom(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    childrenDelegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final asset = assets![index];
                        return FocusedMenuHolder(
                          openWithTap: false,
                          menuItems: <FocusedMenuItem>[
                            FocusedMenuItem(
                                title: Text('View'),
                                trailingIcon: const Icon(Icons.open_in_new),
                                onPressed: () async {}),
                            FocusedMenuItem(
                                title: const Text("Share"),
                                trailingIcon: const Icon(Icons.share),
                                onPressed: () async {
                                  // final bytes = receipt.bytes;
                                  // if (bytes == null) {
                                  //   Share.share(receipt.body ?? "");
                                  // } else {
                                  //   final directory = await getTemporaryDirectory();
                                  //   final path = "${directory.path}/${receipt.name}";
                                  //   final file = File(path);
                                  //   await file.writeAsBytes(bytes);
                                  //   XFile xfile = new XFile(path);
                                  //   await Share.shareXFiles([xfile]);
                                  // }
                                }),
                            FocusedMenuItem(
                                backgroundColor: Colors.red,
                                title: const Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.white),
                                ),
                                trailingIcon: const Icon(Icons.delete,
                                    color: Colors.white),
                                onPressed: () {
                                  controller.add(
                                      DeleteSharedAssetEvent(asset, context));
                                }),
                          ],
                          onPressed: () {
                            onPreview(
                              asset.fileType!,
                              asset.path!,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    border: Border.all(color: Colors.grey),
                                    image: controller.isNotImage(index)
                                        ? null
                                        : DecorationImage(
                                            fit: BoxFit.cover,
                                            image: CachedNetworkImageProvider(
                                              (asset.type == "other_assets"
                                                  ? asset.thumbnail
                                                  : asset.path)!,
                                            ),
                                          ),
                                  ),
                                  child: controller.isNotImage(index)
                                      ? Center(
                                          child: Text(
                                            asset.fileType?.toUpperCase() ??
                                                'FILE',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: assets?.length ?? 0,
                      findChildIndexCallback: (Key key) {
                        if (key is ValueKey<int>) {
                          return key.value;
                        }
                        return null;
                      },
                    ),
                  ),
          );
        });
  }

  void onLocalPreview(Uint8List fileData) async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;

      String filePath = '$tempPath/${const Uuid().v4()}.pdf';
      File file = File(filePath);
      await file.writeAsBytes(fileData);

      await OpenFilex.open(filePath);
    } catch (e) {}
  }

  void onPreview(String fileType, String url) async {
    Uint8List? bytes;
    if (fileType == 'png' || fileType == 'jpg' || fileType == 'jpeg') {
      try {
        final imageProvider = CachedNetworkImageProvider(url);

        final Completer<ui.Image> completer = Completer();
        imageProvider.resolve(const ImageConfiguration()).addListener(
          ImageStreamListener((ImageInfo info, bool _) {
            completer.complete(info.image);
          }),
        );
        final ui.Image image = await completer.future;
        final ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        if (byteData != null) {
          bytes = byteData.buffer.asUint8List();
        }
      } catch (e) {
        return;
      }
    } else {
      var response = await get(Uri.parse(url));
      bytes = response.bodyBytes;
    }

    if(bytes == null) {
      return;
    }

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    String filePath = '$tempPath/${const Uuid().v4()}.$fileType';
    File file = File(filePath);
    await file.writeAsBytes(bytes);

    await OpenFilex.open(filePath);
  }
}
