import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomePageBottomNavigationBar extends StatelessWidget {
  const HomePageBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = sl<HomePageBloc>();
    return BlocBuilder(
        bloc: controller,
        builder: (context, state) {
          final tabIndex = controller.currentIndex;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0)
                .copyWith(bottom: Platform.isIOS ? 24 : 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0xffb1b1b1),
                  blurRadius: .5,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem('assets/card_bottom_bar_icon.svg', 'Cards', 0,
                    tabIndex, context),
                _buildNavItem('assets/receipt_bottom_bar_icon.svg', 'Receipts',
                    1, tabIndex, context),
                _buildNavItem('assets/agent_bottom_bar_icon.svg', 'Discover', 2,
                    tabIndex, context),
                _buildNavItem('assets/chat_bottom_bar_icon.svg', 'Chat', 3,
                    tabIndex, context),
              ],
            ),
          );
        });
  }

  Widget _buildNavItem(
      String icon, String label, int index, tabIndex, context) {
    return GestureDetector(
      onTap: () {
        if (Platform.isIOS) {
          HapticFeedback.lightImpact();
        } else {
          HapticFeedback.vibrate();
        }
        sl<HomePageBloc>().add(UpdateHomeScreenIndexEvent(index, context));
      },
      child: Container(
        width: 100.w / 4,
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildGradientIcon(icon, index == tabIndex),
            const SizedBox(height: 4),
            _buildGradientText(label, index == tabIndex),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientIcon(String icon, bool isSelected) {
    return Container(
      padding: isSelected
          ? const EdgeInsets.symmetric(horizontal: 16, vertical: 6)
          : null,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF616180) : null,
        gradient: !isSelected
            ? null
            : const LinearGradient(
                colors: [Colors.purple, Colors.pinkAccent],
              ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: SvgPicture.asset(
        icon,
        color: !isSelected ? const Color(0xFF616180) : Colors.white,
        width: 20,
        height: 20,
      ),
    );
  }

  Widget _buildGradientText(String text, bool isSelected) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          colors: [Colors.purple, Colors.pinkAccent],
        ).createShader(bounds);
      },
      child: Text(text,
          style: TextStyle(
              color: !isSelected ? const Color(0xFF616180) : Colors.white,
              fontSize: 14)),
    );
  }
}
