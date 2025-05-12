import 'package:flutter/material.dart';

class OnboardingPageIndicator extends StatelessWidget {
  final int index;
  final int currentIndex;

  const OnboardingPageIndicator(
      {super.key, required this.index, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      height: index == currentIndex ? 10.0 : 6.0,
      width: index == currentIndex ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color: index == currentIndex ? Colors.black : Colors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
