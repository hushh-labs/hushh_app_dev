import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/bloc/receipt_radar_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/pages/receipt_radar_insights/insights_components.dart';
import 'package:hushh_app/app/shared/core/components/receipt_radar_loader_widget.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UserCardWalletInfoExpenseDetailsSection extends StatefulWidget {
  final CardModel cardData;

  const UserCardWalletInfoExpenseDetailsSection(
      {super.key, required this.cardData});

  @override
  State<UserCardWalletInfoExpenseDetailsSection> createState() =>
      _UserCardWalletInfoExpenseDetailsSectionState();
}

class _UserCardWalletInfoExpenseDetailsSectionState
    extends State<UserCardWalletInfoExpenseDetailsSection> {
  final controller = sl<ReceiptRadarBloc>();
  DateTime? oldestReceiptDate;

  @override
  void initState() {
    final receipts = controller.receipts ?? [];
    receipts.sort((a, b) => a.finalDate.compareTo(b.finalDate));
    oldestReceiptDate = receipts
        .firstWhereOrNull((element) => element.finalDate.year != 1800)
        ?.finalDate;
    controller.add(FetchInsightsEvent(AppLocalStorage.hushhId!, receipts));
    controller.add(FetchCategoriesFromReceiptsEvent(receipts));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: controller,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (controller.categories.isEmpty) ...[
                  const ReceiptRadarLoaderWidget()
                ] else ...[
                  SpendingCard(controller.spendingData,
                      oldestReceiptDate: oldestReceiptDate),
                  const SizedBox(height: 16),
                  CategoryPieChart(
                    categories: controller.categories
                        .sorted((a, b) => b.amount.compareTo(a
                            .amount)) // Sort by totalAmount in descending order
                        .take(3) // Take the top 3 categories
                        .toList(), // Convert to a List
                  ),
                  const SizedBox(height: 16),
                  CategoryList(
                      title: 'Categories', categories: controller.categories),
                  const SizedBox(height: 16),
                ],
                if (controller.topBrands.isNotEmpty) ...[
                  BrandList(
                      title: 'Top Brands',
                      brands: controller.topBrands.take(5).toList()),
                  const SizedBox(height: 16),
                ],
                if (controller.repeatBrands.isNotEmpty) ...[
                  BrandList(
                      title: 'Loyalty Metrics',
                      brands: controller.repeatBrands.take(5).toList()),
                ]
              ],
            ),
          );
        });
  }
}
