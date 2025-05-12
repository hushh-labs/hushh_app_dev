import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCardWalletTabBar extends StatelessWidget {
  final TabController tabController;
  final Function(int?) onValueChanged;

  const CustomCardWalletTabBar({
    super.key,
    required this.tabController,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CupertinoSlidingSegmentedControl<int>(
        backgroundColor: CupertinoColors.extraLightBackgroundGray,
        thumbColor: CupertinoColors.white,
        groupValue: tabController.index,
        children: const {
          0: Text(
            "Brand Cards",
            style: TextStyle(
                fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400),
          ),
          1: Text(
            "General Preference",
            style: TextStyle(
                fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400),
          ),
        },
        onValueChanged: onValueChanged,
      ),
    );
  }
}
