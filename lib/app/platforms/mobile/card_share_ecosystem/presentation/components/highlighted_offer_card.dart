import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/data/models/nearby_found_brand.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/data/models/offer.dart';

class HighlightedOfferCard extends StatelessWidget {
  final Offer offer;
  final NearbyFoundBrandOffers brandOffer;

  const HighlightedOfferCard(
      {super.key, required this.offer, required this.brandOffer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(right: 0),
      child: Card(
        color: Colors.grey.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16.0).copyWith(right: 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Spotlight Tag
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12))),
                        child: const Text(
                          'on spotlight',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      offer.offerDesc,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      offer.discountTag,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "\$${offer.updatedPrice.toString()}",
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Image.network(offer.product!.productImage, height: 140),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
