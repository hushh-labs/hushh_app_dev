import 'package:flutter/material.dart';

// Header Banner Widget
class AllStorePageHeaderSection extends StatelessWidget {
  final String imagePath;

  const AllStorePageHeaderSection({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Image.asset(imagePath, fit: BoxFit.cover, width: double.infinity);
  }
}
