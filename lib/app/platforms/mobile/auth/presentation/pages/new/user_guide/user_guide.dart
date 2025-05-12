import 'package:fadingpageview/fadingpageview.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/auth_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/sign_up_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class UserGuidePage extends StatefulWidget {
  const UserGuidePage({super.key});

  @override
  State<UserGuidePage> createState() => _UserGuidePageState();
}

class _UserGuidePageState extends State<UserGuidePage> {
  final controller = sl<SignUpPageBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          titleSpacing: 20,
          title: Text(
            sl<HomePageBloc>().isUserFlow ? '' : 'Complete profile',
            style: context.bodyLarge?.copyWith(
                color: const Color(0xFF797979).withOpacity(0.8),
                fontWeight: FontWeight.w600),
          ),
          actions: [
            if(true) ...[
              if (controller.userGuideController.currentPage == 0)
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.clear,
                      color: Color(0xFF797979),
                    ))
              else
                TextButton(
                    style: TextButton.styleFrom(
                        shape: const RoundedRectangleBorder(),
                        foregroundColor: const Color(0xFF797979)),
                    onPressed: () {
                      controller.userGuideController.previous();
                    },
                    child: const Text('BACK')),
            ],
            const SizedBox(width: 8),
          ],
        ),
        // ignore: deprecated_member_use
        body: WillPopScope(
          onWillPop: () {
            if (controller.userGuideController.currentPage == 0) {
              return Future.value(true);
            } else {
              controller.userGuideController.previous();
              return Future.value(false);
            }
          },
          child: FadingPageView(
            controller: controller.userGuideController,
            onShown: () {
              setState(() {});
            },
            itemBuilder: (context, index) => controller.userGuidePages[index],
          ),
        ));
  }
}
