import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/agent_card_wallet/bloc.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/components/gradient_text.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class AgentProfileTabBar extends StatelessWidget
    implements PreferredSizeWidget {
  final Function(int) onTap;

  const AgentProfileTabBar({super.key, required this.onTap});

  TabController get tabController =>
      sl<AgentCardWalletPageBloc>().profileTabController;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kTextTabBarHeight),
      child: Container(
        color: Colors.white,
        child: TabBar(
          controller: tabController,
          indicatorPadding: const EdgeInsets.only(top: 45),
          indicatorWeight: 4.0,
          physics: const NeverScrollableScrollPhysics(),
          indicatorSize: TabBarIndicatorSize.tab,
          labelPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
          indicator: const ShapeDecoration(
              shape: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 4.0,
                      style: BorderStyle.solid)),
              gradient: LinearGradient(
                  colors: [Color(0XFFA342FF), Color(0XFFE54D60)])),
          onTap: onTap,
          unselectedLabelStyle: context.titleMedium?.copyWith(
              fontWeight: FontWeight.w600, color: const Color(0xFFC0C0C0)),
          tabs: [
            Tab(
              child: tabController.index == 0
                  ? const GradientText(
                      'Lookbooks',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                      gradient: LinearGradient(
                          colors: [Color(0xFFA342FF), Color(0xFFE54D60)]),
                    )
                  : const Text("Lookbooks",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            ),
            Tab(
              child: tabController.index == 1
                  ? const GradientText(
                      'Products',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                      gradient: LinearGradient(
                          colors: [Color(0xFFA342FF), Color(0xFFE54D60)]),
                    )
                  : const Text("Products",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            ),
          ],
          dividerColor: const Color(0xFFe8d1d6),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
