import 'package:flutter/material.dart';

class LinkedInLoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  LinkedInLoginButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0077B5), // LinkedIn blue color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      onPressed: onPressed,
      icon: Image.network(
        'https://upload.wikimedia.org/wikipedia/commons/c/ca/LinkedIn_logo_initials.png', // Add LinkedIn logo in your assets folder
        height: 24,
        width: 24,
      ),
      label: const Text(
        'Sign in with LinkedIn',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
