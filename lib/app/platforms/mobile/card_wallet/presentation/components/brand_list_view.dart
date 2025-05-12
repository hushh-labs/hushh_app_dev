import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/customer_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/agent_card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/card_wallet_info/card_wallet_info.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class BrandListView extends StatefulWidget {
  final CustomerModel customer;
  final List<CardModel> brands;

  const BrandListView({
    super.key,
    required this.brands,
    required this.customer,
  });

  @override
  State<BrandListView> createState() => _BrandListViewState();
}

class _BrandListViewState extends State<BrandListView> {
  List<CardModel> selectedBrands = [];

  @override
  void initState() {
      selectedBrands = widget.brands;
      setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: selectedBrands.length,
      itemBuilder: (context, index) {
        final brandCard = selectedBrands[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(brandCard
                    .logo.isNotEmpty
                ? brandCard.image
                : "https://static-00.iconduck.com/assets.00/profile-user-icon-512x512-nm62qfu0.png", errorListener: (_){}),
          ),
          onTap: () async {
            final customer = widget.customer.copyWith(
              brand: brandCard
            );
            await Navigator.pushNamed(context, AppRoutes.cardWallet.info.main,
                arguments: CardWalletInfoPageArgs(
                    cardData: brandCard,
                    overrideAccess: true,
                    customer: customer));
            sl<CardWalletPageBloc>().cardData = widget.customer.brand;
            sl<AgentCardWalletPageBloc>().attachedCards = null;
            sl<AgentCardWalletPageBloc>().add(FetchAttachedCardsEvent(widget.customer.brand.cid));
          },
          title: Text("${brandCard.brandName} - ${widget.customer.user.name!}"),
          subtitle: Text(brandCard.category),
        );
      },
    );
  }
}
