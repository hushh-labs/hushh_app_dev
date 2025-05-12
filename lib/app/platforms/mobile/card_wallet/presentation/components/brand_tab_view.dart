import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/models/transaction_model.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/card_wallet/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/components/brand_card_list_view.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BrandTabView extends StatefulWidget {
  const BrandTabView({super.key});

  @override
  State<BrandTabView> createState() => _BrandTabViewState();
}

class _BrandTabViewState extends State<BrandTabView> {
  final controller = sl<CardWalletPageBloc>();
  late Stream<List<TransactionModel>> transactionStream;

  @override
  void initState() {
    transactionStream = controller.getTransactionsStream().asBroadcastStream();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log(Supabase.instance.client.auth.currentSession!.accessToken.toString());
    return controller.brandCardList.isNotEmpty
        ? BrandCardListView(
            isDetailsScreen: false,
            onIndexChanged: () {
              setState(() {});
            },
          )
        : const SizedBox();
  }
}
