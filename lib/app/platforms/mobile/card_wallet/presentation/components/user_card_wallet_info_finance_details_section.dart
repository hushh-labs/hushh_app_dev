import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/presentation/bloc/plaid_bloc/bloc.dart';
import 'package:hushh_app/app/shared/config/constants/extensions.dart';
import 'package:hushh_app/app/shared/config/theme/text_theme.dart';
import 'package:hushh_app/app/shared/core/inject_dependency/dependencies.dart';
import 'package:hushh_app/app/shared/core/utils/utils_impl.dart';
import 'package:intl/intl.dart';

class UserCardWalletInfoFinanceDetailsSection extends StatelessWidget {
  const UserCardWalletInfoFinanceDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [BalanceWidget()],
    );
  }
}

class BalanceWidget extends StatelessWidget {
  const BalanceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: sl<PlaidBloc>(),
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'current balance'.toUpperCase(),
                    style: context.titleSmall?.copyWith(
                      color: const Color(0xFF737373),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.3,
                    ),
                  ),
                  Text(
                    (Utils().getCurrencyFromCurrencySymbol(sl<PlaidBloc>()
                                    .transactionBalance
                                    .firstOrNull
                                    ?.currency)
                                ?.shorten() ??
                            '\$') +
                        (sl<PlaidBloc>()
                                .transactionBalance
                                .firstOrNull
                                ?.availableBalance
                                ?.toString() ??
                            '0'),
                    style: context.headlineLarge
                        ?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.2),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account'.toUpperCase(),
                    style: context.titleSmall?.copyWith(
                      color: const Color(0xFF737373),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sl<PlaidBloc>().accounts.firstOrNull?.name ?? '',
                    style: context.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.2),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Transactions'.toUpperCase(),
                    style: context.titleSmall?.copyWith(
                      color: const Color(0xFF737373),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.3,
                    ),
                  ),
                  Column(
                    children: List.generate(
                        sl<PlaidBloc>().transactions.take(7).length,
                        (index) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                sl<PlaidBloc>()
                                        .transactions
                                        .elementAt(index)
                                        .merchantName ??
                                    'N/A',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Text(DateFormat('dd.MM.yyyy').format(
                                  sl<PlaidBloc>()
                                      .transactions
                                      .elementAt(index)
                                      .date)),
                              trailing: Text(
                                '${sl<PlaidBloc>().transactions.elementAt(index).amount.isNegative?'-':''}\$${sl<PlaidBloc>().transactions.elementAt(index).amount.toString().replaceAll('-', '')}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 18),
                              ),
                            )),
                  )
                ],
              ),
            ],
          ),
        );
      }
    );
  }
}
