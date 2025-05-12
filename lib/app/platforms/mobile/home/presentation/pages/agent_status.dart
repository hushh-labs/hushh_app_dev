import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AgentStatusPage extends StatelessWidget {
  const AgentStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    AgentApprovalStatus status =
        ModalRoute.of(context)!.settings.arguments as AgentApprovalStatus;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.watch_later_rounded, size: 30.w),
                    SizedBox(height: 16),
                    Text(
                      status == AgentApprovalStatus.pending
                          ? "Approval Pending!"
                          : "Approval Denied!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      status == AgentApprovalStatus.pending
                          ? "Contact the brand admins to expedite the process. You are currently in the approval queue."
                          : "Unfortunately, your request for approval has been denied. Please review the provided guidelines and make necessary adjustments before reapplying.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          RichText(
              text: TextSpan(
            children: [
              TextSpan(text: 'Continue using Hushh Wallet? '),
              TextSpan(
                  text: 'click here',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Color(0XFFA342FF)),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      sl<CardWalletPageBloc>()
                          .add(UpdateUserRoleEvent(Entity.user, context));
                    }),
            ],
            style: TextStyle(color: Colors.black, fontSize: 16),
          )),
          SizedBox(height: 32)
        ],
      ),
    );
  }
}
