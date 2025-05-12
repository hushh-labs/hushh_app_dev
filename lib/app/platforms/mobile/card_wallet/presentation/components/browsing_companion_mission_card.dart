import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/bloc/settings_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/components/chrome_extension_bottom_sheet.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BrowsingCompanionMissionCard extends StatelessWidget {
  const BrowsingCompanionMissionCard({super.key});

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
                      'Browser Companion',
                      style: context.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Shop & Organize Across the Web. Wishlist anything, recall past searches. Data safe in your browser',
                      style: context.bodySmall
                          ?.copyWith(color: const Color(0xFF939393)),
                    ),
                    const SizedBox(height: 12),
                    HushhLinearGradientButton(
                      text: 'Use Browser Companion',
                      height: 32,
                      fontSize: 12,
                      onTap: () {
                        bool isScanned = false;
                        showModalBottomSheet(
                          backgroundColor: Colors.white,
                          constraints: BoxConstraints(maxHeight: 70.h),
                          context: context,
                          isDismissible: true,
                          builder: (context) => ChromeExtensionBottomSheet(
                            onScanned: (value) {
                              if (!isScanned) {
                                isScanned = true;
                                if (value != null) {
                                  Navigator.pop(context);
                                  sl<SettingsPageBloc>().add(
                                      InitiateLoginInExtensionWithHushhQrEvent(
                                          value, context));
                                }
                              }
                            },
                          ),
                        );
                        // launchUrl(
                        //     Uri.parse(
                        //         'https://chromewebstore.google.com/detail/hushh-browser-companion/glmkckchoggnebfiklpbiajpmjoagjgj'),
                        //     mode: LaunchMode.externalApplication);
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
                    child: Image.asset(
                      'assets/hushh-extension.png',
                      scale: 1.05,
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
