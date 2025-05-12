// ignore_for_file: use_build_context_synchronously, avoid_print, invalid_use_of_visible_for_testing_member

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart' as dartz;
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/fetch_user_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/auth/domain/usecases/update_user_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/chat/data/models/conversation.dart';
import 'package:hushh_app/app/platforms/mobile/chat/domain/usecases/delete_conversation_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/chat/domain/usecases/fetch_conversation_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/chat/domain/usecases/fetch_conversations_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/chat/domain/usecases/fetch_messages_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/chat/domain/usecases/insert_conversation_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/chat/domain/usecases/insert_payement_request_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/chat/domain/usecases/send_message_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/chat/domain/usecases/update_conversation_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/chat/domain/usecases/update_message_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/chat/domain/usecases/update_payement_request_use_case.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/ai_handler/ai_handler.dart';
import 'package:hushh_app/app/shared/core/backend_controller/db_controller/db_controller_impl.dart';
import 'package:hushh_app/app/shared/core/error_handler/error_state.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/mention_tag_text_field/mention_tag_text_editing_controller.dart';
import 'package:hushh_app/app/shared/core/models/payment_model.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

part 'events.dart';

part 'states.dart';

class ChatPageBloc extends Bloc<ChatPageEvent, ChatPageState> {
  final UpdateConversationUseCase updateConversationUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final UpdateMessageUseCase updateMessageUseCase;
  final FetchMessagesUseCase fetchMessagesUseCase;
  final UpdatePaymentRequestUseCase updatePaymentRequestUseCase;
  final InsertPaymentRequestUseCase insertPaymentRequestUseCase;
  final DeleteConversationUseCase deleteConversationUseCase;
  final FetchUserUseCase fetchUserUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final FetchConversationUseCase fetchConversationUseCase;
  final InsertConversationUseCase insertConversationUseCase;
  final FetchConversationsUseCase fetchConversationsUseCase;

  ChatPageBloc(
    this.sendMessageUseCase,
    this.updateMessageUseCase,
    this.fetchMessagesUseCase,
    this.updateConversationUseCase,
    this.updatePaymentRequestUseCase,
    this.deleteConversationUseCase,
    this.fetchUserUseCase,
    this.insertPaymentRequestUseCase,
    this.updateUserUseCase,
    this.fetchConversationUseCase,
    this.insertConversationUseCase,
    this.fetchConversationsUseCase,
  ) : super(ChatPageInitialState()) {
    on<SendMessageEvent>(sendMessageEvent);
    on<UpdateMessageEvent>(updateMessageEvent);
    on<InitiateChatEvent>(initiateChatEvent);
    on<SearchEvent>(searchEvent);
    on<DeleteChatEvent>(deleteChatEvent);
    on<PaymentStatusUpdateEvent>(paymentStatusUpdateEvent);
    on<ResetUnReadCountEvent>(resetUnReadCountEvent);
    on<InsertPaymentRequest>(insertPaymentRequest);
    on<FetchPaymentRequestAndMakePaymentAsUserEvent>(
        fetchPaymentRequestAndMakePaymentAsUserEvent);
  }

  StreamSubscription? chatSubscription;
  List<Conversation> chats = [];
  List<Conversation> initialChats = [];

  final MentionTagTextEditingController textEditingController =
      MentionTagTextEditingController();
  final TextEditingController searchController = TextEditingController();

  String get searchValue => searchController.text;

  Future<void> updateChatsInRealtime({Function(Function())? setState}) async {
    emit(SearchUpdatedState());
    if(sl<CardWalletPageBloc>().user != null) {
      chatSubscription =
          sl<DbController>().fetchConversationsStream().listen((event) async {
            event.sort((a, b) => b.lastMessage == null
                ? b.lastUpdated.compareTo(a.lastUpdated)
                : DateTime.fromMillisecondsSinceEpoch(b.lastMessage!.createdAt!)
                .compareTo(a.lastMessage == null
                ? a.lastUpdated
                : DateTime.fromMillisecondsSinceEpoch(
                a.lastMessage!.createdAt!)));
            chats = event;
            log(chats.map((e) => e.toJson()).toList().toString());
            if (setState != null) {
              setState(() {});
            }
            emit(ChatUpdatedState());
          });
    }
    if(AppLocalStorage.hushhId == null) {
      return;
    }
    final result = await fetchUserUseCase(uid: AppLocalStorage.hushhId);
    result.fold((l) => null, (r) {
      if (r != null) {
        AppLocalStorage.updateUser(r);
      }
    });
  }

