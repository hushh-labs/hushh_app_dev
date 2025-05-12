import 'package:flutter/material.dart';

class LoadMoreButton extends StatelessWidget {
  final Function() onTap;

  const LoadMoreButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: Color(0xFFE51A5E),
          backgroundColor: Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.keyboard_arrow_down_sharp),
            SizedBox(width: 4),
            Text('Load more'),
          ],
        ),
      ),
    );
  }
}
