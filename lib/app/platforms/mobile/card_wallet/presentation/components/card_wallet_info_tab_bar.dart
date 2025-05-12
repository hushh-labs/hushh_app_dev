import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class CardWalletInfoTabBar extends StatefulWidget {
  final List<String> tabs;
  final Function(int) onTabChanged;

  const CardWalletInfoTabBar({
    Key? key,
    required this.tabs,
    required this.onTabChanged,
  }) : super(key: key);

  @override
  State<CardWalletInfoTabBar> createState() => _CardWalletInfoTabBarState();
}

class _CardWalletInfoTabBarState extends State<CardWalletInfoTabBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 8),
      child: Row(
        children: List.generate(
          widget.tabs.length,
          (index) => Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  sl<CardWalletPageBloc>().selectedCardWalletInfoTabIndex =
                      index;
                });
                widget.onTabChanged(index);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  color:
                      sl<CardWalletPageBloc>().selectedCardWalletInfoTabIndex ==
                              index
                          ? Colors.black
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  widget.tabs[index],
                  style: TextStyle(
                    color: sl<CardWalletPageBloc>()
                                .selectedCardWalletInfoTabIndex ==
                            index
                        ? Colors.white
                        : const Color(0xFF191919),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