  Future<List<Conversation>> getChats() async {
    final result = await fetchConversationsUseCase();
    result.fold((l) => null, (r) {
      return r;
    });
    return [];
  }

  FutureOr<void> sendMessageEvent(
      SendMessageEvent event, Emitter<ChatPageState> emit) async {
    Stream<String> addDelay(Stream<String> input) async* {
      Duration dur = const Duration(milliseconds: 60);
      await Future.delayed(dur);
      await for (var event in input) {
        yield event;
        await Future.delayed(dur);
      }
    }

    List mentions = textEditingController.mentions;
    textEditingController.clear();
    emit(MessageSendingState());
    await Future.wait([
      sendMessageUseCase(
          message: event.message.copyWith(
        roomId: event.conversation.id,
        remoteId: event.conversation.getOtherUser()?.item2,
      )),
      updateConversationUseCase(
          conversation: event.conversation.copyWith(
              lastMessage: event.message,
              unreadCount: event.conversation.unreadCount + 1)),
    ]);
    textEditingController.clear();
    emit(MessageSentState());

    if (mentions.isNotEmpty) {
      emit(MessageSendingState());
      final textMessage = types.TextMessage(
          id: const Uuid().v4(),
          author: const types.User(id: 'hushh-ai', firstName: 'HushhAI'),
          createdAt: DateTime.now().millisecondsSinceEpoch,
          updatedAt: DateTime.now().millisecondsSinceEpoch,
          roomId: event.conversation.id,
          remoteId: event.message.author.id,
          text: 'Thinking...');
      await Future.wait([
        sendMessageUseCase(message: textMessage),
      ]);
      final stream = AiHandler('').getChatResponseStream(
          navigatorKey.currentState!.context,
          (event.message as types.TextMessage).text,
          userId: event.conversation.getOtherUser()?.item2);
      bool convStarted = false;
      String id = const Uuid().v4();
      String text = '';
      addDelay(stream).listen(
        (e) async {
          log("<ACK>${e.toString()}<NQ>");
          try {
            final parsedEvent = e;
            if (convStarted) {
              text += parsedEvent;
            } else {
              convStarted = true;
              text = parsedEvent;
            }
          } catch (_) {}
        },
      ).onDone(() {
        sendMessage(id, event, text);
      });
    }
  }

  void sendMessage(id, event, text) async {
    emit(MessageSendingState());
    await sendMessageUseCase(
    message: types.TextMessage(
      author: const types.User(id: 'hushh-ai', firstName: 'HushhAI'),
      id: id,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      roomId: event.conversation.id,
      remoteId: event.message.author.id,
      text: text,
    ));
    emit(MessageSentState());
  }

  FutureOr<void> updateMessageEvent(
      UpdateMessageEvent event, Emitter<ChatPageState> emit) async {
    textEditingController.clear();
    emit(MessageSendingState());
    await Future.wait([
      updateMessageUseCase(message: event.message),
      updateConversationUseCase(
          conversation:
              event.conversation.copyWith(lastMessage: event.message)),
    ]);
    textEditingController.clear();
    emit(MessageSentState());
  }

