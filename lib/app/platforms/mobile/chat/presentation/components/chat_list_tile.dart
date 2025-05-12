import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:hushh_app/app/platforms/mobile/chat/data/models/conversation.dart';
import 'package:hushh_app/app/platforms/mobile/chat/presentation/bloc/chat_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/chat/presentation/components/profile_image_bottom_sheet.dart';
import 'package:hushh_app/app/shared/config/constants/colors.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tuple/tuple.dart';

class ChatListTile extends StatelessWidget {
  final Conversation conversation;

  const ChatListTile({super.key, required this.conversation});

  String getLastMessageAsText(types.Message message) {
    bool notYourMessage = conversation.lastMessage != null &&
        conversation.lastMessage!.author.id != AppLocalStorage.hushhId;
    String prefix = !notYourMessage ? "You: " : "";
    if (message is types.TextMessage) {
      return "$prefix${message.text}";
    }
    if (message is types.ImageMessage) {
      return "$prefix🏞️ Image";
    }
    if (message is types.CustomMessage &&
        message.metadata?['type'] == 'meeting') {
      return "$prefix📆 Meeting";
    }
    if (message is types.FileMessage) {
      return "$prefix📄 Document";
    }
    if (message is types.CustomMessage &&
        message.metadata?['type'] == 'payment') {
      return "$prefix💲 Payment Request";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          await Navigator.pushNamed(context, AppRoutes.chat.main,
              arguments: Tuple3<Conversation, File?, bool>(conversation, null,
                  conversation.type == ConversationType.agent));
          sl<ChatPageBloc>().updateChatsInRealtime();
        },
        child: Container(
          padding: EdgeInsets.only(right: 100.w / 23.43, left: 100.w / 23.4),
          height: 100.h / 11.12,
          width: 100.w,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1, color: Color(0xFFebebf7)),
            ),
            //color: Color(0xFFFFEFEE),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  await showDialog(
                      context: context,
                      builder: (_) =>
                          ProfileImageBottomSheet(conversation: conversation));
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(20),
                          child: conversation.getOtherUserInfo('avatar') != null
                              ? CachedNetworkImage(
                                  imageUrl:
                                      conversation.getOtherUserInfo('avatar'))
                              : Image.asset('assets/user.png'),
                        ),
                      ),
                    ),
                    if (conversation.getOtherUserBrand() != null)
                      Positioned(
                        right: -5,
                        bottom: -5,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.black,
                          backgroundImage: CachedNetworkImageProvider(
                              conversation.getOtherUserBrand()!.logo),
                        ),
                      )
                  ],
                ),
              ),
              SizedBox(width: 100.w / 46.8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      ((conversation.getOtherUserInfo('name') ?? '') as String)
                          .capitalize(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (conversation.lastMessage != null) ...[
                      const SizedBox(height: 2.0),
                      SizedBox(
                        width: 45.w,
                        child: Text(
                          getLastMessageAsText(conversation.lastMessage!),
                          style: const TextStyle(
                            color: Color(0xFF7f7f97),
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
              if (conversation.lastMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat(DateTime.fromMillisecondsSinceEpoch(
                                        conversation.lastMessage!.updatedAt!)
                                    .isBefore(DateTime.now()
                                        .subtract(const Duration(days: 1)))
                                ? "dd MMM\nhh:mm aa"
                                : "hh:mm aa")
                            .format(DateTime.fromMillisecondsSinceEpoch(
                                conversation.lastMessage!.updatedAt!)),
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Color(0xFF7f7f97),
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (conversation.lastMessage != null &&
                          conversation.lastMessage!.author.id !=
                              AppLocalStorage.hushhId &&
                          conversation.unreadCount != 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: Container(
                            width: 17,
                            height: 17,
                            decoration: BoxDecoration(
                                color: CustomColors.projectBaseBlue,
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: Text(
                                "${conversation.unreadCount}",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 9),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ));
  }
}
