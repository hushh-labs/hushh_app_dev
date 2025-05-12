import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class VerifyingBottomSheet extends StatelessWidget {
  final bool checkout;

  const VerifyingBottomSheet({super.key, this.checkout = false});

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
          const Text(
            'Verifying...',
            style: TextStyle(
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
                style:
                    const TextStyle(color: Color(0xFF4C4C4C), fontFamily: 'Figtree'),
                children: [
                  TextSpan(
                    text: checkout
                        ? 'Please DO NOT CLOSE while we are processing the payment request.'
                        : 'We are fetching your document details, please do not click back...',
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              child: Center(
            child: Transform.scale(
                scale: 2, child: Lottie.asset('assets/custom_loader.json')),
          ))
        ],
      ),
    );
  }
}
