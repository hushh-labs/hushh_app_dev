import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class SettingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SettingsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = sl<CardWalletPageBloc>();
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: true,
      centerTitle: false,
      titleSpacing: 0,
      shadowColor: Colors.black12,
      title: const Text("Settings"),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
