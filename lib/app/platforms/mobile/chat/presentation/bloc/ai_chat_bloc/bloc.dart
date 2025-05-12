import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/chat/domain/usecases/fetch_ai_messages_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/chat/domain/usecases/send_ai_message_use_case.dart';
import 'package:hushh_app/app/platforms/mobile/chat/domain/usecases/update_ai_message_use_case.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';

part 'events.dart';

part 'states.dart';

class AiChatPageBloc extends Bloc<AiChatPageEvent, AiChatPageState> {
  final SendAiMessageUseCase sendMessageUseCase;
  final UpdateAiMessageUseCase updateMessageUseCase;
  final FetchAiMessagesUseCase fetchMessagesUseCase;

  AiChatPageBloc(this.sendMessageUseCase, this.updateMessageUseCase,
      this.fetchMessagesUseCase)
      : super(AiChatPageInitialState()) {
    on<SendMessageEvent>(sendMessageEvent);
    on<UpdateMessageEvent>(updateMessageEvent);
    on<FetchMessagesEvent>(fetchMessagesEvent);
  }

  types.User get myUser => types.User(
      id: AppLocalStorage.hushhId ?? "",
      firstName: sl<CardWalletPageBloc>().user?.name);
  types.User get otherUser => const types.User(id: 'hushh_ai_bot', firstName: 'Hushh AI');
  List<types.Message> messages = [];
  final TextEditingController textEditingController = TextEditingController();

  FutureOr<void> sendMessageEvent(
      SendMessageEvent event, Emitter<AiChatPageState> emit) async {
    emit(MessageSendingState());
    await sendMessageUseCase(
        message: event.message.copyWith(roomId: AppLocalStorage.hushhId!));
    emit(MessageSentState());
  }

  FutureOr<void> updateMessageEvent(
      UpdateMessageEvent event, Emitter<AiChatPageState> emit) async {
    emit(MessageSendingState());
    await updateMessageUseCase(
        message: event.message.copyWith(roomId: AppLocalStorage.hushhId!));
    emit(MessageSentState());
  }

  FutureOr<void> fetchMessagesEvent(
      FetchMessagesEvent event, Emitter<AiChatPageState> emit) async {
    emit(FetchingMessageState());
    final result = await fetchMessagesUseCase(roomId: AppLocalStorage.hushhId!);
    result.fold((l) => null, (r) {
      messages = r;
      emit(FetchedState());
    });
    // final data = await fireStore
    //     .collection('ai_conversations')
    //     .doc(AppLocalStorage.hushhId! +
    //         (sl<CardWalletPageBloc>().isAgent ? "_agent" : "_user"))
    //     .collection('messages')
    //     .orderBy('createdAt', descending: true)
    //     .get();
  }
}
