import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/bloc/settings_bloc/bloc.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DeleteMyAccountConfirmationDialog extends StatelessWidget {
  final BuildContext context;
  final bool isAgentAccount;

  const DeleteMyAccountConfirmationDialog(
      {super.key, required this.context, this.isAgentAccount = false});

  @override
  Widget build(BuildContext _context) {
    final controller = sl<SettingsPageBloc>();
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Text(
        'Are you sure you want to delete your${isAgentAccount ? " agent " : " "}account?',
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xff181941)),
      ),
      actions: <Widget>[
        ElevatedButton(
            onPressed: () {
              Navigator.of(_context).pop();
            },
            style: ElevatedButton.styleFrom(
                foregroundColor: const Color(0xff7F7F97),
                backgroundColor: const Color(0xffEBEBF7),
                minimumSize: Size(100.w / 10.68, 100.h / 21.36),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30))
                // onPrimary:Color(0xffEA4841),
                ),
            child: const Text('No')),
        const SizedBox(width: 10),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: ElevatedButton(
              onPressed: () async {
                Navigator.pop(_context);
                controller.add(DeleteAccountEvent(context, isAgentAccount));
              },
              style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xff7FFFFFF),
                  backgroundColor: const Color(0xffEA4841),
                  minimumSize: Size(100.w / 10.68, 100.h / 21.36),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))
                  // onPrimary:Color(0xffEA4841),
                  ),
              child: const Text('Yes')),
        ),
      ],
    );
  }
}
