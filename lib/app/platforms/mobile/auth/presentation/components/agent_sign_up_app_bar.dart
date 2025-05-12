import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgentSignUpAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AgentSignUpAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: SvgPicture.asset('assets/back.svg')),
      ),
      centerTitle: true,
      title: const Text(
        'Agent sign up',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
