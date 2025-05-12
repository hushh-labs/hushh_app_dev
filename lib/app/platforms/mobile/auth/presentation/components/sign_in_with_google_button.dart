import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/auth_bloc/bloc.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class SignInWithGoogleButton extends StatelessWidget {
  const SignInWithGoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = sl<AuthPageBloc>();
    return Expanded(
      child: InkWell(
        onTap: () => controller.add(AuthenticateWithGoogleEvent(context)),
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xffD4D4D4))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: SvgPicture.asset("assets/googleButton.svg"),
              ),
              const Center(
                child: Text(
                  "Sign in with Google",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Container(),
            ],
          ),
        ),
      ),
    );
  }
}
