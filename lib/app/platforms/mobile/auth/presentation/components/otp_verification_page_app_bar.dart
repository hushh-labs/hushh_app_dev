import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OtpVerificationAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final bool email;

  const OtpVerificationAppBar({super.key, this.email = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Text(
        email ? "Confirm your email" : "Confirm your number",
        style: TextStyle(
            color: Colors.black, fontSize: 24, fontWeight: FontWeight.w700),
      ),
      leading: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset("assets/back_new.svg"),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
