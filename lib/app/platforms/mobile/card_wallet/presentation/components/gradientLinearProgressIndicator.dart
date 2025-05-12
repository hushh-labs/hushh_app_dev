import 'package:flutter/material.dart';

class GradientLinearProgressIndicator extends StatelessWidget {
  final double value;
  final Color backgroundColor;
  final Gradient gradient;

  const GradientLinearProgressIndicator({
    Key? key,
    required this.value,
    this.backgroundColor = Colors.grey,
    required this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 10,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: value,
          child: Container(
            height: 10,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
