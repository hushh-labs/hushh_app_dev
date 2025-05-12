import 'package:hushh_app/currency_converter/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/bloc/home_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/home/presentation/components/coins_dashboard_sliver_app_bar.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Faq {
  String headerText;
  String expandedText;
  bool isExpanded;

  Faq({
    required this.headerText,
    required this.expandedText,
    this.isExpanded = false,
  });
}

class CoinsDashboard extends StatefulWidget {
  const CoinsDashboard({super.key});

  @override
  State<CoinsDashboard> createState() => _CoinsDashboardState();
}

class _CoinsDashboardState extends State<CoinsDashboard> {
  List<Faq> faqs = [
    Faq(headerText: "What are credits?", expandedText: "Dummy text for now"),
    Faq(
        headerText: "What is the value of 1 credit?",
        expandedText: "Dummy text for now"),
    Faq(
        headerText: "Can credits be clubbed with other offers?",
        expandedText: "Dummy text for now"),
    Faq(
        headerText:
            "Is there any minimum order value required to redeem credits?",
        expandedText: "Dummy text for now"),
    Faq(
        headerText: "Do credits have an expiry date?",
        expandedText: "Dummy text for now"),
    Faq(
        headerText: "How are credits redeemed?",
        expandedText: "Dummy text for now"),
    Faq(
        headerText:
            "Can credits be applied to all menu items, without any limit on usage?",
        expandedText: "Dummy text for now"),
    Faq(
        headerText:
            "Can credits be used on orders placed via Zomato/Swiggy/Amazon?",
        expandedText: "Dummy text for now"),
    Faq(
        headerText: "Are credits applicable on all days?",
        expandedText: "Dummy text for now"),
    Faq(
        headerText:
            "What happens if my credits have been debited but the transaction has failed?",
        expandedText: "Dummy text for now"),
    Faq(
        headerText:
            "Why are my credits debited when I did not make any transaction?",
        expandedText: "Dummy text for now"),
    Faq(
        headerText: "Do credits get refunded in case of order cancellation?",
        expandedText: "Dummy text for now"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CoinsDashboardSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 25.w,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: SvgPicture.asset('assets/hushh_coin_svg.svg'),
                              ),
                              const SizedBox(height: 4),
                              Text('1 Hushh coin',
                                  style: context.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w600))
                            ],
                          ),
                        ),
                        Text(
                          '=',
                          style: context.displayLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        SizedBox(
                          width: 25.w,
                          child: Column(
                            children: [
                              SvgPicture.asset('assets/hushh_cent_coin.svg'),
                              Text(
                                  '1 Cent',
                                  style: context.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w600))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),
                  Text(
                    'Terms & Conditions',
                    style: context.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                      '''• Hushh coins can be redeemed only on Hushh brands apps/websites by selecting the 'Use Hushh coins' option while checkout.
• Hushh coins cannot be transferred to the bank account.
• Hushh coins take 24-28 working hours to reflect in your account.
• The value of 1 Credit is 1 Rupee.
• Hushh coins are not valid on 31st December and on some specific days. The customers are informed in advance whenever credits are disabled.
• If Hushh coins are earned through an unfair practice or by mistake, coins will be auto-debited.'''),
                  const SizedBox(height: 36),
                  Text(
                    'FAQs',
                    style: context.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  ExpansionPanelList(
                    expansionCallback: (int index, bool isExpanded) {
                      bool isExpanded = faqs[index].isExpanded;
                      for (var element in faqs) {
                        element.isExpanded = false;
                      }
                      faqs[index].isExpanded = !isExpanded;
                      setState(() {});
                    },
                    children: faqs
                        .map<ExpansionPanel>((Faq e) => ExpansionPanel(
                            isExpanded: e.isExpanded,
                            headerBuilder: (context, isExpanded) => ListTile(
                                  title: Text(e.headerText),
                                  onTap: () {
                                    bool isExpanded = e.isExpanded;
                                    for (var element in faqs) {
                                      element.isExpanded = false;
                                    }
                                    e.isExpanded = !isExpanded;
                                    setState(() {});
                                  },
                                ),
                            body: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, bottom: 16),
                                child: Text(e.expandedText),
                              ),
                            )))
                        .toList(),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
