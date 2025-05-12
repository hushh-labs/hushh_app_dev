import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';

class ReceiptRadarAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String? title;
  final bool showAdd;
  final List<Widget>? actions;

  const ReceiptRadarAppBar({Key? key, this.title, this.showAdd = false, this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null ? Text(title!) : null,
      backgroundColor: Colors.white,
      actions: [
        if (showAdd)
          TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.receiptRadar.onboarding);
              },
              child: const Text('Add Receipts')),
        ...?actions
      ],
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: SvgPicture.asset('assets/back.svg')),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class ReceiptRadarBrandAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String? title;
  final bool? showBack;
  final String? brand;

  const ReceiptRadarBrandAppBar(
      {Key? key, this.title, this.showBack, this.brand})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null ? Text(title!) : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
