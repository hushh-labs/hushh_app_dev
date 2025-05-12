import 'package:flutter/material.dart';
import 'package:hushh_app/app/shared/core/components/custom_text_field.dart';

class DiscoverPageSearch extends StatelessWidget
    implements PreferredSizeWidget {
  const DiscoverPageSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      edgeInsets: EdgeInsets.zero,
      hintText: 'Search for anything...',
      height: 60,
      onChanged: (value) {},
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  SliverAppBarDelegate({
    required this.child,
  });

  @override
  double get minExtent => 64.0; // Adjust this height as needed
  @override
  double get maxExtent => 64.0; // Adjust this height as needed

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
