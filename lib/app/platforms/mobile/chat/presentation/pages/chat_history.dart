import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/chat/presentation/bloc/chat_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/chat/presentation/components/chat_history_app_bar.dart';
import 'package:hushh_app/app/platforms/mobile/chat/presentation/components/chat_list_tile.dart';
import 'package:hushh_app/app/platforms/mobile/chat/presentation/components/chat_with_hushh_bot.dart';
import 'package:hushh_app/app/platforms/mobile/chat/presentation/components/delete_conversation_bottomsheet.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ChatHistory extends StatefulWidget {
  final bool newScreen;

  const ChatHistory({super.key, this.newScreen = false});

  @override
  State<ChatHistory> createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {
  final controller = sl<ChatPageBloc>();

  @override
  void initState() {
    controller.updateChatsInRealtime(setState: setState);
    controller.getChats().then((value) {
      controller.initialChats = value;
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.chatSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ChatHistoryAppBar(newScreen: widget.newScreen, setState: setState),
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: () async {},
        child: BlocBuilder(
            bloc: controller,
            builder: (context, state) {
              final chats = controller.chats;
              chats.sort((a, b) =>
              b.lastMessage == null
                  ? b.lastUpdated.compareTo(a.lastUpdated)
                  : DateTime.fromMillisecondsSinceEpoch(b.lastMessage!.createdAt!)
                  .compareTo(a.lastMessage == null
                  ? a.lastUpdated
                  : DateTime.fromMillisecondsSinceEpoch(
                  a.lastMessage!.createdAt!)));
              return ListView(
                physics: const ClampingScrollPhysics(),
                children: [
                  if (controller.searchValue.trim().isEmpty)
                    const ChatWithHushhBot(),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: chats.length,
                    padding: EdgeInsets.only(top: 1.w),
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        key: Key(chats[index].id),
                        background: Container(
                          color: Colors.red,
                          child: const Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 16.0),
                              child: Icon(
                                Icons.delete_outline,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        confirmDismiss: (direction) async {
                          Completer<bool> completer = Completer();
                          if (direction == DismissDirection.endToStart) {
                            final value = await showModalBottomSheet(
                              isDismissible: true,
                              enableDrag: true,
                              backgroundColor: Colors.transparent,
                              constraints: BoxConstraints(maxHeight: 30.h),
                              context: context,
                              builder: (_context) {
                                return DeleteConversationBottomSheet(
                                    name: chats.isEmpty
                                        ? ''
                                        : chats[index]
                                                .getOtherUserInfo('name') ??
                                            '',
                                    onCancel: () {
                                      Navigator.pop(context, false);
                                    },
                                    onDelete: () {
                                      completer.complete(true);
                                      Navigator.pop(context, true);
                                    });
                              },
                            );
                            if (value != true) completer.complete(false);
                          } else {
                            completer.complete(false);
                          }
                          return completer.future;
                        },
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          controller.add(DeleteChatEvent(
                              chats[index], context));
                        },
                        child:
                            ChatListTile(conversation: chats[index]),
                      );
                    },
                  )
                ],
              );
            }),
      ),
    );
  }
}
