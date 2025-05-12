import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/card_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/customer_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/receipt_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/agent_card_wallet_ai_summary.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/bloc/receipt_radar_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/components/receipt_radar_app_bar.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/pages/receipt_radar_insights/insights_components.dart';
import 'package:hushh_app/app/shared/core/ai_handler/ai_handler.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class ReceiptRadarInsightsArgs {
  final String uid;
  final CardModel? brand;
  final List<ReceiptModel>? receipts;
  final String? brandName;
  final String? brandCategory;
  final CardModel cardData;
  final CustomerModel customer;

  ReceiptRadarInsightsArgs({
    required this.uid,
    this.brand,
    this.receipts,
    this.brandName,
    this.brandCategory,
    required this.cardData,
    required this.customer,
  });
}

class ReceiptRadarInsights extends StatefulWidget {
  const ReceiptRadarInsights({super.key});

  @override
  State<ReceiptRadarInsights> createState() => _ReceiptRadarInsightsState();
}

class _ReceiptRadarInsightsState extends State<ReceiptRadarInsights> {
  final controller = sl<ReceiptRadarBloc>();
  DateTime? oldestReceiptDate;

  final StreamController<String> _streamController = StreamController<String>();
  String aiSummary = "";

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final args = ModalRoute.of(context)!.settings.arguments!
          as ReceiptRadarInsightsArgs;
      final receipts = args.receipts;
      receipts?.sort((a, b) => a.finalDate.compareTo(b.finalDate));
      oldestReceiptDate = receipts
          ?.firstWhere((element) => element.finalDate.year != 1800)
          .finalDate;
      controller.add(FetchInsightsEvent(args.uid, args.receipts,
          brandName: args.brandName, brandCategory: args.brandCategory));
      _fetchAndStreamSummary(args);
    });
    super.initState();
  }

  Stream<String> addDelay(Stream<String> input) async* {
    Duration dur = const Duration(milliseconds: 60);
    await Future.delayed(dur);
    await for (var event in input) {
      yield event;
      await Future.delayed(dur);
    }
  }

  void _fetchAndStreamSummary(args) async {
    // Simulate streaming response
    final stream = AiSummaryHandler().getChatResponseStream(
        context,
        args.cardData.id!,
        args.customer.user.name,
        args.cardData.cardName,
        args.customer.user.hushhId!);
    addDelay(stream).listen(
      (event) {
        if (mounted) {
          setState(() {
            try {
              final parsedEvent = event;
              aiSummary += parsedEvent;
              _streamController.add(aiSummary);
            } catch (_) {}
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments! as ReceiptRadarInsightsArgs;
    return Scaffold(
      appBar: ReceiptRadarAppBar(
        title: "AI Insights 🤫",
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: JustTheTooltip(
              content: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'We\'ve curated your personal dashboard to keep a track of your expenses',
                ),
              ),
              backgroundColor: Colors.grey.shade300,
              triggerMode: TooltipTriggerMode.tap,
              enableFeedback: true,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.help_outline,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder<String>(
                stream: _streamController.stream,
                builder: (context, snapshot) {
                  return AgentCardWalletAiSummary(content: snapshot.data);
                }),
            BlocBuilder(
                bloc: controller,
                builder: (context, state) {
                  if (state is ReceiptRadarFetchingState) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 26),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SpendingCard(controller.spendingData,
                            oldestReceiptDate: oldestReceiptDate),
                        const SizedBox(height: 20.0),
                        BrandList(
                            title: 'Top Brands', brands: controller.topBrands),
                        const SizedBox(height: 20.0),
                        BrandList(
                            title: 'Loyalty Metrics',
                            brands: controller.repeatBrands),
                        const SizedBox(height: 20.0),
                        SpendingByBrand(controller.spendingByBrandList),
                        const SizedBox(height: 20.0),
                        if (args.brand?.categoryId != null)
                          AppUsageByBrand(
                            hushhId: args.uid,
                            cardCategoryId: args.brand!.categoryId!,
                          )
                      ],
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
