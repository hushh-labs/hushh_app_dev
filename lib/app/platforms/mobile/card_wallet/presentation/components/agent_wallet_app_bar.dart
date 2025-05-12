import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/agent_card_wallet/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/components/request_payment_page.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:toastification/toastification.dart';

class AgentWalletAppBar extends StatelessWidget {
  const AgentWalletAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Agent Wallet',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 24,
            )),
        if (AppLocalStorage.agent?.role == AgentRole.Admin)
          Container(
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.only(left: 6),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Text(
              AppLocalStorage.agent!.role!.name,
              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5),
            ),
          ),
        const Spacer(),
        Row(
          children: [
            BlocBuilder(
              bloc: sl<AgentCardWalletPageBloc>(),
              builder: (context, state) {
                return InkWell(
                  onTap: () async {
                    if(AppLocalStorage.agent == null) {
                      ToastManager(Toast(
                          title: 'Please complete profile',
                          description: 'Complete your profile to earn Hushh coins',
                          type: ToastificationType.error
                      )).show(context);
                      return;
                    }
                    Map? payment = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RequestPaymentPage()));
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
                          AppLocalStorage.agent?.agentCoins?.toString() ?? "0",
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
              }
            ),
            const SizedBox(width: 12),
            InkWell(
              onTap: () {
                Navigator.pushNamed(
                    context, AppRoutes.cardWallet.notifications);
              },
              child: Transform.scale(
                  scale: 1.05, child: SvgPicture.asset('assets/noti_icon.svg')),
            ),
          ],
        )
      ],
    );
  }
}
