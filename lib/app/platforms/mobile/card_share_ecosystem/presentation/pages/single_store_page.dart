import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/components/card_questions_common_widgets.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/data/models/nearby_found_brand.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/presentation/bloc/card_share_ecosystem_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/presentation/components/highlighted_offer_card.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/presentation/components/offer_list_tile.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/presentation/components/single_store_header_section.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class SingleStorePage extends StatefulWidget {
  final NearbyFoundBrandOffers brandOffer;

  const SingleStorePage({super.key, required this.brandOffer});

  @override
  State<SingleStorePage> createState() => _SingleStorePageState();
}

class _SingleStorePageState extends State<SingleStorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.brandOffer.name,
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: BlocBuilder(
          bloc: sl<CardShareEcosystemBloc>(),
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleStoreHeaderSection(brandOffer: widget.brandOffer),
                  const SizedBox(height: 16),
                  if (widget.brandOffer.highlightedOffer != null)
                    HighlightedOfferCard(
                        brandOffer: widget.brandOffer,
                        offer: widget.brandOffer.highlightedOffer!),
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Deals For you',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (widget.brandOffer.offers != null)
                    ...widget.brandOffer.offers!
                        .map((offer) => OfferListTile(
                              offer: offer,
                              brandOffer: widget.brandOffer,
                            ))
                        .toList(),
                ],
              ),
            );
          }),
    );
  }
}
