import 'package:flutter/material.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';

class CardWalletSection extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? sideComponent;

  const CardWalletSection(
      {super.key, required this.title, required this.child, this.sideComponent});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Text(
                title.toUpperCase(),
                style: context.titleSmall?.copyWith(
                  color: const Color(0xFF737373),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.3,
                ),
              ),
              const Spacer(),
              sideComponent ?? const SizedBox()
            ],
          ),
        ),
        const SizedBox(height: 12),
        child
      ],
    );
  }
}
