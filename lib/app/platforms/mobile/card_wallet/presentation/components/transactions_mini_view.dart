import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hushh_app/app/platforms/mobile/card_market/data/models/transaction_model.dart';
import 'package:hushh_app/app/shared/config/constants/constants.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/color_utils.dart';
import 'package:hushh_app/app/shared/core/utils/utils_impl.dart';
import 'package:intl/intl.dart';

class TransactionsMiniView extends StatelessWidget {
  final List<TransactionModel> transactions;

  const TransactionsMiniView({super.key, required this.transactions});

  bool get noData => transactions.isEmpty;

  bool get isReceiptRadarLinked => AppLocalStorage.hasUserConnectedReceiptRadar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(
              noData && !isReceiptRadarLinked
                  ? defaultTransactions.length
                  : transactions.length,
              (index) => TransactionTile(
                    transaction: noData && !isReceiptRadarLinked
                        ? defaultTransactions[index]
                        : transactions[index],
                  ))
        ],
      ),
    );
  }
}

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionTile({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = ColorUtils.stringToColor(transaction.title);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: transaction.image?.isEmpty ?? true ? color : null,
        backgroundImage: transaction.image?.isEmpty ?? true
            ? null
            : CachedNetworkImageProvider(transaction.image!),
        child: transaction.image?.isEmpty ?? true
            ? Text(
                transaction.title[0].toUpperCase(),
                style: TextStyle(
                  color: ColorUtils.isDark(color) ? Colors.white : Colors.black,
                ),
              )
            : null,
        // imageUrl:
        //     'https://www.adaptivewfs.com/wp-content/uploads/2020/07/logo-placeholder-image-300x300.png',
      ),
      title: Text(
        transaction.title,
        style: const TextStyle(fontSize: 15),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            transaction.desc,
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            transaction.dateTime.year == 1800
                ? 'N/A'
                : DateFormat('dd/MM/yyyy').format(transaction.dateTime),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      trailing: Text(
        '-${Utils().getCurrencyFromCurrencySymbol(transaction.currency)?.shorten() ?? ''}${transaction.amount.toStringAsFixed(2)}',
        style: const TextStyle(
          fontSize: 13,
          color: Colors.redAccent,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
