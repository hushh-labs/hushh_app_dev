import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/bloc/settings_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/components/delete_my_account_confirmation_dialog.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class DeleteMyAccountButton extends StatelessWidget {
  final bool isAgentAccount;
  const DeleteMyAccountButton({super.key, this.isAgentAccount = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        showDialog(
            context: context,
            builder: (BuildContext _context) {
              return DeleteMyAccountConfirmationDialog(context: context, isAgentAccount: isAgentAccount,);
            });
      },
      child: AnimatedContainer(
        width: 200,
        height: 60,
        color: isAgentAccount?Colors.redAccent:Colors.black,
        duration: Duration(milliseconds: 350),
        child: Center(
          child: BlocBuilder(
              bloc: sl<SettingsPageBloc>(),
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isAgentAccount?"Delete my Agent account":"Delete my account",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    if (state is DeletingAccountState)
                      SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ))
                    else
                      SvgPicture.asset(
                        "assets/arrow_right.svg",
                        color: Colors.white,
                      )
                  ],
                );
              }),
        ),
      ),
    );
  }
}
