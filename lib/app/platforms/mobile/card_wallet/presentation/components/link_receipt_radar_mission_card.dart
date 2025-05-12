import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class LinkReceiptRadarMissionCard extends StatelessWidget {
  const LinkReceiptRadarMissionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 0,
        color: Colors.grey.shade50,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Receipt Radar',
                      style: context.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Get Insights on receipts store all of them in a single place to chat and extract useful information',
                      style: context.bodySmall
                          ?.copyWith(color: const Color(0xFF939393)),
                    ),
                    const SizedBox(height: 12),
                    HushhLinearGradientButton(
                      text: 'Link Account',
                      height: 32,
                      onTap: () {
                        sl<HomePageBloc>().add(UpdateHomeScreenIndexEvent(1, context));
                      },
                      radius: 6,
                    )
                  ],
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset('assets/link-receipt-radar-asset.png'),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
