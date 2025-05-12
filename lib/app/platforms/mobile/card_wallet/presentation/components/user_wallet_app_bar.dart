import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/profile_expanded_popup.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/user_coins_elevated_button.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/splash/presentation/bloc/splash_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';

class UserWalletAppBar extends StatelessWidget {
  const UserWalletAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder(
          bloc: sl<HomePageBloc>(),
          builder: (context, state) {
            if (AppLocalStorage.user?.avatar?.isNotEmpty ?? false) {
              return Row(
                children: [
                  InkWell(
                    onTap: () async {
                      await showDialog(
                          context: context,
                          builder: (_) => const ProfileExpandedPopup());
                    },
                    child: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                          AppLocalStorage.user!.avatar!),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              );
            }
            return const SizedBox();
          },
        ),
        const Text('Wallet',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 24,
            )),
        const Icon(
          Icons.lock_outline,
          size: 12,
        ),
        const Spacer(),
        const UserCoinsElevatedButton(),
        const SizedBox(width: 12),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.cardWallet.notifications);
          },
          child: Transform.scale(
              scale: 1.05, child: SvgPicture.asset('assets/noti_icon.svg')),
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.cardWallet.settings);
          },
          child: Transform.scale(
              scale: 1.05,
              child: SvgPicture.asset('assets/appbar_settings_icon.svg')),
        )
      ],
    );
  }
}
