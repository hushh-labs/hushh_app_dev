part of 'bloc.dart';

/// Default State
@immutable
abstract class SharedAssetsReceiptsState extends Equatable {
  const SharedAssetsReceiptsState();

  @override
  List<Object> get props => [];
}

/// Default Auth Page State
class SharedAssetsReceiptsInitialState extends SharedAssetsReceiptsState {}

class FetchingAssetsState extends SharedAssetsReceiptsState {}

class AssetsFetchedState extends SharedAssetsReceiptsState {}

class FetchingReceiptsState extends SharedAssetsReceiptsState {}

class FetchedReceiptsState extends SharedAssetsReceiptsState {}

class SharingImagesVideosState extends SharedAssetsReceiptsState {}

class ImagesVideosSharedState extends SharedAssetsReceiptsState {
  final String? url;

  ImagesVideosSharedState(this.url);
}

class SharingReceiptsAsImageState extends SharedAssetsReceiptsState {}

class ReceiptsAsImageSharedState extends SharedAssetsReceiptsState {}

class SharingReceiptsAsPdfState extends SharedAssetsReceiptsState {}

class ReceiptsAsPdfSharedState extends SharedAssetsReceiptsState {}

class SharingDocumentsState extends SharedAssetsReceiptsState {}

class DocumentsSharedState extends SharedAssetsReceiptsState {}

class DeletingSharedAssetState extends SharedAssetsReceiptsState {}

class SharedAssetDeletedState extends SharedAssetsReceiptsState {}