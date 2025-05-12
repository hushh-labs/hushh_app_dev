part of 'bloc.dart';

abstract class InventoryEvent extends Equatable {
  const InventoryEvent();

  @override
  List<Object> get props => [];
}

class FetchInventoriesEvent extends InventoryEvent {}

class FetchProductsInInventoryEvent extends InventoryEvent {
  final int configurationId;
  final int brandId;

  const FetchProductsInInventoryEvent(this.configurationId, this.brandId);
}

class CreateInventoryWithGoogleSheetsEvent extends InventoryEvent {
  final String sheetsId;
  final int brandId;
  final Map<String, InventoryColumn> mappedColumns;
  final BuildContext context;

  const CreateInventoryWithGoogleSheetsEvent(
      this.sheetsId, this.mappedColumns, this.brandId, this.context);
}

class ProcessGoogleSheetEvent extends InventoryEvent {
  final String sheetsUrl;

  const ProcessGoogleSheetEvent(this.sheetsUrl);
}

class ProcessWhatsAppInventoryEvent extends InventoryEvent {
  final String dialCode;
  final String phoneNumber;
  final BuildContext context;

  const ProcessWhatsAppInventoryEvent(
    this.dialCode,
    this.phoneNumber,
    this.context,
  );
}

class OnProductSelectEvent extends InventoryEvent {
  final String productSkuUniqueId;
  final bool isSelected;

  const OnProductSelectEvent({required this.productSkuUniqueId, required this.isSelected});

  @override
  List<Object> get props => [productSkuUniqueId, isSelected];
}

class OnProductCardCountIncremented extends InventoryEvent {
  final String productSkuUniqueId;

  const OnProductCardCountIncremented({required this.productSkuUniqueId});

  @override
  List<Object> get props => [productSkuUniqueId];
}

class OnProductCardCountDecremented extends InventoryEvent {
  final String productSkuUniqueId;

  const OnProductCardCountDecremented({required this.productSkuUniqueId});

  @override
  List<Object> get props => [productSkuUniqueId];
}