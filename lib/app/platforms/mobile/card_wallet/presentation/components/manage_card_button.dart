import 'package:flutter/material.dart';

class ManageCardButton extends StatelessWidget {
  const ManageCardButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: ShapeDecoration(
        color: Color(0xFF108BFC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Center(
        child: Text(
          'Manage card',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontFamily: 'Figtree',
            fontWeight: FontWeight.w700,
            height: 1,
            letterSpacing: 0.20,
          ),
        ),
      ),
    );
  }
}
