import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';

class AddCardsBottomSheet extends StatefulWidget {
  final CardModel openedCard;
  final List<CardModel> brands;
  final List<String>? selectedBrandCardIds;
  final bool isBrandCard;

  const AddCardsBottomSheet(
      {super.key,
      required this.brands,
      required this.openedCard,
      this.selectedBrandCardIds,
      required this.isBrandCard});

  @override
  State<AddCardsBottomSheet> createState() => _AddCardsBottomSheetState();
}

class _AddCardsBottomSheetState extends State<AddCardsBottomSheet> {
  List<CardModel> selectedBrands = [];
  late List<CardModel> brands;

  @override
  void initState() {
    brands = widget.brands;
    brands.removeWhere((element) => element.cid == widget.openedCard.cid);
    if (widget.selectedBrandCardIds != null) {
      selectedBrands = brands
          .where((element) =>
              widget.selectedBrandCardIds!.contains(element.cid.toString()))
          .toList();
      brands.removeWhere((element) {
        return element.cid == widget.openedCard.cid;
      });
      setState(() {});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.isBrandCard ? 'Brand Cards' : 'Preference Cards',
                style: const TextStyle(
                    fontFamily: 'Figtree',
                    fontSize: 20,
                    letterSpacing: -0.4,
                    fontWeight: FontWeight.w600),
              ),
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close))
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'You can manage and add new cards to your current brand cards if you require. You can add and remove cards from here.',
            style: TextStyle(color: Color(0xFF4C4C4C)),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: brands.isEmpty
                ? const Center(
                    child: Text('Please add more brand cards to link here'),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: brands.length,
                    itemBuilder: (context, index) {
                      final brandCard = brands[index];
                      return ListTile(
                          leading: CircleAvatar(
                            onBackgroundImageError: (exception, stackTrace) {},
                            backgroundImage: CachedNetworkImageProvider(brandCard
                                    .logo.isNotEmpty
                                ? brandCard.image
                                : "https://static-00.iconduck.com/assets.00/profile-user-icon-512x512-nm62qfu0.png"),
                          ),
                          onTap: () {
                            if (!selectedBrands.contains(brandCard)) {
                              selectedBrands.add(brandCard);
                            } else {
                              selectedBrands.remove(brandCard);
                            }
                            setState(() {});
                          },
                          title: Text(brandCard.brandName),
                          subtitle: Text(brandCard.category),
                          trailing: Checkbox(
                            value: selectedBrands.contains(brandCard),
                            onChanged: (value) {
                              if (value == true) {
                                selectedBrands.add(brandCard);
                              } else {
                                selectedBrands.remove(brandCard);
                              }
                              setState(() {});
                            },
                          ));
                    },
                  ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, selectedBrands);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, foregroundColor: Colors.white),
              child: const Text('Update'),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
