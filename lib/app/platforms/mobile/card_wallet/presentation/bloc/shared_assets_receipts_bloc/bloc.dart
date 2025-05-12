// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/receipt_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/shared_asset.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/delete_shared_asset_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/fetch_all_assets_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/insert_shared_asset_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/brand_card_list_view.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/pages/receipt_radar_utils.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:hushh_app/app/shared/core/utils/utils_impl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';

part 'events.dart';

part 'states.dart';

class SharedAssetsReceiptsBloc
    extends Bloc<SharedAssetsReceiptsEvent, SharedAssetsReceiptsState> {
  List<SharedAsset>? fileDataReceipts;
  List<SharedAsset>? fileDataAssets;

  bool get loading => fileDataAssets == null && fileDataReceipts == null;

  bool isNotImage(index) =>
      fileDataAssets![index].fileType == 'mp4' ||
      fileDataAssets![index].fileType == 'mov' ||
      fileDataAssets![index].fileType == 'docx' ||
      fileDataAssets![index].fileType == 'xlsx';

  final FetchAllAssetsUseCase fetchAllAssetsUseCase;
  final InsertSharedAssetUseCase insertSharedAssetUseCase;
  final DeleteSharedAssetUseCase deleteSharedAssetUseCase;

  SharedAssetsReceiptsBloc(this.fetchAllAssetsUseCase,
      this.insertSharedAssetUseCase, this.deleteSharedAssetUseCase)
      : super(SharedAssetsReceiptsInitialState()) {
    on<FetchAllAssetsEvent>(fetchAllAssetsEvent);
    on<ShareImagesVideosEvent>(shareImagesVideosEvent);
    on<ShareReceiptsAsPdfEvent>(shareReceiptsAsPdfEvent);
    on<ShareReceiptsAsImageEvent>(shareReceiptsAsImageEvent);
    on<ShareDocumentsEvent>(shareDocumentsEvent);
    on<FetchReceiptsFromReceiptRadarEvent>(fetchReceiptsFromReceiptRadarEvent);
    on<DeleteSharedAssetEvent>(deleteSharedAssetEvent);
    on<ShareCardImageEvent>(shareCardImageEvent);
  }

  FutureOr<void> fetchAllAssetsEvent(FetchAllAssetsEvent event,
      Emitter<SharedAssetsReceiptsState> emit) async {
    emit(FetchingAssetsState());

    final result = await fetchAllAssetsUseCase(
        uid: event.card.userId!, cardId: event.card.id!);

    result.fold((l) => null, (r) {
      fileDataAssets = [];
      fileDataAssets =
          r.where((element) => element.type != 'receipts').toList();

      fileDataReceipts ??= [];
      fileDataReceipts!
          .addAll(r.where((element) => element.type == 'receipts').toList());
    });
    emit(AssetsFetchedState());
  }

  FutureOr<void> fetchReceiptsFromReceiptRadarEvent(
      FetchReceiptsFromReceiptRadarEvent event,
      Emitter<SharedAssetsReceiptsState> emit) async {
    fileDataReceipts = [];
    emit(FetchedReceiptsState());
    List<ReceiptModel> receipts = await sl<ReceiptRadarUtils>().fetchReceipts();
    if (receipts.isNotEmpty) {
      final data = receipts.first.toJson();
      data.remove('attachments');
      if (event.card.isPreferenceCard) {
        receipts = receipts
            .where((element) =>
                (element.brandCategory?.toLowerCase() ?? "") ==
                event.card.brandCategory?.toLowerCase())
            .toList();
      } else {
        receipts = receipts.where((element) {
          final String brandName = (((element.brand?.trim().isNotEmpty ?? false)
              ? element.brand
              : element.company) as String);
          return (brandName.toLowerCase()) ==
              event.card.brandName.toLowerCase();
        }).toList();
      }
      fileDataReceipts!.addAll(receipts
          .map((e) => SharedAsset(
              data: e,
              name: e.brand,
              hushhId: AppLocalStorage.hushhId!,
              cardId: 0))
          .toList());
    }
    emit(FetchedReceiptsState());
  }

  FutureOr<void> shareImagesVideosEvent(ShareImagesVideosEvent event,
      Emitter<SharedAssetsReceiptsState> emit) async {
    emit(SharingImagesVideosState());
    if (event.pop) {
      Navigator.pop(event.context);
    }
    String? uploadedImageUrl = await _uploadImagesAndVideos(event.context,
        event.cardData, event.fromCamera, event.files, event.startReceiptRadar);
    // Navigator.pushReplacementNamed(event.context, AppRoutes.home);
    emit(ImagesVideosSharedState(uploadedImageUrl));
  }

  FutureOr<void> shareReceiptsAsImageEvent(ShareReceiptsAsImageEvent event,
      Emitter<SharedAssetsReceiptsState> emit) async {
    // Navigator.pop(event.context);
    emit(SharingReceiptsAsImageState());
    ToastManager(Toast(
            title: 'Your receipts are currently uploading',
            type: ToastificationType.info))
        .show(event.context);
    await _uploadReceiptsAsImage(event.context, event.imageBytes);
    emit(ReceiptsAsImageSharedState());
  }

  FutureOr<void> shareReceiptsAsPdfEvent(ShareReceiptsAsPdfEvent event,
      Emitter<SharedAssetsReceiptsState> emit) async {
    // Navigator.pop(event.context);
    // ToastManager(Toast(
    //         title: 'Your receipts are currently uploading',
    //         type: ToastificationType.info))
    //     .show(event.context);
    emit(SharingReceiptsAsPdfState());
    await _uploadDocumentsAsPdf(event.context, event.brandName);
    emit(ReceiptsAsPdfSharedState());
  }

  FutureOr<void> shareDocumentsEvent(ShareDocumentsEvent event,
      Emitter<SharedAssetsReceiptsState> emit) async {
    emit(SharingDocumentsState());
    await _uploadDocuments(event.context, event.brandName);
    emit(DocumentsSharedState());
  }

  Future<String?> _uploadImagesAndVideos(
      BuildContext context, CardModel cardData, bool fromCamera,
      [List<XFile>? files, bool startReceiptRadar = false]) async {
    List<XFile> result = [];
    if (files?.isEmpty ?? true) {
      if (fromCamera) {
        XFile? file = await ImagePicker()
            .pickImage(source: ImageSource.camera, imageQuality: 40);
        if (file != null) {
          result = [file];
        }
      } else {
        result = await ImagePicker().pickMultiImage(imageQuality: 40);
      }
    } else {
      result = files!;
    }
    if (result.isEmpty) {
      return null;
    }
    ToastManager(Toast(
            title: 'Your picture(s) are currently uploading',
            type: ToastificationType.info))
        .show(context);

    final supabase = Supabase.instance.client;

    for (var file in result) {
      String id = const Uuid().v4();
      var extension = file.name.split('.').last;
      String path =
          "user/${AppLocalStorage.hushhId}/uploads/assets/$id.$extension";

      Uint8List bytes = await file.readAsBytes();
      bytes = await FlutterImageCompress.compressWithList(bytes, quality: 40);
      await supabase.storage.from('all_card_assets').uploadBinary(path, bytes);

      String url = supabase.storage.from('all_card_assets').getPublicUrl(path);

      if(startReceiptRadar) {
        sl<Dio>().post(
            'https://omkar008-expense-parser.hf.space/process_uploaded_document',
            data: {
              "user_id": AppLocalStorage.hushhId,
              "email": AppLocalStorage.user?.email,
              "filename": url
            }).then((value) {
          if(value.statusCode ==200 ) {
            ToastManager(Toast(
                title: "We are currently processing the receipt",
                type: ToastificationType.success))
                .show(context);
          } else {
            ToastManager(Toast(
                title: "Some error occurred",
                type: ToastificationType.error))
                .show(context);
          }
        });
      }

      if (cardData.id != null) {
        SharedAsset asset = SharedAsset(
          hushhId: AppLocalStorage.hushhId!,
          cardId: cardData.id!,
          type: "assets",
          fileType: extension,
          path: url,
          createdTime: DateTime.now(),
        );
        final result = await insertSharedAssetUseCase(asset: asset);
        result.fold((l) => null, (r) {
          fileDataAssets?.add(r);
          if (sl<CardWalletPageBloc>().cardData != null) {
            sl<CardWalletPageBloc>().add(const IncrementCoinEvent(1));
          }
          ToastManager(Toast(
                  title: 'Picture(s) uploaded successfully!',
                  type: ToastificationType.info))
              .show(context);
        });
      }
      return url;
    }
    return null;
  }

  Future<void> _uploadReceiptsAsImage(
      BuildContext context, Uint8List imageBytes) async {
    final supabase = Supabase.instance.client;
    String id = const Uuid().v4();
    var extension = 'png';
    String path =
        "user/${AppLocalStorage.hushhId}/uploads/receipts/$id.$extension";

    await supabase.storage
        .from('all_card_assets')
        .uploadBinary(path, imageBytes);
    String url = supabase.storage.from('all_card_assets').getPublicUrl(path);

    SharedAsset asset = SharedAsset(
      hushhId: AppLocalStorage.hushhId!,
      cardId: sl<CardWalletPageBloc>().cardData!.id!,
      type: "receipts",
      fileType: extension,
      path: url,
      createdTime: DateTime.now(),
    );
    final result = await insertSharedAssetUseCase(asset: asset);
    result.fold((l) => null, (r) {
      fileDataAssets?.add(r);
      sl<CardWalletPageBloc>().add(const IncrementCoinEvent(1));
      ToastManager(Toast(
              title: 'Asset(s) uploaded successfully!',
              type: ToastificationType.info))
          .show(context);
    });
  }

  Future<void> _uploadDocuments(BuildContext context, String brandName) async {
    final List<PlatformFile>? result = (await FilePicker.platform.pickFiles(
            withData: true, type: FileType.custom, allowedExtensions: ['pdf']))
        ?.files;
    if (result?.isEmpty ?? true) {
      return;
    }
    ToastManager(Toast(
            title: 'Your documents are currently uploading',
            type: ToastificationType.info))
        .show(context);

    final supabase = Supabase.instance.client;

    for (var file in result!) {
      String id = const Uuid().v4();
      var extension = file.extension;
      Uint8List thumbnail = (await Utils().getImageFromPdf(file.path!))!;

      String thumbPath =
          'thumbnails/${AppLocalStorage.hushhId}/uploads/assets/thumbnail/$id.png';
      await supabase.storage
          .from('all_card_assets')
          .uploadBinary(thumbPath, thumbnail);
      String thumbUri =
          supabase.storage.from('all_card_assets').getPublicUrl(thumbPath);

      String path =
          "user/${AppLocalStorage.hushhId}/uploads/assets/$id.$extension";
      await supabase.storage
          .from('all_card_assets')
          .uploadBinary(path, file.bytes ?? Uint8List.fromList([]));
      String url = supabase.storage.from('all_card_assets').getPublicUrl(path);

      SharedAsset asset = SharedAsset(
        hushhId: AppLocalStorage.hushhId!,
        cardId: sl<CardWalletPageBloc>().cardData!.id!,
        type: "other_assets",
        thumbnail: thumbUri,
        fileType: extension,
        path: url,
        createdTime: DateTime.now(),
      );
      final result = await insertSharedAssetUseCase(asset: asset);
      result.fold((l) => null, (r) {
        fileDataAssets?.add(r);
        sl<CardWalletPageBloc>().add(const IncrementCoinEvent(1));
        ToastManager(Toast(
                title: 'Documents uploaded successfully!',
                type: ToastificationType.info))
            .show(context);
      });
    }
  }

  Future<void> _uploadDocumentsAsPdf(
      BuildContext context, String brandName) async {
    final List<PlatformFile>? result = (await FilePicker.platform.pickFiles(
            withData: true, type: FileType.custom, allowedExtensions: ['pdf']))
        ?.files;
    if (result?.isEmpty ?? true) {
      return;
    }
    ToastManager(Toast(
            title: 'Your document(s) are currently uploading',
            type: ToastificationType.info))
        .show(context);

    final supabase = Supabase.instance.client;

    for (var file in result!) {
      String id = const Uuid().v4();
      var extension = file.extension;
      Uint8List thumbnail = (await Utils().getImageFromPdf(file.path!))!;

      String thumbPath =
          'thumbnails/${AppLocalStorage.hushhId}/uploads/assets/thumbnail/$id.png';
      await supabase.storage
          .from('all_card_assets')
          .uploadBinary(thumbPath, thumbnail);
      String thumbUri =
          supabase.storage.from('all_card_assets').getPublicUrl(thumbPath);

      String path =
          "user/${AppLocalStorage.hushhId}/uploads/receipts/$id.$extension";
      await supabase.storage
          .from('all_card_assets')
          .uploadBinary(path, file.bytes ?? Uint8List.fromList([]));
      String url = supabase.storage.from('all_card_assets').getPublicUrl(path);

      SharedAsset asset = SharedAsset(
        hushhId: AppLocalStorage.hushhId!,
        cardId: sl<CardWalletPageBloc>().cardData!.id!,
        type: "receipts",
        thumbnail: thumbUri,
        fileType: extension,
        path: url,
        createdTime: DateTime.now(),
      );
      final result = await insertSharedAssetUseCase(asset: asset);
      result.fold((l) => null, (r) {
        fileDataAssets?.add(r);
        sl<CardWalletPageBloc>().add(const IncrementCoinEvent(1));
        ToastManager(Toast(
                title: 'Documents uploaded successfully!',
                type: ToastificationType.info))
            .show(context);
      });
    }
  }

  FutureOr<void> deleteSharedAssetEvent(DeleteSharedAssetEvent event,
      Emitter<SharedAssetsReceiptsState> emit) async {
    emit(DeletingSharedAssetState());
    final asset = event.asset;
    final result = await deleteSharedAssetUseCase(asset: asset);
    result.fold((l) => null, (r) {
      fileDataAssets?.remove(asset);
      emit(SharedAssetDeletedState());
      ToastManager(Toast(
              title: 'Asset deleted successfully!',
              type: ToastificationType.info))
          .show(event.context);
    });
  }

  FutureOr<void> shareCardImageEvent(ShareCardImageEvent event,
      Emitter<SharedAssetsReceiptsState> emit) async {
    ScreenshotController screenshotController = ScreenshotController();
    showDialog(
      context: event.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.all(16),
              child: const CupertinoActivityIndicator(),
              // You can customize the dialog further if needed
            ),
          ],
        );
      },
    );
    final data = await screenshotController.captureFromWidget(Material(
      child: BrandCardWidget(
        brand: event.cardData,
        ignore: true,
        isDetailsScreen: false,
      ),
    ));

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    Navigator.pop(event.context);

    String filePath = '$tempPath/${const Uuid().v4()}.png';
    File file = File(filePath);
    await file.writeAsBytes(data);
    XFile xfile = XFile(file.path);
    await Share.shareXFiles([xfile]);
  }
}
