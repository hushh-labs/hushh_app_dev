// app/platforms/mobile/card_wallet/presentation/bloc/inventory_bloc/bloc.dart
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_product.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/cached_inventory_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/inventory_configuration.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/inventory_schema_response.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/fetch_columns_and_data_types_from_google_sheet_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/fetch_inventories_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/fetch_products_result_from_inventory_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/insert_inventory_configuration_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/insert_inventory_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/insert_whatsapp_inventory_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/update_product_stock_quantity_use_case.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/lookbook_product_bloc/bloc.dart';

part 'events.dart';

part 'states.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final FetchInventoriesUseCase fetchInventoriesUseCase;
  final FetchProductsResultFromInventoryUseCase
      fetchProductsResultFromInventoryUseCase;
  final InsertInventoryUseCase insertInventoryUseCase;
  final FetchColumnsAndDataTypesFromGoogleSheetUseCase
      fetchColumnsAndDataTypesFromGoogleSheetUseCase;
  final InsertInventoryConfigurationUseCase insertInventoryConfigurationUseCase;
  final InsertWhatsappInventoryUseCase insertWhatsappInventoryUseCase;

  InventoryBloc(
      this.fetchInventoriesUseCase,
      this.fetchProductsResultFromInventoryUseCase,
      this.insertInventoryUseCase,
      this.fetchColumnsAndDataTypesFromGoogleSheetUseCase,
      this.insertInventoryConfigurationUseCase,
      this.insertWhatsappInventoryUseCase)
      : super(InventoryInitialState()) {
    on<FetchInventoriesEvent>(fetchInventoriesEvent);
    on<FetchProductsInInventoryEvent>(fetchProductsInInventoryEvent);
    on<CreateInventoryWithGoogleSheetsEvent>(
        createInventoryWithGoogleSheetsEvent);
    on<ProcessGoogleSheetEvent>(processGoogleSheetEvent);
    on<ProcessWhatsAppInventoryEvent>(processWhatsAppInventoryEvent);
    on<OnProductSelectEvent>(onProductSelectEvent);
    on<OnProductCardCountIncremented>(onProductCardCountIncremented);
    on<OnProductCardCountDecremented>(onProductCardCountDecremented);
    on<CartClearedEvent>(_onCartCleared);
    on<UpdateProductStockQuantityEvent>(_onUpdateProductStockQuantity);
    on<IncrementProductStockEvent>(_onIncrementProductStock);
    on<DecrementProductStockEvent>(_onDecrementProductStock);
  }

  List<InventoryConfiguration>? inventories;

  InventoryServer? currentInventoryServer;

  CachedInventoryModel? inventoryProductsResult;

  List<String> selectedProductIds = [];

  Map<String, int> cart = {};

  int? lastConfigurationId;
  int? lastBrandId;

  FutureOr<void> fetchInventoriesEvent(
      FetchInventoriesEvent event, Emitter<InventoryState> emit) async {
    emit(FetchingInventoriesState());
    final result = await fetchInventoriesUseCase(
        brandId: AppLocalStorage.agent!.agentBrandId);
    result.fold((l) {}, (inventories) {
      this.inventories = inventories;
      emit(FetchedInventoriesState());
    });
  }

  FutureOr<void> fetchProductsInInventoryEvent(
      FetchProductsInInventoryEvent event, Emitter<InventoryState> emit) async {
    lastConfigurationId = event.configurationId;
    lastBrandId = event.brandId;
    emit(FetchProductsResultFromInventoryState());
    final result = await fetchProductsResultFromInventoryUseCase(
        brandId: event.brandId, configurationId: event.configurationId);
    result.fold((l) {}, (inventoryProductsResult) {
      this.inventoryProductsResult = inventoryProductsResult;
      if (inventoryProductsResult != null) {
        emit(ProductsResultFetchedFromInventoryState(
            inventoryProductsResult.products));
      }
    });
  }

  FutureOr<void> createInventoryWithGoogleSheetsEvent(
      CreateInventoryWithGoogleSheetsEvent event,
      Emitter<InventoryState> emit) async {
    emit(InsertingInventoryConfigurationState());
    final result = await insertInventoryConfigurationUseCase(
      brandId: event.brandId,
      mappedColumns: event.mappedColumns,
      inventoryServer: InventoryServer.gsheets_public_server,
    );
    await result.fold((l) {}, (r) async {
      emit(InventoryConfigurationInsertedState());
      final result = await insertInventoryUseCase(
        payload: event.sheetsId,
        configurationId: r,
        brandId: event.brandId,
        mappedColumns: event.mappedColumns,
        inventoryServer: InventoryServer.gsheets_public_server,
      );
      result.fold((l) {}, (r) {
        ToastManager(Toast(title: 'Inventory created successfully!'))
            .show(event.context);
        Navigator.pop(event.context);
        add(FetchInventoriesEvent());
        emit(GoogleSheetsInventoryCreatedState());
      });
    });
  }

  FutureOr<void> processGoogleSheetEvent(
      ProcessGoogleSheetEvent event, Emitter<InventoryState> emit) async {
    String parseSheetId(String sheetUrl) {
      //https://docs.google.com/spreadsheets/d/1AbC12345678/edit
      // https://docs.google.com/spreadsheets/d/1AbC12345678
      // https://docs.google.com/a/example.com/spreadsheets/d/1AbC12345678/edit
      final RegExp regex = RegExp(
        r'(?:https?:\/\/)?(?:docs\.google\.com\/spreadsheets\/d\/|docs\.google\.com\/.*\/d\/|spreadsheets\/d\/)([^\/]+)',
      );

      final match = regex.firstMatch(sheetUrl);

      if (match != null && match.groupCount > 0) {
        return match.group(1)!;
      } else {
        throw const FormatException('Invalid Google Sheets URL');
      }
    }

    String sheetId = parseSheetId(event.sheetsUrl);
    emit(ProcessingGoogleSheetState());
    final result =
        await fetchColumnsAndDataTypesFromGoogleSheetUseCase(sheetId: sheetId);
    result.fold((l) {}, (r) {
      emit(GoogleSheetDataProcessedState(r, sheetId));
    });
  }

  FutureOr<void> processWhatsAppInventoryEvent(
      ProcessWhatsAppInventoryEvent event, Emitter<InventoryState> emit) async {
    String phoneNumber = event.dialCode + event.phoneNumber;
    final mappedColumns = {
      'product_name_identifier':
          InventoryColumn('name', InventoryFieldType.text),
      'product_image_identifier':
          InventoryColumn('images', InventoryFieldType.text),
      'product_sku_unique_id_identifier':
          InventoryColumn('id', InventoryFieldType.numeric),
      'product_price_identifier':
          InventoryColumn('price', InventoryFieldType.numeric),
      'product_currency_identifier':
          InventoryColumn('currency', InventoryFieldType.text),
      'product_description_identifier':
          InventoryColumn('description', InventoryFieldType.text),
    };
    emit(InsertingInventoryConfigurationState());
    final result = await insertInventoryConfigurationUseCase(
      brandId: AppLocalStorage.agent!.agentBrandId,
      mappedColumns: mappedColumns,
      inventoryServer: InventoryServer.whatsapp,
    );
    await result.fold((l) {}, (r) async {
      final result = await insertWhatsappInventoryUseCase(
          payload: phoneNumber,
          configurationId: r,
          brandId: AppLocalStorage.agent!.agentBrandId);
      result.fold((l) {}, (r) {
        ToastManager(Toast(title: 'Inventory created successfully!'))
            .show(event.context);
        Navigator.pop(event.context);
        add(FetchInventoriesEvent());
        emit(WhatsappInventoryCreatedState());
      });
    });
  }

  FutureOr<void> onProductSelectEvent(
      OnProductSelectEvent event, Emitter<InventoryState> emit) async {
    emit(SelectingProductFromInventoryState());
    if (event.isSelected) {
      selectedProductIds.add(event.productSkuUniqueId);
    } else {
      selectedProductIds.remove(event.productSkuUniqueId);
    }
    emit(ProductSelectedFromInventoryState());
  }

  FutureOr<void> onProductCardCountIncremented(
      OnProductCardCountIncremented event, Emitter<InventoryState> emit) async {
    emit(ProductCountIncrementingInCartState());
    if (cart.containsKey(event.productSkuUniqueId)) {
      cart[event.productSkuUniqueId] = cart[event.productSkuUniqueId]! + 1;
    } else {
      cart[event.productSkuUniqueId] = 1;
    }
    emit(ProductCountIncrementedInCartState());
  }

  FutureOr<void> onProductCardCountDecremented(
      OnProductCardCountDecremented event, Emitter<InventoryState> emit) async {
    emit(ProductCountDecrementingInCartState());
    if (cart.containsKey(event.productSkuUniqueId)) {
      cart[event.productSkuUniqueId] = cart[event.productSkuUniqueId]! - 1;
      if (cart[event.productSkuUniqueId]! <= 0) {
        cart.remove(event.productSkuUniqueId);
      }
    }
    emit(ProductCountDecrementedInCartState());
  }

  FutureOr<void> _onCartCleared(
      CartClearedEvent event, Emitter<InventoryState> emit) {
    cart.clear();
    emit(CartClearedState());
  }

  FutureOr<void> _onUpdateProductStockQuantity(
      UpdateProductStockQuantityEvent event,
      Emitter<InventoryState> emit) async {
    try {
      // Update the stock quantity locally in the cached inventory
      if (inventoryProductsResult != null) {
        final productIndex = inventoryProductsResult!.products.indexWhere(
          (product) => product.productSkuUniqueId == event.productSkuUniqueId,
        );
        if (productIndex != -1) {
          final updatedProducts =
              List<AgentProductModel>.from(inventoryProductsResult!.products);
          final currentProduct = updatedProducts[productIndex];
          final updatedProduct = AgentProductModel(
            productImage: currentProduct.productImage,
            productName: currentProduct.productName,
            productSkuUniqueId: currentProduct.productSkuUniqueId,
            productPrice: currentProduct.productPrice,
            productCurrency: currentProduct.productCurrency,
            productDescription: currentProduct.productDescription,
            stockQuantity: event.newStockQuantity,
            lookbookId: currentProduct.lookbookId,
            productId: currentProduct.productId,
            createdAt: currentProduct.createdAt,
            hushhId: currentProduct.hushhId,
          );
          updatedProducts[productIndex] = updatedProduct;
          inventoryProductsResult = CachedInventoryModel(
            inventoryProductsResult!.totalCount,
            updatedProducts,
          );
        }
      }
      // Update in Supabase
      final result = await sl<UpdateProductStockQuantityUseCase>()(
        productSkuUniqueId: event.productSkuUniqueId,
        newStockQuantity: event.newStockQuantity,
        hushhId: AppLocalStorage.agent!.hushhId!,
      );
      result.fold(
        (error) => emit(ProductStockUpdateFailedState(error.toString())),
        (_) {
          emit(ProductStockUpdatedState());
          // Refresh products from Supabase
          if (lastConfigurationId != null && lastBrandId != null) {
            add(FetchProductsInInventoryEvent(
                lastConfigurationId!, lastBrandId!));
          }
          // Also refresh all products in LookBookProductBloc
          final agent = AppLocalStorage.agent;
          if (agent != null) {
            sl<LookBookProductBloc>()
                .add(FetchAllProductsEvent(agent.agentBrandId));
          }
        },
      );
    } catch (e) {
      emit(ProductStockUpdateFailedState(e.toString()));
    }
  }

  FutureOr<void> _onIncrementProductStock(
      IncrementProductStockEvent event, Emitter<InventoryState> emit) async {
    // Find current stock quantity
    int currentStock = 0;
    if (inventoryProductsResult != null) {
      final product = inventoryProductsResult!.products.firstWhere(
        (product) => product.productSkuUniqueId == event.productSkuUniqueId,
        orElse: () => AgentProductModel(
          productImage: '',
          productName: '',
          productSkuUniqueId: '',
          productPrice: 0,
          productCurrency: '',
          productDescription: '',
          stockQuantity: 0,
        ),
      );
      currentStock = product.stockQuantity;
    }

    // Update with incremented stock
    add(UpdateProductStockQuantityEvent(
      productSkuUniqueId: event.productSkuUniqueId,
      newStockQuantity: currentStock + event.incrementBy,
    ));
  }

  FutureOr<void> _onDecrementProductStock(
      DecrementProductStockEvent event, Emitter<InventoryState> emit) async {
    // Find current stock quantity
    int currentStock = 0;
    if (inventoryProductsResult != null) {
      final product = inventoryProductsResult!.products.firstWhere(
        (product) => product.productSkuUniqueId == event.productSkuUniqueId,
        orElse: () => AgentProductModel(
          productImage: '',
          productName: '',
          productSkuUniqueId: '',
          productPrice: 0,
          productCurrency: '',
          productDescription: '',
          stockQuantity: 0,
        ),
      );
      currentStock = product.stockQuantity;
    }

    // Ensure stock doesn't go below 0
    final newStock = (currentStock - event.decrementBy).clamp(0, currentStock);

    // Update with decremented stock
    add(UpdateProductStockQuantityEvent(
      productSkuUniqueId: event.productSkuUniqueId,
      newStockQuantity: newStock,
    ));
  }
}
