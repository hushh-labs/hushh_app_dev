import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/agent_product.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/lookbook_product_bloc/bloc.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class ProductListTile extends StatelessWidget {
  final AgentProductModel product;
  final bool isLast;
  final bool shouldSelectProducts;

  const ProductListTile(
      {super.key,
        required this.product,
        required this.isLast,
        required this.shouldSelectProducts});

  @override
  Widget build(BuildContext context) {
    final controller = sl<LookBookProductBloc>();
    bool isAgent = sl<CardWalletPageBloc>().isAgent;

    return InkWell(
      onTap: shouldSelectProducts
          ? () {
        controller.emit(LoadingState());
        if (controller.selectedProducts.contains(product)) {
          controller.selectedProducts.remove(product);
        } else {
          controller.selectedProducts.add(product);
        }
        controller.emit(DoneState());
      }
          : null,
      child: Padding(
        padding: EdgeInsets.only(bottom: isLast ? 80 : 16.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.productImage.split(',').first,
                height: 96,
                width: 72 * 1.7,
                fit: BoxFit.cover,
                errorBuilder: (context, _, trace) {
                  return Container(
                    height: 96,
                    width: 72,
                    color: Colors.red,
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15),
                  ),
                  Text(
                    product.productDescription,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Color(0xFF637087)),
                  ),
                  Text(
                    "SKU: ${product.productSkuUniqueId}",
                    style: const TextStyle(color: Color(0xFF637087)),
                  ),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Color(0xFF637087)),
                      children: [
                        const TextSpan(text: "Price: "),
                        TextSpan(
                          text:
                          "${product.productCurrency}${product.productPrice}",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            if (!shouldSelectProducts)
              (isAgent
                  ? const SizedBox()
                  : IconButton(
                onPressed: () {
                  controller.add(SendProductInquiryToAgent(
                    context,
                    product,
                    sl<CardWalletPageBloc>().selectedAgent!,
                  ));
                },
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFEFEFEF),
                ),
                icon: ShaderMask(
                    shaderCallback: (shader) {
                      return const LinearGradient(
                        colors: [
                          Color(0XFFA342FF),
                          Color(0XFFE54D60),
                        ],
                        tileMode: TileMode.mirror,
                      ).createShader(shader);
                    },
                    child: const Icon(
                      Icons.message_outlined,
                      color: Colors.white,
                    )),
              ))
            // const Icon(Icons.arrow_forward_ios)
            else
              Checkbox(
                  value: controller.selectedProducts.contains(product),
                  onChanged: (value) {
                    controller.emit(LoadingState());
                    if (controller.selectedProducts.contains(product)) {
                      controller.selectedProducts.remove(product);
                    } else {
                      controller.selectedProducts.add(product);
                    }
                    controller.emit(DoneState());
                    // setState(() {});
                  })
          ],
        ),
      ),
    );
  }
}
