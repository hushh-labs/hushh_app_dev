import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/data/models/nearby_found_brand.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/data/models/offer.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/presentation/bloc/card_share_ecosystem_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';

class OfferListTile extends StatelessWidget {
  final Offer offer;
  final NearbyFoundBrandOffers brandOffer;

  const OfferListTile(
      {super.key, required this.offer, required this.brandOffer});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: CachedNetworkImageProvider(offer.product!.productImage),
          )
        ),
      ),
      title: Text(
        offer.offerDesc,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      subtitle: Text(offer.discountTag, style: const TextStyle(fontSize: 12)),
      trailing: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              String text = offer.offerDesc;
              ToastManager(Toast(
                  title:
                  'We are glad you are interested in the offer!',
                  duration: const Duration(seconds: 5),
                  description:
                  'Please reach the store while we are informing the agents about your visit.'))
                  .show(context);
              sl<CardShareEcosystemBloc>().add(CreateNewTaskAsUserForAgentEvent(
                query: text,
                brandId: offer.brandId,
                cardId: sl<CardWalletPageBloc>()
                    .allCards
                    .firstWhereOrNull((element) =>
                element.item2.brandId ==
                    brandOffer.brandId)
                    ?.item2
                    .id
              ));
            },
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(50, 30),
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            child: const Text('Check out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
