import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/platforms/mobile/chat/presentation/bloc/chat_bloc/bloc.dart';
import 'package:hushh_app/app/shared/core/components/hushh_contacts_bottom_sheet.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ChatHistoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool newScreen;
  final Function(Function()) setState;

  const ChatHistoryAppBar({super.key, this.newScreen = false, required this.setState});

  @override
  Widget build(BuildContext context) {
    final controller = sl<ChatPageBloc>();
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      flexibleSpace: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                if (newScreen) ...[
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ]
                else const SizedBox(width: 16),
                const Text(
                  'Chats',
                  style: TextStyle(
                    fontSize: 28.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    icon: Image.asset(
                      "assets/chat_icon_megnta.png",
                      color: Colors.black,
                      width: 23,
                    ),
                    onPressed: () async {
                      showModalBottomSheet(
                          enableDrag: true,
                          isDismissible: true,
                          backgroundColor: Colors.white,
                          isScrollControlled: true,
                          context: context,
                          showDragHandle: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20)),
                          ),
                          builder: (context) =>
                              const HushhContactsBottomSheet());
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding:
                  EdgeInsets.only(right: 20, left: 20, bottom: 100.h / 50.75),
              child: SizedBox(
                height: 40,
                child: TextFormField(
                  autofocus: false,
                  controller: controller.searchController,
                  onChanged: (value) {
                    controller.add(SearchEvent(value, setState));
                    setState((){});
                  },
                  style:
                      const TextStyle(fontSize: 14.0, color: Color(0xff181941)),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    filled: true,
                    fillColor: const Color(0xFFf5f5fd),
                    hintText: 'Brand, phone number or name',
                    hintStyle: const TextStyle(
                      fontSize: 14.0,
                      color: Color(0xFF7f7f97),
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(6),
                      child: SvgPicture.asset(
                        'assets/search_new.svg',
                        color: const Color(0xFF616180),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xFFf5f5fd),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xFFf5f5fd),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xFFf5f5fd),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(120);
}
