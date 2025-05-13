import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';

class AddBrandCardBanner extends StatelessWidget {
  const AddBrandCardBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: InkWell(
        overlayColor: MaterialStateProperty.all(Colors.white),
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.cardMarketPlace.main);
        },
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Image.asset('assets/card_marketplace_banner_icon.png', width: 56, height: 56, fit: BoxFit.cover,),
              const SizedBox(width: 12),
              const Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MARKETPLACE',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Create cards and share with agents and store for Personalized experiences',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                      size: 16,
                    ),
                    SizedBox(width: 4)
                  ],
                ),
              ),
              // ElevatedButton(
              //   onPressed: () {},
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.white,
              //     foregroundColor: Colors.black
              //   ),
              //   child: const Text("Card Marketplace"),
              // )
            ],
          ),
        ),

        // child: Transform.scale(
        //   scale: 1.02,
        //   child: Container(
        //     width: double.infinity,
        //     child: SvgPicture.asset("assets/Makeyour.svg"),
        //   ),
        // ),
      ),
    );
  }
}
