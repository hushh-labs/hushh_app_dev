import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/shared/config/assets/icon.dart';

class DeleteMyAccountAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const DeleteMyAccountAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 5,
      titleSpacing: 16,
      automaticallyImplyLeading: false,
      toolbarHeight: 72,
      leading: IconButton(
        padding: const EdgeInsets.only(left: 26),
        icon: SvgPicture.asset(
          AppIcons.backArrow_narrow,
          color: Colors.black,
          height: 19.5,
          width: 16,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        "Delete my account",
        style: TextStyle(
            color: Colors.black, fontSize: 28, fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
