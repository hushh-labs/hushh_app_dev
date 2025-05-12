import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/components/delete_my_account_app_bar.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/components/delete_my_account_button.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/components/delete_my_account_heading.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DeleteMyAccountView extends StatefulWidget {
  const DeleteMyAccountView({Key? key}) : super(key: key);

  @override
  State<DeleteMyAccountView> createState() => _DeleteMyAccountViewState();
}

class _DeleteMyAccountViewState extends State<DeleteMyAccountView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const DeleteMyAccountAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 64),
            Container(
              width: double.infinity,
              height: 20.h,
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  "assets/bin_big.svg",
                  color: Colors.black,
                  width: 30.h,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const DeleteMyAccountHeading(),
            const SizedBox(height: 16),
            const Text(
              "Deleting your account will permanently remove all your data, including your profile information, chat, Hushh id cards, wallet data, settings, and activity history. This action cannot be undone. If you're certain about deleting your account, click the button below.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                height: 2,
              ),
            ),
            const SizedBox(height: 24),
            const DeleteMyAccountButton(),
            if(!sl<HomePageBloc>().isUserFlow) ...[
              const SizedBox(height: 8),
              const DeleteMyAccountButton(isAgentAccount: true),
            ]
          ],
        ),
      ),
    );
  }
}
