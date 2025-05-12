import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';

class UserCoinsElevatedButton extends StatelessWidget {
  const UserCoinsElevatedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: sl<CardWalletPageBloc>(),
        builder: (context, state) {
          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.cardWallet.coins);
            },
            child: Container(
              constraints: const BoxConstraints(minWidth: 56),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(38),
                color: Colors.black,
                // gradient: const LinearGradient(
                //   colors: [
                //     Color(0xFFE54D60),
                //     Color(0xFFA342FF),
                //   ],
                //   begin: Alignment.centerLeft,
                //   end: Alignment.centerRight,
                // ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    'assets/hushh_s_logo.png',
                    color: Colors.white,
                    height: 12,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    AppLocalStorage.user?.userCoins?.toString() ?? "0",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
