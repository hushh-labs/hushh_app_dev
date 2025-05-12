import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCardMarketTabBar extends StatelessWidget {
  final TabController tabController;
  final Function(int?) onValueChanged;

  const CustomCardMarketTabBar({
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
            "Brand",
            style: TextStyle(
                fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400),
          ),
          1: Text(
            "General",
            style: TextStyle(
                fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400),
          ),
        },
        onValueChanged: onValueChanged,
      ),
    );
  }
}
