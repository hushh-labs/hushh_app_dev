import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CoinsDashboardSliverAppBar extends StatelessWidget {
  const CoinsDashboardSliverAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      expandedHeight: 50.h,
      backgroundColor: Colors.white,
      elevation: 0.0,
      pinned: true,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0XFFA342FF),
              Color(0XFFE54D60),
            ], begin: Alignment.topRight, end: Alignment.bottomLeft),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: kToolbarHeight,
                  ),
                  Text(
                    'Hello ${AppLocalStorage.user?.name.trim()},',
                    style: context.headlineSmall?.copyWith(color: Colors.white),
                  ),
                  Text(
                    'Your Hushh balance is',
                    style: context.bodyMedium?.copyWith(color: Colors.white),
                  ),
                  Expanded(
                    child: Center(
                      child: Stack(
                        children: [
                          Positioned.fill(
                            top: -100,
                            child: Lottie.asset(
                              'assets/coin_anim.json',
                              width: 80.w,
                            ),
                          ),
                          Align(
                            alignment: const Alignment(0, .65),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('${AppLocalStorage.user?.userCoins ?? 0}',
                                    style: context.displayLarge?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        fontSize: 62)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32)
                ],
              ),
            ),
          ),
        ),
        stretchModes: const [
          StretchMode.blurBackground,
          StretchMode.zoomBackground,
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: Container(
          height: 32.0,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32.0),
              topRight: Radius.circular(32.0),
            ),
          ),
          child: Container(
            width: 40.0,
            height: 5.0,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(100.0),
            ),
          ),
        ),
      ),
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_sharp,
            color: Colors.black,
          )),
    );
  }
}
