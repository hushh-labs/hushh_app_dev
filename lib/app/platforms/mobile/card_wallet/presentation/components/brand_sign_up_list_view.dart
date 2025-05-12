import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/shared/core/components/custom_text_field.dart';

class BrandSignUpListView extends StatefulWidget {
  final List<CardModel> brands;
  final bool Function(CardModel)? cond;

  const BrandSignUpListView({
    super.key,
    required this.brands,
    this.cond,
  });

  @override
  State<BrandSignUpListView> createState() => _BrandSignUpListViewState();
}

class _BrandSignUpListViewState extends State<BrandSignUpListView> {
  List<CardModel> selectedBrands = [];

  @override
  void initState() {
    if (widget.cond == null) {
      selectedBrands = widget.brands;
    } else {
      selectedBrands = widget.brands.where((e) => widget.cond!(e)).toList();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomTextField(
              onChanged: (value) {
                if(value.trim().isEmpty) {
                  if (widget.cond == null) {
                    selectedBrands = widget.brands;
                  } else {
                    selectedBrands = widget.brands.where((e) => widget.cond!(e)).toList();
                  }
                } else {
                  selectedBrands = selectedBrands
                      .where((element) => element.brandName
                      .toLowerCase()
                      .contains(value.toLowerCase()))
                      .toList();
                }
                setState(() {});
              },
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: selectedBrands.length,
              itemBuilder: (context, index) {
                final brandCard = selectedBrands[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(brandCard
                            .logo.isNotEmpty
                        ? brandCard.image
                        : "https://static-00.iconduck.com/assets.00/profile-user-icon-512x512-nm62qfu0.png"),
                  ),
                  onTap: () {
                    Navigator.pop(context, brandCard);
                  },
                  title: Text(brandCard.brandName),
                  subtitle: Text(brandCard.category),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
