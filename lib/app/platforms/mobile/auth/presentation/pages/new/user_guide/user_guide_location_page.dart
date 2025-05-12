import 'package:fadingpageview/fadingpageview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/agent_sign_up_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/sign_up_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/bloc/card_market_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';
import 'package:hushh_app/app/shared/core/components/hushh_secondary_button.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';

class UserGuideLocationPage extends StatefulWidget {
  final bool optional;

  const UserGuideLocationPage({super.key, this.optional = true});

  @override
  State<UserGuideLocationPage> createState() => _UserGuideLocationPageState();
}

class _UserGuideLocationPageState extends State<UserGuideLocationPage> {
  FadingPageViewController get scrollController =>
      sl<SignUpPageBloc>().userGuideController;

  int get totalPages => sl<SignUpPageBloc>().totalPages;

  @override
  void initState() {
    if (widget.optional == false &&
        processStarted == false &&
        sl<SignUpPageBloc>().userGuideController.currentPage == 1) {
      accessLoc();
    }
    super.initState();
  }

  bool processStarted = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                    '${((scrollController.currentPage / totalPages) * 100).toStringAsFixed(0)}%'),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: scrollController.currentPage / totalPages,
                color: const Color(0xFF6725F2),
                borderRadius: BorderRadius.circular(50),
                minHeight: 10,
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Share Your location',
                  style: context.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900, letterSpacing: 0.8),
                ),
                const SizedBox(height: 8),
                Text(
                  'Grant permission',
                  style: context.headlineSmall
                      ?.copyWith(color: Colors.grey, letterSpacing: 0.4),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                            child:
                                SvgPicture.asset('assets/location-icon.svg')),
                        const SizedBox(height: 32),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'This is your personal card you can add in your name address city location attach intro videos and share it with other people as your personalized visiting card',
                            style: context.bodyMedium
                                ?.copyWith(color: const Color(0xFF838383)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 42),
                if (!widget.optional) const SizedBox(height: 46),
                HushhLinearGradientButton(
                  text: sl<HomePageBloc>().isUserFlow
                      ? 'Find my location'
                      : 'Allow permission',
                  height: 48,
                  loader: processStarted,
                  onTap: accessLoc,
                  radius: 6,
                ),
                if (widget.optional) ...[
                  const SizedBox(height: 16),
                  HushhSecondaryButton(
                    text: 'Skip',
                    height: 48,
                    onTap: () => scrollController.next(),
                    radius: 6,
                  ),
                ]
              ],
            ),
          ),
        ),
        const SizedBox(height: 32)
      ],
    );
  }

  Future<void> accessLoc() async {
    if (!processStarted) {
      processStarted = true;
      setState(() {});
      if (sl<HomePageBloc>().entity == Entity.user) {
        try {
          await sl<HomePageBloc>().getCurrentLocation();
          scrollController.next();
        } catch (_) {
          scrollController.next();
        }
      } else {
        try {
          final res = await sl<HomePageBloc>().getCurrentLocation();
          sl<AgentSignUpPageBloc>().lastKnownLocation = res;
          final email = AppLocalStorage.user?.email;
          if (email != null &&
              (sl<CardMarketBloc>().brands?.any(
                      (element) => element.domain == email.split('@')[1]) ??
                  false)) {
            final brand = sl<CardMarketBloc>()
                .brands!
                .firstWhere((element) => element.domain == email.split('@')[1]);
            sl<AgentSignUpPageBloc>().onBrandClaim(brand, context, true);
          } else {
            scrollController.next();
          }
        } catch (_) {
          // ignore: use_build_context_synchronously
          ToastManager(Toast(
                  title: 'Unable to access the location',
                  description: 'Please try again!'))
              .show(context);
        }
      }
      processStarted = false;
      setState(() {});
    }
  }
}
