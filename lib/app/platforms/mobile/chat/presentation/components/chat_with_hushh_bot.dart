import 'package:flutter/material.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/ai_handler/prompt_gen.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:toastification/toastification.dart';

class ChatWithHushhBot extends StatelessWidget {
  const ChatWithHushhBot({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if(AppLocalStorage.hushhId == null) {
          ToastManager(Toast(
              title: 'Please complete profile',
              description: 'HushhAI can only be accessed once profile is completed',
              type: ToastificationType.error
          )).show(context);
          return;
        }
        Navigator.pushNamed(context, AppRoutes.chat.ai,
            arguments: PromptGen.hushhBotPrompt());
      },
      child: Container(
        height: 100.h / 11.12,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 1, color: Color(0xFFebebf7)),
          ),
          //color: Color(0xFFFFEFEE),
        ),
        child: Padding(
          padding: EdgeInsets.only(right: 100.w / 23.43, left: 100.w / 23.4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {},
                    child: CircleAvatar(
                      radius: 20.0,
                      child: ClipOval(
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(20),
                          child: Image.asset(
                            "assets/hbot.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  SizedBox(width: 100.w / 46.8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Hushh Bot",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      SizedBox(
                        ////increased the width from 0.45 to 0.60
                        /// so that sized box widith will be more and sent text can be seen properly

                        width: 100.w * 0.60,
                        child: const Text(
                          'Talk to Hushh Bot / upload bills for Insights',
                          style: TextStyle(
                            color: Color(0xFF7f7f97),
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          softWrap: false,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
