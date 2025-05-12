import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/receipt_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/customer_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/shared_asset.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/shared_assets_receipts_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/bloc/receipt_radar_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:hushh_app/app/shared/core/utils/utils_impl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class SharedAssetsReceiptsPageArgs {
  final CardModel cardData;
  final String uid;
  final CustomerModel? customerModel;

  SharedAssetsReceiptsPageArgs(
      {required this.cardData, required this.uid, this.customerModel});
}

class SharedAssetsReceiptsPage extends StatefulWidget {
  const SharedAssetsReceiptsPage({Key? key}) : super(key: key);

  @override
  State<SharedAssetsReceiptsPage> createState() =>
      _SharedAssetsReceiptsPageState();
}

class _SharedAssetsReceiptsPageState extends State<SharedAssetsReceiptsPage> {
  final controller = sl<SharedAssetsReceiptsBloc>();

  List<SharedAsset>? get fileDataReceipts => controller.fileDataReceipts;

  List<SharedAsset>? get fileDataAssets => controller.fileDataAssets;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final args = ModalRoute.of(context)!.settings.arguments!
          as SharedAssetsReceiptsPageArgs;
      controller.fileDataReceipts = null;
      controller.fileDataAssets = null;
      controller.add(FetchAllAssetsEvent(args.cardData));
      controller.add(FetchReceiptsFromReceiptRadarEvent(args.cardData));
    });
    super.initState();
  }

  int? groupValue = 0;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments!
        as SharedAssetsReceiptsPageArgs;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey)),
            child: const Center(
              child: Icon(
                Icons.arrow_back_ios_new_sharp,
                color: Colors.black,
              ),
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          // Adjust the top padding as needed
          child: Text(
            args.customerModel != null
                ? "${args.customerModel?.user.name?.split(' ')[0].trim()}'s vibe"
                : "Assets & Receipts",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Figtree',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder(
        bloc: controller,
        builder: (context, state) {
          return (controller.loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 100.h / 50.75,
                      ),
                      // if (args.customerModel == null)
                      SizedBox(
                        width: double.infinity,
                        child: CupertinoSlidingSegmentedControl<int>(
                          backgroundColor:
                              CupertinoColors.extraLightBackgroundGray,
                          thumbColor: CupertinoColors.white,
                          groupValue: groupValue,
                          children: const {
                            0: Text(
                              "Assets",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                            1: Text(
                              "Receipts",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                          },
                          onValueChanged: (value) {
                            setState(() {
                              groupValue = value;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: groupValue == 0
                            ? Container(
                                width: double.infinity,
                                margin: const EdgeInsets.all(10),
                                child: fileDataAssets == null
                                    ? const Center(
                                        child: CircularProgressIndicator())
                                    : fileDataAssets!.isEmpty
                                        ? const Center(
                                            child: Text('No vibes found :('))
                                        : GridView.custom(
                                            shrinkWrap: true,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                            ),
                                            childrenDelegate:
                                                SliverChildBuilderDelegate(
                                              (BuildContext context,
                                                  int index) {
                                                final asset =
                                                    fileDataAssets![index];
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(6.0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      onPreview(
                                                        asset.fileType!,
                                                        asset.path!,
                                                      );
                                                    },
                                                    child: Stack(
                                                      fit: StackFit.expand,
                                                      children: [
                                                        Container(
                                                          alignment:
                                                              Alignment.center,
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .grey.shade300,
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                            image: controller
                                                                    .isNotImage(
                                                                        index)
                                                                ? null
                                                                : DecorationImage(
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    image:
                                                                        CachedNetworkImageProvider(
                                                                      (asset.type ==
                                                                              "other_assets"
                                                                          ? asset
                                                                              .thumbnail
                                                                          : asset
                                                                              .path)!,
                                                                    ),
                                                                  ),
                                                          ),
                                                          child: controller
                                                                  .isNotImage(
                                                                      index)
                                                              ? Center(
                                                                  child: Text(
                                                                    asset.fileType
                                                                            ?.toUpperCase() ??
                                                                        'FILE',
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                )
                                                              : null,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                              childCount:
                                                  fileDataAssets!.length,
                                              findChildIndexCallback:
                                                  (Key key) {
                                                if (key is ValueKey<int>) {
                                                  return key.value;
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                              )
                            : Container(
                                width: double.infinity,
                                margin: const EdgeInsets.all(10),
                                child: fileDataReceipts!.isEmpty
                                    ? const Center(
                                        child: Text('No receipts found'))
                                    : GridView.custom(
                                        shrinkWrap: true,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                        ),
                                        childrenDelegate:
                                            SliverChildBuilderDelegate(
                                          (BuildContext context, int index) {
                                            final receipt =
                                                fileDataReceipts![index];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              child: InkWell(
                                                onTap: () {
                                                  viewAttachment(
                                                      ReceiptModel
                                                          receipt) async {
                                                    if (receipt.attachmentId ==
                                                        null) {
                                                      Navigator.pushNamed(
                                                          context,
                                                          AppRoutes
                                                              .shared.webViewer,
                                                          arguments:
                                                              receipt.body);
                                                      return;
                                                    }
                                                    showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (BuildContext
                                                          context) {
                                                        return Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8)),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(16),
                                                              child:
                                                                  const CupertinoActivityIndicator(),
                                                              // You can customize the dialog further if needed
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                    final response =
                                                        await sl<Dio>().post(
                                                            '${Constants.baseUrl}/view/attachment',
                                                            data: {
                                                              "access_token": sl<
                                                                      ReceiptRadarBloc>()
                                                                  .accessToken,
                                                              "supabase_authorisation":
                                                                  Supabase
                                                                      .instance
                                                                      .client
                                                                      .auth
                                                                      .currentSession
                                                                      ?.accessToken,
                                                              "message_id":
                                                                  receipt.messageId,
                                                              "attachment_id":
                                                                  receipt
                                                                      .attachmentId
                                                            },
                                                            options: Options(
                                                                headers: {
                                                                  'content-type':
                                                                      'application/json'
                                                                }));
                                                    Navigator.pop(context);
                                                    String? b64data = response
                                                        .data['file_data'];
                                                    if(b64data == null) {
                                                      ToastManager(Toast(title: 'Unable to view receipt', description: 'We are unable to identify you as the owner of the receipt at the moment.')).show(context);
                                                      return;
                                                    }
                                                    Uint8List bytes =
                                                        base64Decode(b64data);
                                                    final directory =
                                                        await getTemporaryDirectory();
                                                    final path =
                                                        "${directory.path}/${DateTime.now().millisecondsSinceEpoch}.${receipt.name.split('.').last}";
                                                    final file = File(path);
                                                    await file
                                                        .writeAsBytes(bytes);
                                                    Navigator.pushNamed(
                                                        context,
                                                        AppRoutes
                                                            .shared.pdfViewer,
                                                        arguments: file.path);
                                                  }

                                                  if (receipt.data != null) {
                                                    viewAttachment(
                                                        receipt.data!);
                                                  }
                                                },
                                                child: Stack(
                                                  fit: StackFit.expand,
                                                  children: [
                                                    FutureBuilder(
                                                        future: Future.value(null),
                                                        builder:
                                                            (context, state) {
                                                          return Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          5),
                                                                  decoration: BoxDecoration(
                                                                      color: Colors.grey.shade300,
                                                                      border: Border.all(color: Colors.black12),
                                                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                                      image: receipt.thumbnail != null || receipt.path != null
                                                                          ? DecorationImage(
                                                                              fit: BoxFit.cover,
                                                                              image: CachedNetworkImageProvider(
                                                                                (receipt.thumbnail ?? receipt.path)!,
                                                                              ))
                                                                          : state.data != null
                                                                              ? DecorationImage(
                                                                                  fit: BoxFit.cover,
                                                                                  image: MemoryImage(state.data!),
                                                                                )
                                                                              : null),
                                                                  child: const SizedBox(),
                                                                ),
                                                              ),
                                                              if (receipt
                                                                      .name !=
                                                                  null) ...[
                                                                const SizedBox(
                                                                    height: 4),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              8.0),
                                                                  child: Text(
                                                                      receipt
                                                                          .name!,
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis),
                                                                )
                                                              ]
                                                            ],
                                                          );
                                                        }),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                          childCount: fileDataReceipts!.length,
                                          findChildIndexCallback: (Key key) {
                                            if (key is ValueKey<int>) {
                                              return key.value;
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                              ),
                      )
                    ],
                  ),
                ));
        },
      ),
    );
  }

  void onPreview(String fileType, String url) async {
    try {
      var response = await get(Uri.parse(url));
      var bytes = response.bodyBytes;

      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;

      String filePath = '$tempPath/${const Uuid().v4()}.$fileType';
      File file = File(filePath);
      await file.writeAsBytes(bytes);

      await OpenFilex.open(filePath);
    } catch (e) {}
  }

  Map<String, Uint8List> hashMap = {};

  Future<Uint8List?> getThumbnail(String id, Uint8List data) async {
    if (hashMap.containsKey(id)) {
      return hashMap[id];
    }
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    String filePath = '$tempPath/${const Uuid().v4()}.pdf';
    File file = File(filePath);
    await file.writeAsBytes(data);
    final res = (await Utils().getImageFromPdf(filePath))!;
    hashMap[id] = res;
    return res;
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
}
