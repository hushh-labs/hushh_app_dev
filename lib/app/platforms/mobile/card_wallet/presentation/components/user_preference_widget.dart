import 'package:flutter/material.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:tuple/tuple.dart';

class UserPreferenceWidget extends StatelessWidget {
  final Tuple2<String, String> pref;

  const UserPreferenceWidget({super.key, required this.pref});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xFFFCFAF7),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xFFE8DECF))),
      child: Row(
        children: [
          SizedBox(width: 16),
          Image.asset(pref.item1, width: 28),
          SizedBox(width: 8),
          Text(pref.item2,
              style: context.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              )),
        ],
      ),
    );
  }
}
