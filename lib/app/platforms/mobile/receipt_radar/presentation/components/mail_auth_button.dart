import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/pages/receipt_radar_search.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';

class MailAuthButton extends StatelessWidget {
  final EmailProvider provider;

  const MailAuthButton({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    const double buttonHeight = 56;
    return InkWell(
      onTap: () => onEmailProviderClicked(context),
      child: Container(
        width: double.infinity,
        height: buttonHeight,
        decoration: BoxDecoration(border: Border.all(color: Color(0xffCFCFCF))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            leadingIcon(),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget leadingIcon() {
    switch (provider) {
      case EmailProvider.google:
        return SvgPicture.asset("assets/googleButton.svg");
      case EmailProvider.outlook:
        return Image.asset(
          "assets/outlook_icon.png",
          width: 26,
          fit: BoxFit.cover,
        );
      case EmailProvider.yahoo:
        return Image.asset(
          "assets/yahoo_icon.png",
          width: 26,
          fit: BoxFit.cover,
        );
    }
  }

  String get title {
    switch (provider) {
      case EmailProvider.google:
        return "Continue with Google";
      case EmailProvider.outlook:
        return "Continue with Outlook";
      case EmailProvider.yahoo:
        return "Continue with Yahoo";
    }
  }

  void onEmailProviderClicked(context) {
    Navigator.pushReplacementNamed(context, AppRoutes.receiptRadar.search,
        arguments: ReceiptRadarSearchArgs(
          provider: provider,
        ));
    // Get.off(ReceiptRadarSearch(cardData: cardData, provider: provider));
    // Get.off(ReceiptRadar(cardData: cardData, provider: provider));
  }
}
