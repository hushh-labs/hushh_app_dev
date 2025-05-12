import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/auth_bloc/bloc.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class SignInWithPhoneButton extends StatelessWidget {
  const SignInWithPhoneButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = sl<AuthPageBloc>();
    return InkWell(
      onTap: () => controller.add(AuthenticateWithPhoneEvent(context)),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: const [
            Color(0XFFA342FF),
            Color(0XFFE54D60),
          ]),
          borderRadius: BorderRadius.circular(7),
        ),
        child: BlocBuilder(
          bloc: controller,
          builder: (context, state) {
            return Center(
              child: state is PhoneVerificationInitiatedState
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      ),
                    )
                  : Text(
                      "Continue",
                      style: TextStyle(
                          color: Color(0xffFFFFFF),
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
            );
          },
        ),
      ),
    );
  }
}
