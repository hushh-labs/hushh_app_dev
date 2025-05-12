import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/inventory_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/products_grid_view.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class InventoryProductsPageArgs {
  final ProductTileType productTileType;
  final int configurationId;
  final int brandId;

  InventoryProductsPageArgs({
    required this.productTileType,
    required this.configurationId,
    required this.brandId,
  });
}

class InventoryProductsPage extends StatefulWidget {
  const InventoryProductsPage({super.key});

  @override
  State<InventoryProductsPage> createState() => _InventoryProductsPageState();
}

class _InventoryProductsPageState extends State<InventoryProductsPage> {
  final controller = sl<InventoryBloc>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final InventoryProductsPageArgs res = ModalRoute.of(context)!
          .settings
          .arguments! as InventoryProductsPageArgs;
      controller.add(FetchProductsInInventoryEvent(res.configurationId, res.brandId));
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments!
        as InventoryProductsPageArgs;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: SvgPicture.asset('assets/back.svg')),
        ),
        centerTitle: false,
        title: const Text(
          'Products',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocBuilder(
            bloc: controller,
            builder: (context, state) {
              final productResult = controller.inventoryProductsResult;
              if (state is FetchProductsResultFromInventoryState) {
                return const Center(child: CupertinoActivityIndicator());
              }
              return ProductsGridView(
                products: productResult?.products ?? [],
                productTileType: args.productTileType,
              );
              // return ProductsListView(
              //     products: productResult?.products ?? [],
              //     onDelete: (_) {},
              //     shouldDismiss: false);
            }),
      ),
    );
  }
}
