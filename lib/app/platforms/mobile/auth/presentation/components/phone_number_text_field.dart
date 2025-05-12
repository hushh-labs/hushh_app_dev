import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/auth_bloc/bloc.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class PhoneNumberTextField extends StatefulWidget {
  const PhoneNumberTextField({super.key});

  @override
  State<PhoneNumberTextField> createState() => _PhoneNumberTextFieldState();
}

class _PhoneNumberTextFieldState extends State<PhoneNumberTextField> {
  final controller = sl<AuthPageBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: controller,
        builder: (context, state) {
          return SizedBox(
            height: 56,
            child: TextFormField(
              autovalidateMode: AutovalidateMode.disabled,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                if (controller.formatter != null) controller.formatter!
              ],
              focusNode: controller.focusNode,
              cursorColor:
                  const Color.fromARGB(255, 179, 183, 189).withOpacity(0.5),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w300),
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: false, signed: false),
              controller: controller.phoneController,
              onChanged: (value) => controller.add(OnPhoneUpdateEvent()),
              keyboardAppearance: Brightness.light,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                hintText: "Enter mobile number",
                hintStyle: TextStyle(
                    color: const Color.fromARGB(255, 179, 183, 189)
                        .withOpacity(0.5),
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: const Color(0xff8391a1).withOpacity(0.5),
                    )),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: const Color(0xff8391a1).withOpacity(0.5),
                    )),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: const Color(0xff8391a1).withOpacity(0.5),
                    )),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: const Color(0xff8391a1).withOpacity(0.5),
                    )),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: const Color(0xff8391a1).withOpacity(0.5),
                    )),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: const Color(0xff8391a1).withOpacity(0.5),
                    )),
              ),
            ),
          );
        });
  }
}
