import 'package:flutter/material.dart';

class DeleteMyAccountHeading extends StatelessWidget {
  const DeleteMyAccountHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyLarge,
            children: [
              const TextSpan(
                  text: 'YOUR',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 28)),
              TextSpan(
                text: ' DATA',
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 28),
              ),
              TextSpan(
                text: ' IS',
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 28),
              ),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyLarge,
            children: [
              const TextSpan(
                  text: 'SECURE',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 28)),
              TextSpan(
                text: ' WITH',
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 28),
              ),
              TextSpan(
                text: ' US',
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 28),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
