import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_product.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/lookbook_product_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/delete_product_bottom_sheet.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/product_list_tile.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProductsListView extends StatefulWidget {
  final List<AgentProductModel> products;
  final bool shouldSelectProducts;
  final Function(AgentProductModel) onDelete;
  final bool shouldDismiss;

  const ProductsListView(
      {super.key,
      required this.products,
      this.shouldSelectProducts = false,
      required this.onDelete,
      required this.shouldDismiss});

  @override
  State<ProductsListView> createState() => _ProductsListViewState();
}

class _ProductsListViewState extends State<ProductsListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.products.length,
      itemBuilder: (context, index) {
        final product = widget.products[index];
        return Dismissible(
          key: product.productId != null?Key(product.productId!):UniqueKey(),
          background: Container(
            color: Colors.red,
            child: const Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          direction: widget.shouldDismiss
              ? DismissDirection.endToStart
              : DismissDirection.none,
          onDismissed: (direction) {
            widget.onDelete(product);
          },
          confirmDismiss: (direction) async {
            Completer<bool> completer = Completer();
            if (direction == DismissDirection.endToStart) {
              final value = await showModalBottomSheet(
                isDismissible: true,
                enableDrag: true,
                backgroundColor: Colors.transparent,
                constraints: BoxConstraints(maxHeight: 30.h),
                context: context,
                builder: (_context) {
                  return DeleteProductBottomSheet(onCancel: () {
                    Navigator.pop(context, false);
                  }, onDelete: () {
                    completer.complete(true);
                    Navigator.pop(context, true);
                  });
                },
              );
              if (value != true) completer.complete(false);
            } else {
              completer.complete(false);
            }
            return completer.future;
          },
          child: ProductListTile(
            product: product,
            shouldSelectProducts: widget.shouldSelectProducts,
            isLast: index == widget.products.length - 1,
          ),
        );
      },
    );
  }
}

