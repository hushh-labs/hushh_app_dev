import 'dart:math';

import 'package:fadingpageview/fadingpageview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/pages/new/user_guide/user_guide.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/splash/data/models/tutorial_model.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NewTutorialPage extends StatefulWidget {
  const NewTutorialPage({super.key});

  @override
  State<NewTutorialPage> createState() => _NewTutorialPageState();
}

class _NewTutorialPageState extends State<NewTutorialPage> {
  List<TutorialModel> tutorials = sl<HomePageBloc>().isUserFlow
      ? defaultUserTutorials
      : defaultAgentTutorials;
  final controller = FadingPageViewController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (controller.currentPage != 0)
            FloatingActionButton(
              heroTag: 'floating-btn-1',
              backgroundColor: const Color(0xFFEBECF3),
              elevation: 0,
              shape: const CircleBorder(),
              child: Image.asset(
                'assets/backArrow.png',
                width: 8,
                color: Colors.black87,
              ),
              onPressed: () {
                controller.previous();
                setState(() {});
              },
            ),
          const SizedBox(width: 8),
          FloatingActionButton(
            heroTag: 'floating-btn-2',
            backgroundColor: const Color(0xFFEBECF3),
            elevation: 0,
            shape: const CircleBorder(),
            child: Transform.rotate(
                angle: pi,
                child: Image.asset(
                  'assets/backArrow.png',
                  width: 8,
                  color: Colors.black87,
                )),
            onPressed: () {
              if (controller.currentPage < tutorials.length - 1) {
                controller.next();
              } else {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.bottomToTop,
                        child: const UserGuidePage()));
                // Navigator.pushNamed(context, AppRoutes.userGuidePage);
              }
              if (mounted) {
                setState(() {});
              }
            },
          )
        ],
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: FadingPageView(
          controller: controller,
          disableWhileAnimating: true,
          itemBuilder: (context, index) {
            final tutorial = tutorials[index];
            return Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Image.asset(
                    tutorial.image,
                    width: 100.w,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  tutorial.heading,
                  textAlign: TextAlign.center,
                  style: context.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 22),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(tutorial.items.length, (index) {
                          final tutorialItem = tutorial.items[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 18),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: SvgPicture.asset(
                                    tutorialItem.icon,
                                    width: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Flexible(
                                  child: RichText(
                                      text: TextSpan(
                                          style: context.titleSmall,
                                          children: [
                                        TextSpan(
                                            text: "${tutorialItem.heading}: ",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700)),
                                        TextSpan(text: tutorialItem.desc),
                                      ])),
                                )
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
