import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/auth_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/sign_up_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/pages/auth.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class SocialButton extends StatefulWidget {
  final LoginMode loginMode;

  const SocialButton({super.key, required this.loginMode});

  @override
  State<SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<SocialButton> {
  String get title {
    switch (widget.loginMode) {
      // case LoginMode.email:
      //   return "Email";
      case LoginMode.google:
        return "Google";
      case LoginMode.apple:
        return "Apple";
      case LoginMode.phone:
        return "Phone";
    }
  }

  String get icon {
    switch (widget.loginMode) {
      // case LoginMode.email:
      //   return "assets/mail-icon.svg";
      case LoginMode.google:
        return "assets/googleButton.svg";
      case LoginMode.apple:
        return "assets/appleButton.svg";
      case LoginMode.phone:
        return "assets/phone-icon.svg";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14)),
        onPressed: () async {
          void continueAuth() {
            switch (widget.loginMode) {
              case LoginMode.google:
                sl<AuthPageBloc>().add(AuthenticateWithGoogleEvent(context));
                break;
              case LoginMode.apple:
                sl<AuthPageBloc>().add(AuthenticateWithAppleEvent(context));
                break;
              case LoginMode.phone:
                showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => const AuthPage());
                break;
            }
          }

          if (sl<AuthPageBloc>().state is AuthenticatingWithGoogleState ||
              sl<AuthPageBloc>().state is AuthenticatingWithAppleState) {
            return;
          }
          if (sl<SignUpPageBloc>().state is! SignUpPageInitialState) {
            (await resetAuthPageBlocInstance())
                .add(const InitializeEvent(false));
            sl<AuthPageBloc>().stream.listen((state) {
              if (state is InitializingState ||
                  state is AuthenticatingWithGoogleState ||
                  state is AuthenticatingWithAppleState) {
                setState(() {});
              } else if (state is InitializedState) {
                continueAuth();
              }
            });
          } else {
            continueAuth();
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
              child: Center(child: SvgPicture.asset(icon, height: 20)),
            ),
            const SizedBox(width: 14),
            Text(
              'Continue With $title',
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            BlocBuilder(
              bloc: sl<AuthPageBloc>(),
              builder: (context, state) {
                if ((widget.loginMode == LoginMode.google &&
                        state is AuthenticatingWithGoogleState) ||
                    (widget.loginMode == LoginMode.apple &&
                        state is AuthenticatingWithAppleState) ||
                    (widget.loginMode == LoginMode.phone &&
                        state is InitializingState &&
                        !state.isInitState)) {
                  return const SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 2,
                    ),
                  );
                }
                return const SizedBox();
              },
            )
          ],
        ),
      ),
    );
  }
}
