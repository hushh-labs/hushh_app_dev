import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class NotificationsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const NotificationsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
          onPressed: () {
            sl<CardWalletPageBloc>()
                .add(CardWalletInitializeEvent(context, refresh: true));
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_sharp,
            color: Colors.black,
          )),
      centerTitle: true,
      title: Text(
        'Notifications',
        style: TextStyle(
            fontWeight: FontWeight.w600, fontSize: 20, color: Colors.black),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
