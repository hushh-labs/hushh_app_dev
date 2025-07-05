// app/platforms/mobile/card_wallet/presentation/pages/agent_products.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_product.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/customer_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/inventory_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/lookbook_product_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/agent_profile_header.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/products_grid_view.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/pages/agent_order_checkout.dart';
import 'package:hushh_app/app/shared/config/constants/enums.dart';
import 'package:hushh_app/app/shared/config/routes/routes.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/components/custom_text_field.dart';
import 'package:hushh_app/app/shared/core/components/hushh_agent_button.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';

class AgentProductsArgs {
  final ProductTileType productTileType;
  final CustomerModel? customer;
  final int? brandId;
  final String? lookbookId;
  final List<AgentProductModel>? products;

  AgentProductsArgs({
    required this.productTileType,
    this.brandId,
    this.customer,
    this.lookbookId,
    this.products,
  });
}

class AgentProducts extends StatefulWidget {
  const AgentProducts({super.key});

  @override
  State<AgentProducts> createState() => _AgentProductsState();
}

class _AgentProductsState extends State<AgentProducts> {
  final controller = sl<LookBookProductBloc>();

  bool get isAgent => sl<CardWalletPageBloc>().isAgent;

  @override
  void initState() {
    sl<InventoryBloc>().selectedProductIds = [];
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final args =
          ModalRoute.of(context)!.settings.arguments as AgentProductsArgs;
      print(
          '📊 [AGENT_PRODUCTS] Initializing with brandId: \\${args.brandId}, lookbookId: \\${args.lookbookId}');
      print('📊 [AGENT_PRODUCTS] ProductTileType: \\${args.productTileType}');
      if (args.lookbookId != null) {
        // If products are not loaded, fetch all products for the agent's brand
        if (controller.inventoryAllProductsResult == null &&
            AppLocalStorage.agent != null) {
          controller
              .add(FetchAllProductsEvent(AppLocalStorage.agent!.agentBrandId));
        }
        // Otherwise, products will be filtered by lookbookId in build
      } else if (args.brandId != null) {
        controller.add(FetchAllProductsEvent(args.brandId!));
      } else {
        print(
            '📊 [AGENT_PRODUCTS] No lookbookId or brandId provided, cannot fetch products');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as AgentProductsArgs;

    return BlocBuilder<LookBookProductBloc, LookBookProductState>(
      bloc: controller,
      builder: (context, state) {
        if (controller.inventoryAllProductsResult == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Filter products by lookbookId if present
        List<AgentProductModel> products = [];
        if (args.lookbookId != null) {
          products = controller.inventoryAllProductsResult!.products
              .where((p) => p.lookbookId == args.lookbookId)
              .toList();
        } else {
          products = controller.inventoryAllProductsResult!.products;
        }

        return Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: args.productTileType ==
                  ProductTileType.selectProducts
              ? BlocBuilder(
                  bloc: controller,
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16)
                          .copyWith(bottom: Platform.isIOS ? 16 : 0),
                      child: SizedBox(
                        height: 56,
                        child: HushhLinearGradientButton(
                          text: 'Next',
                          height: 46,
                          color: Colors.black,
                          radius: 6,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.agentOrderCheckout,
                              arguments: AgentOrderCheckoutArgs(
                                  products: controller
                                      .inventoryAllProductsResult!.products
                                      .where((element) => sl<InventoryBloc>()
                                          .selectedProductIds
                                          .contains(element.productSkuUniqueId))
                                      .toList(),
                                  customerModel: args.customer!),
                            );
                          },
                        ),
                      ),
                    );
                  },
                )
              : null,
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
            title: Text(
              args.productTileType == ProductTileType.selectProducts
                  ? 'Select Products'
                  : 'All Products',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: BlocBuilder(
                bloc: controller,
                builder: (context, state) {
                  print(
                      '📊 [AGENT_PRODUCTS] BlocBuilder state: ${state.runtimeType}');
                  print(
                      '📊 [AGENT_PRODUCTS] inventoryAllProductsResult: ${controller.inventoryAllProductsResult}');
                  if (controller.inventoryAllProductsResult != null) {
                    print(
                        '📊 [AGENT_PRODUCTS] Products count: ${controller.inventoryAllProductsResult!.products.length}');
                    print('📊 [AGENT_PRODUCTS] First few products:');
                    for (int i = 0;
                        i <
                                controller.inventoryAllProductsResult!.products
                                    .length &&
                            i < 3;
                        i++) {
                      final product =
                          controller.inventoryAllProductsResult!.products[i];
                      print(
                          '📊 [AGENT_PRODUCTS] Product $i: ${product.productName} - ${product.productPrice}');
                    }
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        controller: controller.searchProductsController,
                        onChanged: (value) {
                          controller.add(const SearchProductEvent());
                        },
                      ),
                      Expanded(
                        child: controller.inventoryAllProductsResult != null
                            ? ProductsGridView(
                                productTileType: args.productTileType,
                                products: state is ProductSearchState ||
                                        state is ProductSearchFinishedState
                                    ? controller.allProductSearch!
                                    : products,
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                      ),
                    ],
                  );
                }),
          ),
        );
      },
    );
  }

  Widget customButton({
    required IconData icon,
    required String name,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        height: actionButtonHeight,
        // clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
            color: const Color(0xffE7E7E7),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(icon),
            Text(
              name,
              style: context.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
