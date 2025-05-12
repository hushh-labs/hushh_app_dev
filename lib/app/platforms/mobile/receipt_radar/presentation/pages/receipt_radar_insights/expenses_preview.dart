import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/receipt_model.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/bloc/receipt_radar_bloc/bloc.dart';
import 'package:hushh_app/app/platforms/mobile/receipt_radar/presentation/pages/receipt_radar_items.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';

class ExpensesPreview extends StatelessWidget {
  final String title;
  const ExpensesPreview({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title Receipts'),
      ),
      body: BlocBuilder(
          bloc: sl<ReceiptRadarBloc>(),
          builder: (context, state) {
            List<ReceiptModel> newReceipts =
                sl<ReceiptRadarBloc>().receipts ?? [];
            final filterReceipts = newReceipts
                .where((element) =>
                    sl<ReceiptRadarBloc>()
                        .filterBasedReceipts
                        ?.contains(element) ??
                    false)
                .toList();
            if (filterReceipts.isNotEmpty) {
              newReceipts = filterReceipts;
            }
            List<ReceiptModel> sortedReceipts;

            newReceipts
                .sort((a, b) => sl<ReceiptRadarBloc>().sortReceipts(a, b));
            sortedReceipts = newReceipts;

            return ListView.builder(
              itemCount: sortedReceipts.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return ReceiptListTile(receipt: sortedReceipts[index]);
              },
            );
          }),
    );
  }
}
