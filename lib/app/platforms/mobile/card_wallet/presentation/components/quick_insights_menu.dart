import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:tuple/tuple.dart';

class QuickInsightMenu extends StatelessWidget {
  final Tuple3<String, String, Function()> quickInsightMenu;

  const QuickInsightMenu({super.key, required this.quickInsightMenu});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => quickInsightMenu.item3.call(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            color: const Color(0xFFFCF7FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE8D1D6))),
        child: Row(
          children: [
            Image.asset(
              quickInsightMenu.item1,
              width: 32,
              color: Colors.black,
            ),
            const SizedBox(width: 12),
            Expanded(
                child: AutoSizeText(
              quickInsightMenu.item2,
              maxLines: 2,
              wrapWords: false,
              style: context.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ))
          ],
        ),
      ),
    );
  }
}
