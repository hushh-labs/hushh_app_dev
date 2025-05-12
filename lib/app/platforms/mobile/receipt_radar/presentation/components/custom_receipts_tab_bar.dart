import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomReceiptsTabBar extends StatelessWidget {
  final TabController tabController;
  final Function(int?) onValueChanged;

  const CustomReceiptsTabBar({
    super.key,
    required this.tabController,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
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
              "Receipts",
              style: TextStyle(
                  fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400),
            ),
          },
          onValueChanged: onValueChanged,
        ),
      ),
    );
  }
}
