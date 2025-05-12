import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/presentation/components/card_questions_common_widgets.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/data/models/nearby_found_brand.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/presentation/components/all_store_page_header_section.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/presentation/components/brand_list_tile.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';

class AllStoresPage extends StatefulWidget {
  final List<NearbyFoundBrandOffers> brands;

  const AllStoresPage({super.key, required this.brands});

  @override
  State<AllStoresPage> createState() => _AllStoresPageState();
}

class _AllStoresPageState extends State<AllStoresPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Nearby Brands',
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AllStorePageHeaderSection(imagePath: 'assets/offer_banner.png'),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'STORES',
              style: context.titleSmall?.copyWith(
                color: const Color(0xFF737373),
                fontWeight: FontWeight.w700,
                letterSpacing: 1.3,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.brands.length,
              itemBuilder: (context, index) {
                return BrandListTile(brand: widget.brands[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
