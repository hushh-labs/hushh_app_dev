import 'package:flutter/material.dart';

class ClaimBrandBottomSheet extends StatelessWidget {
  final Function() onClaim;
  final Function() onDeny;
  final String brandName;

  const ClaimBrandBottomSheet(
      {super.key,
      required this.onClaim,
      required this.onDeny,
      required this.brandName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            'Continue claiming "$brandName" ?',
            style: const TextStyle(
                fontFamily: 'Figtree',
                fontSize: 20,
                letterSpacing: -0.4,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                    color: Color(0xFF4C4C4C), fontFamily: 'Figtree'),
                children: [
                  const TextSpan(
                    text: 'If you are one of the Admin of ',
                  ),
                  TextSpan(
                      text: brandName,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  const TextSpan(
                    text: ' then you can claim the brand on Hushh marketplace.',
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEEEEEE),
                          elevation: 0,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      onPressed: onDeny,
                      child: const Text('Go back ↩'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEEEEEE),
                          elevation: 0,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      onPressed: onClaim,
                      child: const Text('Yeah! Go ahead'),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
