import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/cached_inventory_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/inventory_configuration.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/inventory_schema_response.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/fetch_columns_and_data_types_from_google_sheet_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/fetch_inventories_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/fetch_products_result_from_inventory_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/insert_inventory_configuration_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/insert_inventory_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/insert_whatsapp_inventory_use_case.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';

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
  }

  List<InventoryConfiguration>? inventories;

  InventoryServer? currentInventoryServer;

  CachedInventoryModel? inventoryProductsResult;

  List<String> selectedProductIds = [];

  Map<String, int> cart = {};

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
    emit(FetchProductsResultFromInventoryState());
    final result = await fetchProductsResultFromInventoryUseCase(
        brandId: event.brandId, configurationId: event.configurationId);
    result.fold((l) {}, (inventoryProductsResult) {
      this.inventoryProductsResult = inventoryProductsResult;
      emit(ProductsResultFetchedFromInventoryState());
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
      if(cart[event.productSkuUniqueId]! <= 0) {
        cart.remove(event.productSkuUniqueId);
      }
    }
    emit(ProductCountDecrementedInCartState());
  }
}
