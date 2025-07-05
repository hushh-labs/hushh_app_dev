// app/platforms/mobile/card_wallet/presentation/bloc/inventory_bloc/states.dart
part of 'bloc.dart';

/// Default State
@immutable
abstract class InventoryState extends Equatable {
  const InventoryState();

  @override
  List<Object> get props => [];
}

/// Default Auth Page State
class InventoryInitialState extends InventoryState {}

class FetchingInventoriesState extends InventoryState {}

class FetchedInventoriesState extends InventoryState {}

class FetchProductsResultFromInventoryState extends InventoryState {}

class ProductsResultFetchedFromInventoryState extends InventoryState {
  final List<AgentProductModel> products;

  const ProductsResultFetchedFromInventoryState(this.products);

  @override
  List<Object> get props => [products];
}

class CreatingGoogleSheetsInventoryState extends InventoryState {}

class GoogleSheetsInventoryCreatedState extends InventoryState {}

class CreatingWhatsappInventoryState extends InventoryState {}

class WhatsappInventoryCreatedState extends InventoryState {}

class ProcessingGoogleSheetState extends InventoryState {}

class GoogleSheetDataProcessedState extends InventoryState {
  final InventorySchemaResponse response;
  final String sheetId;

  const GoogleSheetDataProcessedState(this.response, this.sheetId);
}

class InsertingInventoryConfigurationState extends InventoryState {}

class InventoryConfigurationInsertedState extends InventoryState {}

class SelectingProductFromInventoryState extends InventoryState {}

class ProductSelectedFromInventoryState extends InventoryState {}

class ProductCountIncrementingInCartState extends InventoryState {}

class ProductCountIncrementedInCartState extends InventoryState {}

class ProductCountDecrementingInCartState extends InventoryState {}

class ProductCountDecrementedInCartState extends InventoryState {}

class CartClearedState extends InventoryState {}

class UpdatingProductStockState extends InventoryState {}

class ProductStockUpdatedState extends InventoryState {}

class ProductStockUpdateFailedState extends InventoryState {
  final String error;

  const ProductStockUpdateFailedState(this.error);

  @override
  List<Object> get props => [error];
}
