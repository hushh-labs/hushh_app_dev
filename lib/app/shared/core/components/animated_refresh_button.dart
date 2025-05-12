import 'package:flutter/material.dart';

class AnimatedRefreshButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Duration animationDuration;

  const AnimatedRefreshButton({
    Key? key,
    required this.onPressed,
    this.animationDuration = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  _AnimatedRefreshButtonState createState() => _AnimatedRefreshButtonState();
}

class _AnimatedRefreshButtonState extends State<AnimatedRefreshButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePressed() {
    _controller.forward(from: 0.0);
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: RotationTransition(
        turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
        child: const Icon(Icons.refresh),
      ),
      onPressed: _handlePressed,
    );
  }
}

// Example usage:
// AnimatedRefreshButton(
//   onPressed: () {
//     // Your refresh logic here
//     print('Refresh button pressed!');
//   },
// )