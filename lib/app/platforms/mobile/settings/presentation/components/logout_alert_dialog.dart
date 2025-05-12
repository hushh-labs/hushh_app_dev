import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/settings/presentation/bloc/settings_bloc/bloc.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LogoutAlertDialog extends StatelessWidget {
  final BuildContext context;

  const LogoutAlertDialog({super.key, required this.context});

  @override
  Widget build(BuildContext _context) {
    final controller = sl<SettingsPageBloc>();
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Text(
        'Are you sure you want to Logout?',
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xff181941)),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () => Navigator.of(_context).pop(),
          style: ElevatedButton.styleFrom(
            foregroundColor: Color(0xff7F7F97),
            backgroundColor: Color(0xffEBEBF7),
            minimumSize: Size(100.w / 10.68, 100.h / 21.36),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: Text('No'),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            Navigator.of(_context).pop();
            controller.add(LogoutEvent(context));
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Color(0xff7FFFFFF),
            backgroundColor: Color(0xffEA4841),
            minimumSize: Size(100.w / 10.68, 100.h / 21.36),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: Text('Yes'),
        ),
      ],
    );
  }
}
