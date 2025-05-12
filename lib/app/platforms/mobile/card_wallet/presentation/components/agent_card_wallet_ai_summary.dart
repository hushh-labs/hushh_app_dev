import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AgentCardWalletAiSummary extends StatelessWidget {
  final String? content;

  const AgentCardWalletAiSummary({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: .8,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/hbot.png'),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Summary - Report',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Hushh AI',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SvgPicture.asset("assets/star-icon.svg", height: 20)
                ],
              ),
              const SizedBox(height: 16),
              if (content == null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 24,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 20.w,
                      height: 24,
                      color: Colors.grey,
                    ),
                  ],
                ).toShimmer(content == null)
              else
                Markdown(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  data: content!,
                  styleSheet: MarkdownStyleSheet(
                      p: const TextStyle(height: 1.5, fontSize: 15)),
                )
            ],
          ),
        ),
      ),
    );
  }
}
