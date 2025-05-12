import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/chat/data/models/conversation.dart';

class ProfileImageBottomSheet extends StatelessWidget {
  final Conversation conversation;

  const ProfileImageBottomSheet({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width - 100,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: (conversation.getOtherUserInfo('avatar') != null
                    ? NetworkImage(conversation.getOtherUserInfo('avatar'))
                    : ExactAssetImage('assets/user.png') as ImageProvider),
                fit: BoxFit.cover)),
      ),
    );
  }
}
