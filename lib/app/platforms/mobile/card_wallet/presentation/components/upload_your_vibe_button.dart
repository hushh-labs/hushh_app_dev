import 'package:flutter/material.dart';

class UploadYourVibeButton extends StatelessWidget {
  const UploadYourVibeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment(-1.00, 0.05),
          end: Alignment(1, -0.05),
          colors: [
            Color(0xFFA342FF),
            Color(0xFFE54D60),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.69),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 21,
            height: 24,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(),
            child: Image.asset(
              "assets/folderArrow.png",
              height: 24, // Adjust the height as needed
            ),
          ),
          SizedBox(
            width: 6,
          ),
          Text(
            "Share your vibe",
            style: TextStyle(
                fontWeight: FontWeight.w700, fontSize: 12, color: Colors.white),
          )
        ],
      ),
    );
  }
}
