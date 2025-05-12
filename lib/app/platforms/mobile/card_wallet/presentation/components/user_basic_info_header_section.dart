import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/customer_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/user_basic_info_section.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UserBasicInfoHeaderSection extends StatelessWidget {
  final CustomerModel customer;
  final bool haveAccess;

  const UserBasicInfoHeaderSection(
      {super.key, required this.customer, required this.haveAccess});

  static const double profileRadius = 72;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 20.h,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  alignment: Alignment.bottomLeft,
                  image: AssetImage("assets/agent_card_info_bg.jpeg"))),
          child: SafeArea(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  width: 100.w,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      children: [
                        AppBar(
                          backgroundColor: Colors.transparent,
                          iconTheme: const IconThemeData(color: Colors.white),
                          titleSpacing: 4,
                          title: Text(
                            customer.brand.brandName,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: (100.w / 2) - profileRadius,
                  bottom: -profileRadius / 1,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: profileRadius,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(customer
                                    .user.avatar?.isNotEmpty ??
                                false
                            ? customer.user.avatar!
                            : "https://static-00.iconduck.com/assets.00/profile-user-icon-512x512-nm62qfu0.png"),
                      ),
                      Positioned(
                        right: 4,
                        bottom: 4,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.black,
                              backgroundImage: CachedNetworkImageProvider(
                                  customer.brand.image),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: profileRadius * 1.15),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(customer.user.name.trim(),
                style:
                    context.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(width: 4),
            const Icon(Icons.verified, color: Colors.blue, size: 22)
          ],
        ),
        const SizedBox(height: 8),
        if (customer.user.phoneNumberWithCountryCode.isNotEmpty)
          Text(!haveAccess
                  ? "+1xxxxxxxxxx"
                  : customer.user.phoneNumberWithCountryCode
                      .formatPhoneNumber())
              .toBlur(!haveAccess),
        Text(!haveAccess ? "dummy@gmail.com" : (customer.user.email ?? ''))
            .toBlur(!haveAccess),
        const SizedBox(height: 16),
        UserBasicInfoSection(
          user: customer.user,
          haveAccess: haveAccess,
          customer: customer,
        ),
      ],
    );
  }
}
