import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/data/models/nearby_found_brand.dart';
import 'package:hushh_app/app/platforms/mobile/card_share_ecosystem/presentation/pages/single_store_page.dart';

class BrandListTile extends StatelessWidget {
  final NearbyFoundBrandOffers brand;

  const BrandListTile({super.key, required this.brand});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(50)),
          child: Image.network(brand.logoPath, width: 42, height: 42)),
      title: Text(
        brand.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        brand.address,
        maxLines: 2,
        style: const TextStyle(fontSize: 12),
      ),
      trailing: Transform.scale(
        scale: .85,
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SingleStorePage(brandOffer: brand)));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            fixedSize: const Size.fromHeight(16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text(
            'View',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
