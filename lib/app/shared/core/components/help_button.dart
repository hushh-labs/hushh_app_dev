import 'package:flutter/material.dart';

class HelpButton extends StatelessWidget {
  const HelpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFFE51A5E),
        minimumSize: const Size(60, 28),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFFE51A5E))
        )
      ),
      onPressed: () {},
      child: const Text('HELP'),
    );
  }
}


class VerifyButton extends StatelessWidget {
  final Function() onVerify;
  const VerifyButton({super.key, required this.onVerify});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          foregroundColor: const Color(0xFFE51A5E),
          minimumSize: const Size(76, 28),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Color(0xFFE51A5E))
          )
      ),
      onPressed: onVerify,
      child: const Text('VERIFY'),
    );
  }
}

class AcceptButton extends StatelessWidget {
  final Function() onAccept;
  const AcceptButton({super.key, required this.onAccept});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          foregroundColor: const Color(0xFFE51A5E),
          minimumSize: const Size(76, 28),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Color(0xFFE51A5E))
          )
      ),
      onPressed: onAccept,
      child: const Text('ACCEPT'),
    );
  }
}
