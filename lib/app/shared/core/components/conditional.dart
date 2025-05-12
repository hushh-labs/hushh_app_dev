import 'package:flutter/material.dart';

class Conditional extends StatelessWidget {
  final bool cond;
  final Widget ifChild;
  final Widget elseChild;

  const Conditional(
      {super.key,
      required this.cond,
      required this.ifChild,
      required this.elseChild});

  @override
  Widget build(BuildContext context) {
    return cond ? ifChild : elseChild;
  }
}
