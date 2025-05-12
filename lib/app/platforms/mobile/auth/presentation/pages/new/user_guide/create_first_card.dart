import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/sign_up_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/components/hover_card.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class CreateFirstCardPage extends StatelessWidget {
  const CreateFirstCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            const SizedBox(height: 64),
            Text(
              'Your Hushh card 🤫',
              style: context.headlineMedium
                  ?.copyWith(letterSpacing: -1, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            AspectRatio(
              aspectRatio: 1.5,
              child: HoverCard(
                builder: (context, hovering) {
                  return Image.asset('assets/dummy-card.png');
                },
                depth: 1,
                depthColor: Colors.transparent,
                shadow: const BoxShadow(
                    color: Colors.transparent,
                    blurRadius: 30,
                    spreadRadius: -20,
                    offset: Offset(0, 40)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Your data wallet holds digital cards, each organizing a category of your data. Let’s start with your Hushh ID card by adding your basic details!',
              style:
                  context.bodyMedium?.copyWith(color: const Color(0xFF838383)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 52),
            HushhLinearGradientButton(
              text: 'Start Now',
              onTap: () => sl<SignUpPageBloc>().userGuideController.next(),
              radius: 6,
            )
          ],
        ),
      ),
    );
  }
}
