import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:hushh_app/app/platforms/mobile/auth/domain/entities/agent.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/domain/usecases/fetch_brand_products_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_lookbook.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_product.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/cached_inventory_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/delete_lookbook_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/delete_product_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/fetch_look_books_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/insert_agent_products_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/insert_look_book_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/domain/usecases/update_look_book_field_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/chat/domain/usecases/send_message_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/chat/domain/usecases/update_conversation_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/chat/presentation/bloc/chat_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/ai_handler/ai_handler.dart';
import 'package:hushh_app/app/shared/core/ai_handler/prompt_gen.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/models/payment_model.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';

part 'events.dart';

part 'states.dart';

class LookBookProductBloc
    extends Bloc<LookBookProductEvent, LookBookProductState> {
  final FetchLookBooksUseCase fetchLookBooksUseCase;
  final InsertLookBookUseCase insertLookBookUseCase;
  final UpdateLookBookFieldUseCase updateLookBookFieldUseCase;
  final InsertAgentProductsUseCase insertAgentProductsUseCase;
  final DeleteProductUseCase deleteProductUseCase;

  // final FetchAgentProductsUseCase fetchAgentProductsUseCase;
  final FetchBrandProductsUseCase fetchBrandProductsUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final DeleteLookBookUseCase deleteLookBookUseCase;
  final UpdateConversationUseCase updateConversationUseCase;

  LookBookProductBloc(
    this.insertAgentProductsUseCase,
    this.fetchLookBooksUseCase,
    this.fetchBrandProductsUseCase,
    this.insertLookBookUseCase,
    this.deleteProductUseCase,
    this.updateLookBookFieldUseCase,
    this.sendMessageUseCase,
    this.updateConversationUseCase,
    this.deleteLookBookUseCase,
  ) : super(LookBookProductInitialState()) {
    on<FetchLookBooksEvent>(fetchLookBooksEvent);
    on<FetchAllProductsEvent>(fetchAllProductsEvent);
    on<AddProductsToLookBook>(addProductsToLookBook);
    on<DeleteProductEvent>(deleteProductEvent);
    on<FetchLookBookProductsEvent>(fetchLookBookProductsEvent);
    on<UploadCatalogueEvent>(uploadCatalogueEvent);
    on<CreateLookbookEvent>(createLookbookEvent);
    on<SendProductInquiryToAgent>(sendProductInquiryToAgent);
    on<SendLookBookInquiryToAgent>(sendLookBookInquiryToAgent);
    on<DeleteLookBookEvent>(deleteLookBookEvent);
    on<SearchLookBookEvent>(searchLookBookEvent);
    on<SearchProductEvent>(searchProductEvent);
    on<SendPaymentRequestToUserEvent>(sendPaymentRequestToUserEvent);
  }

  AgentLookBook? selectedLookBook;
  List<AgentLookBook>? lookbooks;
  CachedInventoryModel? inventoryAllProductsResult;
  List<AgentProductModel>? lookbookProducts;
  List<AgentProductModel> selectedProducts = [];
  List<AgentLookBook> selectedLookbooks = [];
  TextEditingController searchController = TextEditingController();
  List<AgentLookBook> lookBookSearch = [];
  List<AgentProductModel>? allProductSearch;
  TextEditingController searchProductsController = TextEditingController();

  AgentModel? get agent => sl<CardWalletPageBloc>().isAgent
      ? AppLocalStorage.agent
      : sl<CardWalletPageBloc>().selectedAgent;

  FutureOr<void> fetchLookBooksEvent(
      FetchLookBooksEvent event, Emitter<LookBookProductState> emit) async {
    if (agent == null) {
      return;
    }
    lookbooks = null;
    print("looo : $lookbooks");
    emit(FetchingLookBooksState());
    final result = await fetchLookBooksUseCase(uid: agent!.hushhId!);
    await result.fold((l) {
      lookbooks = [];
      print("looo err : $lookbooks");
      emit(LookBooksErrorState());
    }, (r) async {
      lookbooks = r;
      print("looo succ : $lookbooks");
      lookBookSearch = lookbooks!;
      emit(LookBooksFetchedState());
    });
  }

  FutureOr<void> uploadCatalogueEvent(
      UploadCatalogueEvent event, Emitter<LookBookProductState> emit) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      allowMultiple: false,
    );
    if (result != null && result.files.isNotEmpty) {
      final file = File(result.files.first.path!);
      final input = file.openRead();
      final csv = await input
          .transform(utf8.decoder)
          .transform(const CsvToListConverter(eol: '\n'))
          .toList();
      final headers = csv[0];
      final systemPrompt = await PromptGen.lookBookPrompt();
      final response =
          await AiHandler(systemPrompt).getChatResponse(headers.join(","));
      if (response != null) {
        final parsedEvent = extractSingleJSONFromString(response);
        log(parsedEvent);
        List<AgentProductModel> productsExtracted = AgentProductModel.fromCsv(
            csv, Map<String, String>.from(jsonDecode(parsedEvent)));
        final result =
            await insertAgentProductsUseCase(products: productsExtracted);
        result.fold((l) => null, (r) {
          ToastManager(Toast(
                  title: "${productsExtracted.length} products added!",
                  type: ToastificationType.success))
              .show(event.context);
        });
      }
    }
  }

  FutureOr<void> fetchAllProductsEvent(
      FetchAllProductsEvent event, Emitter<LookBookProductState> emit) async {
    selectedProducts = [];
    inventoryAllProductsResult = null;
    emit(LoadingState());
    final result = await fetchBrandProductsUseCase(brandId: event.brandId);
    result.fold((l) {
      inventoryAllProductsResult = CachedInventoryModel(0, []);
      emit(DoneState());
    }, (r) {
      inventoryAllProductsResult = r;
      allProductSearch = r.products;
      // if (event.selectedProducts != null) {
      //   List<String> selectedProductIds =
      //       event.selectedProducts!.map((e) => e.productSkuUniqueId).toList();
      //   inventoryAllProductsResult!.products.removeWhere((element) =>
      //       selectedProductIds.contains(element.productSkuUniqueId));
      // }
      emit(DoneState());
    });
  }

  FutureOr<void> fetchLookBookProductsEvent(FetchLookBookProductsEvent event,
      Emitter<LookBookProductState> emit) async {
    // lookbookProducts = null;
    // emit(LoadingState());
    // final result = await fetchAgentProductsUseCase(
    //     uid: agent!.hushhId!, lookbookId: event.lookbookId);
    // result.fold((l) => null, (r) {
    //   lookbookProducts = r;
    //   emit(DoneState());
    // });
  }

  FutureOr<void> createLookbookEvent(
      CreateLookbookEvent event, Emitter<LookBookProductState> emit) async {
    AgentLookBook lookBook = AgentLookBook(
        name: event.name,
        images: selectedProducts.take(3).map((e) => e.productImage).toList(),
        numberOfProducts: selectedProducts.length,
        createdAt: DateTime.now().toIso8601String(),
        id: const Uuid().v4(),
        hushhId: AppLocalStorage.hushhId!);
    emit(CreatingLookBookState());
    final result = await insertLookBookUseCase(
        lookbook: lookBook, products: selectedProducts);
    await result.fold((l) => null, (r) async {
      emit(DoneState());
      ToastManager(Toast(
              title: "Lookbook created!", type: ToastificationType.success))
          .show(event.context);
      Navigator.pop(event.context);
      Navigator.pop(event.context);
      add(FetchLookBooksEvent());
    });
  }

  FutureOr<void> deleteProductEvent(
      DeleteProductEvent event, Emitter<LookBookProductState> emit) async {
    emit(LoadingState());
    final result = await deleteProductUseCase(product: event.product);
    await result.fold((l) => null, (r) async {
      inventoryAllProductsResult?.products.removeWhere(
          (element) => element.productId == event.product.productId);
      if (event.product.lookbookId != null) {
        await updateLookBookFieldUseCase(
          lookbookId: event.product.lookbookId!,
          field: {
            "numberOfProducts": selectedLookBook!.numberOfProducts - 1,
          },
        );
      }
      emit(DoneState());
      add(FetchLookBooksEvent());
    });
  }

  FutureOr<void> addProductsToLookBook(
      AddProductsToLookBook event, Emitter<LookBookProductState> emit) async {
    emit(LoadingState());
    final result = await updateLookBookFieldUseCase(
      lookbookId: selectedLookBook!.id,
      field: {
        "createdAt": DateTime.now().toIso8601String(),
        "numberOfProducts":
            selectedLookBook!.numberOfProducts + selectedProducts.length
      },
    );
    result.fold((l) => null, (r) async {
      final result =
          await insertAgentProductsUseCase(products: selectedProducts);
      result.fold((l) => null, (r) async {
        emit(DoneState());
        ToastManager(Toast(
                title: "Lookbook updated!", type: ToastificationType.success))
            .show(event.context);
        Navigator.pop(event.context);
        Navigator.pop(event.context);
        add(FetchLookBooksEvent());
      });
    });
  }

  FutureOr<void> sendProductInquiryToAgent(SendProductInquiryToAgent event,
      Emitter<LookBookProductState> emit) async {
    emit(SendingProductInquiryState());
    String commutativeFunction(String a, String b) {
      List<String> strings = [a, b];
      strings.sort();
      return strings.join();
    }

    final myUser = types.User(
        id: AppLocalStorage.hushhId!,
        firstName: sl<CardWalletPageBloc>().user!.name);

    final message = types.CustomMessage(
        author: myUser,
        id: const Uuid().v4(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
        metadata: {
          "type": "product",
          "data": event.product.toJson(),
          "message":
              """<p>Hello, I would like to inquire about the following product:</p>
<ul>
  <li><strong>Product Name:</strong> ${event.product.productName}</li>
  <li><strong>Product SKU:</strong> ${event.product.productSkuUniqueId}</li>
</ul>
<p>Please provide me with more information about this product.</p>""",
        });

    emit(LoadingState());

    String conversationId =
        commutativeFunction(event.agent.hushhId!, AppLocalStorage.hushhId!);

    final data = await sl<ChatPageBloc>().initiateChat(InitiateChatEvent(
      event.context,
      null,
      event.agent.hushhId!,
    ));

    data.fold((l) => null, (data) async {
      try {
        await updateConversationUseCase(
            conversation: data.item1.copyWith(lastMessage: message));
        await sendMessageUseCase(
            message: message.copyWith(
          roomId: data.item1.id,
          remoteId: event.agent.hushhId,
        ));
      } catch (m, s) {
        log(m.toString());
        log(s.toString());
      }
      sl<ChatPageBloc>().updateChatsInRealtime();
      Navigator.pushNamed(
          navigatorKey.currentState!.context, AppRoutes.chat.main,
          arguments: data);
      emit(ProductInquirySentState());
    });
  }

  FutureOr<void> sendLookBookInquiryToAgent(SendLookBookInquiryToAgent event,
      Emitter<LookBookProductState> emit) async {
    emit(SendingProductInquiryState());
    String commutativeFunction(String a, String b) {
      List<String> strings = [a, b];
      strings.sort();
      return strings.join();
    }

    final myUser = types.User(
        id: AppLocalStorage.hushhId!,
        firstName: sl<CardWalletPageBloc>().user!.name);

    final message = types.CustomMessage(
        author: myUser,
        id: const Uuid().v4(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
        metadata: {
          "type": "lookbook",
          "data": event.lookbook.toJson(),
          "message":
              """<p>Hello, I would like to inquire about the following lookbook:</p>
<ul>
  <li><strong>Lookbook Name:</strong> ${event.lookbook.name}</li>
</ul>
<p>I am interested in few of the products, can you share me more information.</p>""",
        });

    emit(LoadingState());

    final data = await sl<ChatPageBloc>().initiateChat(InitiateChatEvent(
      event.context,
      null,
      event.agent.hushhId!,
    ));

    data.fold((l) => null, (data) async {
      await Future.wait([
        sendMessageUseCase(
            message: message.copyWith(
          roomId: data.item1.id,
          remoteId: event.agent.hushhId,
        )),
        updateConversationUseCase(
            conversation: data.item1.copyWith(lastMessage: message)),
      ]);

      sl<ChatPageBloc>().updateChatsInRealtime();
      Navigator.pushNamed(event.context, AppRoutes.chat.main, arguments: data);
      emit(ProductInquirySentState());
    });
  }

  FutureOr<void> deleteLookBookEvent(
      DeleteLookBookEvent event, Emitter<LookBookProductState> emit) async {
    emit(LoadingState());
    final result = await deleteLookBookUseCase(lookBook: event.lookBook);
    await result.fold((l) => null, (r) async {
      lookbooks?.remove(event.lookBook);
      ToastManager(Toast(
              title: "Lookbook removed!", type: ToastificationType.success))
          .show(event.context);
      emit(DoneState());
    });
  }

  FutureOr<void> searchLookBookEvent(
      SearchLookBookEvent event, Emitter<LookBookProductState> emit) {
    if (searchController.text.isNotEmpty) {
      emit(LookBooksSearchState());
      lookBookSearch = lookbooks!
          .where((element) => element.name
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    } else {
      emit(ShowLookBookState());
      lookBookSearch.clear();
    }
  }

  FutureOr<void> searchProductEvent(
      SearchProductEvent event, Emitter<LookBookProductState> emit) {
    if (searchProductsController.text.isNotEmpty) {
      emit(ProductSearchState());
      allProductSearch = inventoryAllProductsResult!.products
          .where((element) => element.productName
              .toLowerCase()
              .contains(searchProductsController.text.toLowerCase()))
          .toList();
      emit(ProductSearchFinishedState());
    } else {
      emit(ShowProductState());
      allProductSearch!.clear();
    }
  }

  FutureOr<void> sendPaymentRequestToUserEvent(
      SendPaymentRequestToUserEvent event,
      Emitter<LookBookProductState> emit) async {
    emit(SendingProductInquiryState());
    sl<ChatPageBloc>().add(InsertPaymentRequest(event.paymentModel));
    final message = types.CustomMessage(
        author: event.myUser,
        id: const Uuid().v4(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
        metadata: {"type": "payment", "data": event.paymentModel.toJson()});

    emit(LoadingState());

    final data = await sl<ChatPageBloc>().initiateChat(
      InitiateChatEvent(
        event.context,
        null,
        event.myUser.id,
      ),
      otherUserAvatar: event.otherUserAvatar,
      otherUserName: event.otherUserName,
    );

    data.fold((l) => null, (data) async {
      await Future.wait([
        updateConversationUseCase(
            conversation: data.item1.copyWith(lastMessage: message)),
      ]);
      await sendMessageUseCase(
          message: message.copyWith(
        roomId: data.item1.id,
        remoteId: event.customerId,
      ));

      sl<ChatPageBloc>().updateChatsInRealtime();
      Navigator.pushNamed(event.context, AppRoutes.chat.main, arguments: data);
    });
  }
}
