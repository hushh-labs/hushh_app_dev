part of 'bloc.dart';

abstract class SharedAssetsReceiptsEvent extends Equatable {
  const SharedAssetsReceiptsEvent();

  @override
  List<Object> get props => [];
}

class FetchAllAssetsEvent extends SharedAssetsReceiptsEvent {
  final CardModel card;

  const FetchAllAssetsEvent(this.card);
}

class FetchReceiptsFromReceiptRadarEvent extends SharedAssetsReceiptsEvent {
  final CardModel card;

  const FetchReceiptsFromReceiptRadarEvent(this.card);
}

class ShareImagesVideosEvent extends SharedAssetsReceiptsEvent {
  final BuildContext context;
  final CardModel cardData;
  final bool pop;
  final List<XFile>? files;
  final bool fromCamera;
  final bool startReceiptRadar;

  const ShareImagesVideosEvent(this.context, this.cardData,
      {this.pop = true,
      this.files,
      this.fromCamera = false,
      this.startReceiptRadar = false});
}

class ShareReceiptsAsImageEvent extends SharedAssetsReceiptsEvent {
  final BuildContext context;
  final Uint8List imageBytes;

  const ShareReceiptsAsImageEvent(this.context, this.imageBytes);
}

class ShareReceiptsAsPdfEvent extends SharedAssetsReceiptsEvent {
  final BuildContext context;
  final String brandName;

  const ShareReceiptsAsPdfEvent(this.context, this.brandName);
}

class ShareDocumentsEvent extends SharedAssetsReceiptsEvent {
  final BuildContext context;
  final String brandName;

  const ShareDocumentsEvent(this.context, this.brandName);
}

class DeleteSharedAssetEvent extends SharedAssetsReceiptsEvent {
  final SharedAsset asset;
  final BuildContext context;

  const DeleteSharedAssetEvent(this.asset, this.context);
}

class ShareCardImageEvent extends SharedAssetsReceiptsEvent {
  final CardModel cardData;
  final BuildContext context;

  const ShareCardImageEvent(this.cardData, this.context);
}