  Future<dartz.Either<ErrorState, Tuple3<Conversation, File?, bool>>>
      initiateChat(InitiateChatEvent event, {bool dialog = true, String? otherUserAvatar, String? otherUserName}) async {
    Completer<dartz.Either<ErrorState, Tuple3<Conversation, File?, bool>>>
        completer = Completer();
    String commutativeFunction(String a, String b) {
      List<String> strings = [a, b];
      strings.sort();
      return strings.join();
    }

    final context = event.context;
    final file = event.file;
    final uid = event.uid;
    if (dialog) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.all(16),
                child: const CupertinoActivityIndicator(),
                // You can customize the dialog further if needed
              ),
            ],
          );
        },
      );
    }

    final myUid = AppLocalStorage.hushhId!;
    String conversationId = commutativeFunction(uid, myUid);
    List<String> otherConversations = [];
    final result1 = await fetchUserUseCase(uid: uid);
    result1.fold((l) => null, (otherUser) async {
      if (otherUser != null) {
        otherConversations = otherUser.conversations ?? [];
        if (!otherConversations.contains(conversationId)) {
          otherConversations.add(conversationId);
          await updateUserUseCase(
              uid: uid,
              user: otherUser.copyWith(conversations: otherConversations));
        }
      }

      final result2 = await fetchUserUseCase(uid: myUid);
      bool isAgent = sl<CardWalletPageBloc>().isAgent;
      result2.fold((l) => null, (myUser) async {
        List<String> conversations = myUser?.conversations ?? [];
        if (!conversations.contains(conversationId)) {
          conversations.add(conversationId);
          final res = await updateUserUseCase(
              uid: myUid, user: myUser!.copyWith(conversations: conversations));
          res.fold((l) => completer.complete(dartz.left(l)), (r) {
            sl<CardWalletPageBloc>().user!.conversations = conversations;
          });
        }

        if (!completer.isCompleted) {
          Conversation conversation = Conversation(
            participants: {
              myUid: {
                "avatar": myUser!.avatar,
                "name": myUser.name,
                "user_phone": myUser.phoneNumberWithCountryCode,
                "brand": event.brand?.toJson(),
              },
              uid: {
                "avatar": otherUser?.avatar ?? otherUserAvatar,
                "name": otherUser?.name ?? otherUserName,
                "user_phone": otherUser?.phoneNumberWithCountryCode,
                "brand": event.brand?.toJson(),
              }
            },
            type: sl<CardWalletPageBloc>().isAgent
                ? ConversationType.agent
                : ConversationType.user,
            id: conversationId,
            lastMessage: null,
            lastUpdated: DateTime.now(),
          );
          print("dskfjkldsj:${conversation.participants}");

          final conversationResult =
              await fetchConversationUseCase(conversationId: conversationId);
          conversationResult.fold((l) => null, (r) async {
            if (r == null) {
              await insertConversationUseCase(conversation: conversation);
            } else {
              conversation = r;
            }
          });

          updateChatsInRealtime();
          getChats().then((value) {
            initialChats = value;
          });
          if (dialog) {
            Navigator.pop(navigatorKey.currentState!.context);
          }
          completer.complete(dartz.right(
              Tuple3<Conversation, File?, bool>(conversation, file, isAgent)));
        }
      });
    });

    return completer.future;
  }

  // Future<dartz.Either<ErrorState, Tuple3<Conversation, File?, bool>>>
  //     initiateChat(InitiateChatEvent event, {bool dialog = true}) async {
  //   String commutativeFunction(String a, String b) {
  //     List<String> strings = [a, b];
  //     strings.sort();
  //     return strings.join();
  //   }
  //
  //   bool isAgent = sl<CardWalletPageBloc>().isAgent;
  //   final myUid = AppLocalStorage.hushhId!;
  //   final otherUid = event.uid;
  //   String conversationId = commutativeFunction(otherUid, myUid);
  //
  //   final supabase = Supabase.instance.client;
  //   final response =
  //       await supabase.rpc('create_conversation_and_update_users', params: {
  //     '_my_uid': myUid,
  //     '_other_uid': otherUid,
  //     '_conversation_id': conversationId,
  //     '_my_brand': event.brand?.toJson(),
  //     '_other_brand': event.brand?.toJson(),
  //     '_is_agent': isAgent,
  //   });
  //
  //   if (response.error != null) {
  //     return dartz.left(DataNetworkError(NetworkException.unknown, response));
  //   } else {
  //     print('Conversation created successfully!');
  //
  //     Conversation conversation = Conversation.fromJson(response.data);
  //
  //     return dartz.right(
  //         Tuple3<Conversation, File?, bool>(conversation, event.file, isAgent));
  //   }
  // }

  FutureOr<void> initiateChatEvent(
      InitiateChatEvent event, Emitter<ChatPageState> emit) async {
    final data = await initiateChat(event);
    data.fold((l) => null, (data) {
      emit(ChatUpdatedState());
      Navigator.pop(event.context);
      Navigator.pushNamed(event.context, AppRoutes.chat.main, arguments: data);
    });
  }

  FutureOr<void> searchEvent(SearchEvent event, Emitter<ChatPageState> emit) {
    emit(SearchUpdatedState());

    if (event.value.trim().isEmpty) {
      chatSubscription?.resume();
      updateChatsInRealtime(setState: event.setState);
    } else {
      if (!(chatSubscription?.isPaused ?? true)) chatSubscription?.pause();
      chats = initialChats.where((element) {
        final matchWithName = (element.getOtherUserInfo('name') as String?)
                ?.toLowerCase()
                .contains(event.value.toLowerCase()) ??
            false;
        final matchWithPhoneNumber =
            (element.getOtherUserInfo('user_phone') as String?)
                    ?.toLowerCase()
                    .contains(event.value.toLowerCase()) ??
                false;
        final matchWithBrand = (element.getOtherUserBrand())
                ?.brandName
                .toLowerCase()
                .contains(event.value.toLowerCase()) ??
            false;
        return matchWithName || matchWithPhoneNumber || matchWithBrand;
      }).toList();
    }
    emit(ChatUpdatedState());
  }

  FutureOr<void> deleteChatEvent(
      DeleteChatEvent event, Emitter<ChatPageState> emit) async {
    try {
      final result =
          await deleteConversationUseCase(conversation: event.conversation);
      result.fold((l) => null, (r) {
        chats.removeWhere((element) => element.id == event.conversation.id);
        initialChats
            .removeWhere((element) => element.id == event.conversation.id);
      });
    } catch (e) {
    }
    ToastManager(Toast(
      title:
          'Conversation with ${event.conversation.getOtherUserInfo('name')} is removed.',
      type: ToastificationType.success,
    )).show(event.context);
    event.conversation.participants.forEach((key, value) async {
      String uid = key;
      final result = await fetchUserUseCase(uid: uid);
      result.fold((l) => null, (user) async {
        if (user != null) {
          List<String> conversations = user.conversations ?? [];
          if (conversations.contains(event.conversation.id)) {
            conversations.remove(event.conversation.id);
          }
          await updateUserUseCase(
              uid: uid, user: user.copyWith(conversations: conversations));
        }
      });
    });
  }

  FutureOr<void> paymentStatusUpdateEvent(
      PaymentStatusUpdateEvent event, Emitter<ChatPageState> emit) {
    updatePaymentRequestUseCase(payment: event.paymentModel);
  }

  FutureOr<void> resetUnReadCountEvent(
      ResetUnReadCountEvent event, Emitter<ChatPageState> emit) async {
    updateConversationUseCase(
        conversation: event.conversation.copyWith(unreadCount: 0));
  }

  FutureOr<void> insertPaymentRequest(
      InsertPaymentRequest event, Emitter<ChatPageState> emit) async {
    await insertPaymentRequestUseCase(payment: event.paymentModel);
    await Supabase.instance.client.functions
        .invoke('notification-sender', body: {
      'userId': event.paymentModel.toUuid,
      'notification': {
        'id': NotificationsConstants.PAYMENT_REQUEST_RECEIVED_FROM_AGENT,
        'title': 'Payment request received!',
        'description': 'Tap to complete the transaction',
        'route': '/${AppRoutes.chat.main}',
        'status': 'success',
        'notification_type': 'interaction',
        'payload': {},
      }
    });
  }

  FutureOr<void> fetchPaymentRequestAndMakePaymentAsUserEvent(
      FetchPaymentRequestAndMakePaymentAsUserEvent event,
      Emitter<ChatPageState> emit) async {}
}
