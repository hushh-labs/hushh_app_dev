import 'package:flutter/material.dart';

class ReceiptRadarButton extends StatelessWidget {
  final String text;
  final bool filled;
  final Function() onTap;

  const ReceiptRadarButton({
    super.key,
    required this.text,
    this.filled = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    if (filled)
      return InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                Color(0xFFA342FF),
                Color(0xFFE54D60),
              ])),
          child: Center(
            child: Text(
              text,
              style: textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      );
    else
      return ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFFE54D60), Color(0xFFA342FF)]).createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        ),
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: Center(
              child: Text(
                text,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
  }
}
