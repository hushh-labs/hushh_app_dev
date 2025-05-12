import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tuple/tuple.dart';

class TrendListTile extends StatelessWidget {
  final Tuple2<String, String> trend;

  const TrendListTile({super.key, required this.trend});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.w,
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
          color: Color(0xFFFCF7FA), borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child:
                  CachedNetworkImage(imageUrl: trend.item1, fit: BoxFit.cover),
            ),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(
              width: 70.w,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trend.item2,
                      style: context.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size.fromWidth(70.w),
                          elevation: 0,
                          backgroundColor: Color(0xFFF2E8EB),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      onPressed: () {},
                      child: Text(
                        "See more",
                        style: context.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
