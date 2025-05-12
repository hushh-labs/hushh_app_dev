import 'package:flutter/material.dart';
import 'package:hushh_app/app/shared/config/constants/colors.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: CustomColors.projectBaseBlue,
    );
  }
}
