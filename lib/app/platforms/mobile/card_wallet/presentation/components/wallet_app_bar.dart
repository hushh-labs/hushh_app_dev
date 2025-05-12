import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/agent_wallet_app_bar.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/user_wallet_app_bar.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class WalletAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(Function()) setState;

  const WalletAppBar({super.key, required this.setState});

  bool get isUser => sl<HomePageBloc>().entity == Entity.user;

  @override
  Widget build(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: BlocBuilder(
            bloc: sl<CardWalletPageBloc>(),
            builder: (context, state) {
              return isUser
                  ? const UserWalletAppBar()
                  : const AgentWalletAppBar();
            }));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
