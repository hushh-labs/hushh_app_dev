import 'package:flutter/material.dart';

class DeleteAudioPromptBottomSheet extends StatelessWidget {
  final Function() onDelete;
  final Function() onCancel;

  const DeleteAudioPromptBottomSheet(
      {super.key, required this.onDelete, required this.onCancel});

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
            'Delete Audio Prompt?',
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
              text: const TextSpan(
                style:
                    TextStyle(color: Color(0xFF4C4C4C), fontFamily: 'Figtree'),
                children: [
                  TextSpan(
                    text: 'Are you sure to delete the audio ',
                  ),
                  TextSpan(
                    text: '? This action cannot be undone.',
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
                      child: const Text('Go back ↩'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEEEEEE),
                          elevation: 0,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      onPressed: onCancel,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      child: const Text('Yeah! Go ahead'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEEEEEE),
                          elevation: 0,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      onPressed: onDelete,
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
