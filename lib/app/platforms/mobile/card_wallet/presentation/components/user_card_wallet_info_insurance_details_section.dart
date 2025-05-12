import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/insurance_receipt.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/user_card_wallet_info_insurance_policy_details_component.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:icons_plus/icons_plus.dart';

class UserCardWalletInfoInsuranceDetailsSection extends StatefulWidget {
  final CardModel cardData;

  const UserCardWalletInfoInsuranceDetailsSection(
      {super.key, required this.cardData});

  @override
  State<UserCardWalletInfoInsuranceDetailsSection> createState() =>
      _UserCardWalletInfoInsuranceDetailsSectionState();
}

class _UserCardWalletInfoInsuranceDetailsSectionState
    extends State<UserCardWalletInfoInsuranceDetailsSection> {
  @override
  void initState() {
    sl<CardWalletPageBloc>()
        .add(FetchInsuranceDetailsEvent(card: widget.cardData));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: sl<CardWalletPageBloc>(),
        builder: (context, state) {
          if (sl<CardWalletPageBloc>().insuranceReceipts?.length == 0) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'No insurance receipt found 😢',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Please try again after sometime',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ],
              ),
            );
          }
          return SizedBox(
            child: PageView.builder(
                itemCount: sl<CardWalletPageBloc>().insuranceReceipts?.length,
                controller: sl<CardWalletPageBloc>().insurancePageController,
                itemBuilder: (context, index) {
                  return insuranceWidget(sl<CardWalletPageBloc>()
                      .insuranceReceipts
                      ?.elementAtOrNull(index));
                }),
          );
        });
  }

  Widget insuranceWidget(InsuranceReceipt? receipt) {
    bool weHaveReceipt = receipt != null;
    if (sl<CardWalletPageBloc>().insuranceReceipts?.isEmpty ?? false) {
      return const SizedBox();
    }
    bool isInsuranceEnding = false;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isInsuranceEnding) ...[
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
                child: const Row(
                  children: [
                    Icon(
                      IonIcons.alert_circle,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Insurance ends in 3 days',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
            Text(
              'Insurance Spending'.toUpperCase(),
              style: context.titleSmall?.copyWith(
                color: const Color(0xFF737373),
                fontWeight: FontWeight.w700,
                letterSpacing: 1.3,
              ),
            ),
            const SizedBox(height: 8),
            if (weHaveReceipt)
              Text(
                receipt.policyDetails.premiumAmount ?? '0',
                style: context.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w800),
              )
            else
              Container(
                width: 100,
                height: 30,
                color: Colors.grey.withOpacity(.3),
              ).toShimmer(!weHaveReceipt),
            const SizedBox(height: 18),
            Text(
              'Insurance Provider'.toUpperCase(),
              style: context.titleSmall?.copyWith(
                color: const Color(0xFF737373),
                fontWeight: FontWeight.w700,
                letterSpacing: 1.3,
              ),
            ),
            const SizedBox(height: 12),
            Image.network(
              receipt?.logo ?? '',
              width: 42,
              errorBuilder: (context, _, s) => Container(
                width: 40,
                height: 30,
                color: Colors.grey.withOpacity(.3),
              ).toShimmer(!weHaveReceipt),
            ),
            const SizedBox(height: 20),
            UserCardWalletInfoInsurancePolicyDetailsComponent(receipt: receipt),
            DetailSection(
              title: 'COVERAGE DETAILS',
              onTap: () {},
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'COVERED ITEMS',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Item Type: ${receipt?.coverageDetails.coveredItems?.itemType ?? 'N/A'}'),
                        Text(
                            'Make: ${receipt?.coverageDetails.coveredItems?.productCompany ?? 'N/A'}'),
                        Text(
                            'Model: ${receipt?.coverageDetails.coveredItems?.productModel ?? 'N/A'}'),
                        Text(
                            'Year: ${receipt?.coverageDetails.coveredItems?.productManufacturingYear ?? 'N/A'}'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Divider(height: 1, color: Colors.grey[200]),
                    const SizedBox(height: 16),
                  ],
                ),
                DetailItem(
                    label: 'COMPREHENSIVE',
                    value: receipt?.coverageDetails
                            .comprehensiveCoverageTypePolicy.name ??
                        'N/A'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DetailItem extends StatelessWidget {
  final String label;
  final String? value;

  const DetailItem({
    Key? key,
    required this.label,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        if (value != null)
          Text(
            value!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          )
        else
          const Text(
            'N/A',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        // Container(
        //   width: 100,
        //   height: 18,
        //   color: Colors.grey.withOpacity(.3),
        // ).toShimmer(true),
        const SizedBox(height: 10),
        Divider(height: 1, color: Colors.grey[200]),
        const SizedBox(height: 10),
      ],
    );
  }
}

// Section Header Component
class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const SectionHeader({
    Key? key,
    required this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: context.titleSmall?.copyWith(
            color: const Color(0xFF737373),
            fontWeight: FontWeight.w700,
            letterSpacing: 1.3,
          ),
        ),
        Icon(Icons.chevron_right, color: Colors.grey[400]),
      ],
    );
  }
}

// Detail Section Component
class DetailSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final VoidCallback? onTap;

  const DetailSection({
    Key? key,
    required this.title,
    required this.children,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onTap,
            child: SectionHeader(title: title, onTap: onTap),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ],
      ),
    );
  }
}
