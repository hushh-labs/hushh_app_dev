import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/auth/presentation/bloc/auth_bloc/bloc.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class CountryCodeTextField extends StatefulWidget {
  final bool onlyCode;

  const CountryCodeTextField({super.key, this.onlyCode = false});

  @override
  State<CountryCodeTextField> createState() => _CountryCodeTextFieldState();
}

class _CountryCodeTextFieldState extends State<CountryCodeTextField> {
  final controller = sl<AuthPageBloc>();

  @override
  void initState() {
    if (controller.selectedCountry == null) {
      controller.add(const InitializeEvent(true));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: controller,
        builder: (context, state) {
          return SizedBox(
            height: 56,
            child: TextFormField(
              autovalidateMode: AutovalidateMode.disabled,
              readOnly: true,
              cursorColor:
                  const Color.fromARGB(255, 179, 183, 189).withOpacity(0.5),
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: false, signed: false),
              onTap: () => controller.add(OnCountryUpdateEvent(context)),
              controller: TextEditingController(
                  text: controller.selectedCountry == null
                      ? ""
                      : widget.onlyCode
                          ? '+${controller.selectedCountry!.dialCode}'
                          : '${controller.selectedCountry!.name} (+${controller.selectedCountry!.dialCode})'),
              keyboardAppearance: Brightness.light,
              decoration: InputDecoration(
                contentPadding: widget.onlyCode
                    ? null
                    : const EdgeInsets.symmetric(horizontal: 10),
                prefixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (controller.selectedCountry != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: Image.asset(
                          "assets/flags/${controller.selectedCountry!.code.toLowerCase()}.png",
                          width: 26,
                        ),
                      ),
                  ],
                ),
                border: widget.onlyCode
                    ? InputBorder.none
                    : OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: const Color(0xff8391a1).withOpacity(0.5),
                        )),
                enabledBorder: widget.onlyCode
                    ? InputBorder.none
                    : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: const Color(0xff8391a1).withOpacity(0.5),
                    )),
                focusedBorder: widget.onlyCode
                    ? InputBorder.none
                    : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: const Color(0xff8391a1).withOpacity(0.5),
                    )),
                disabledBorder: widget.onlyCode
                    ? InputBorder.none
                    : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: const Color(0xff8391a1).withOpacity(0.5),
                    )),
                errorBorder: widget.onlyCode
                    ? InputBorder.none
                    : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: const Color(0xff8391a1).withOpacity(0.5),
                    )),
                focusedErrorBorder: widget.onlyCode
                    ? InputBorder.none
                    : OutlineInputBorder(
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
