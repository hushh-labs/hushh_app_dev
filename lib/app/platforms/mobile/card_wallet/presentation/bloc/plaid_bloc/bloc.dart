import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/transaction.dart';
import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/transaction_balance.dart';
import 'package:hushh_app/app/shared/core/local_storage/local_storage.dart';
import 'package:hushh_app/app/shared/core/utils/toast_manager.dart';
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/models/account.dart';

part 'events.dart';

part 'states.dart';

class PlaidBloc extends Bloc<PlaidEvent, PlaidState> {
  PlaidBloc() : super(PlaidInitialState()) {
    on<FetchFinanceCardInfoEvent>(fetchFinanceCardInfoEvent);
    _initializePlaidListeners();
  }

  StreamSubscription<LinkEvent>? _streamEvent;
  StreamSubscription<LinkExit>? _streamExit;
  StreamSubscription<LinkSuccess>? _streamSuccess;
  LinkTokenConfiguration? _configuration;

  void _initializePlaidListeners() {
    _streamEvent = PlaidLink.onEvent.listen(_onEvent);
    _streamExit = PlaidLink.onExit.listen(_onExit);
    _streamSuccess = PlaidLink.onSuccess.listen(_onSuccess);
  }

  void _onEvent(LinkEvent event) {
    final name = event.name;
    final metadata = event.metadata.description();
    debugPrint("onEvent: $name, metadata: $metadata");
  }

  void _onSuccess(LinkSuccess event) async {
    final token = event.publicToken;
    final metadata = event.metadata.description();
    debugPrint("onSuccess: $token, metadata: $metadata");
    await onPlaidSuccess(event);
  }

  void _onExit(LinkExit event) {
    final metadata = event.metadata.description();
    final error = event.error?.description();
    debugPrint("onExit metadata: $metadata, error: $error");
  }

  @override
  Future<void> close() {
    _streamEvent?.cancel();
    _streamExit?.cancel();
    _streamSuccess?.cancel();
    return super.close();
  }

  List<TransactionBalance> transactionBalance = [];
  List<Account> accounts = [];
  var transactionBody;

  refreshPlaidAccessToken(String token) async {
    var response = await http.post(
        Uri.parse('https://sandbox.plaid.com/item/public_token/exchange'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "client_id": "63f87207e9b49300135afac8",
          "secret": "606fc93026114c32eb5dfc2d6725b6",
          "public_token": token
        }));
    if (response.statusCode == 200) {
      var tokenBody = jsonDecode(response.body);
      debugPrint(tokenBody.toString());
      AppLocalStorage.putPlaidAccessToken(tokenBody["access_token"]);
      await upsertToken(AppLocalStorage.hushhId!, tokenBody["access_token"]);
    }
  }

  Future<void> upsertToken(String userId, String token) async {
    final response = await Supabase.instance.client
        .schema('financials')
        .rpc('insert_or_update_token', params: {
      '_user_id': userId,
      '_token': token,
    }).select();
    debugPrint("upserted token::$response");
  }

  Future<void> createLinkTokenConfiguration(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.all(16),
              child: const CupertinoActivityIndicator(),
            ),
          ],
        );
      },
    );

    try {
      var response = await http.post(
        Uri.parse('https://sandbox.plaid.com/link/token/create'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "client_id": "63f87207e9b49300135afac8",
          "secret": "606fc93026114c32eb5dfc2d6725b6",
          "user": {"client_user_id": "df64e0a2b1a0f5f4dd4f0acc99ebdf"},
          "client_name": "Plaid",
          "products": ["auth", "transactions"],
          "country_codes": ["us"],
          "language": "en",
          "android_package_name": "hush1one.com"
        }),
      );

      Navigator.pop(context);

      if (response.statusCode == 200) {
        var tokenBody = jsonDecode(response.body);
        _configuration = LinkTokenConfiguration(
          token: tokenBody["link_token"],
        );
        
        // Create and open Plaid Link
        await PlaidLink.create(configuration: _configuration!);
        await PlaidLink.open();
      } else {
        throw Exception('Failed to create link token: ${response.body}');
      }
    } catch (e) {
      Navigator.pop(context);
      debugPrint('Error creating link token: $e');
      // Handle error appropriately
    }
  }

  onPlaidSuccess(LinkSuccess event) async {
    AppLocalStorage.putPlaidInstitutionName(event.metadata.institution?.name ?? '');
    await refreshPlaidAccessToken(event.publicToken);
    await Future.wait([fetchAndProcessBalances(), fetchAndUpsertTransactions()]);
    emit(SuccessFinanceCardState());
  }

  FutureOr<void> fetchFinanceCardInfoEvent(
      FetchFinanceCardInfoEvent event, Emitter<PlaidState> emit) async {
    emit(FetchingFinanceCardState());
    if (false) {
      await createLinkTokenConfiguration(event.context);
    } else {
      await Future.wait(
          [fetchAndProcessBalances(), fetchAndUpsertTransactions()]);
      emit(SuccessFinanceCardState());
    }
  }

  // Insert balance into database using Supabase RPC
  Future<void> insertBalance(TransactionBalance balance) async {
    await Supabase.instance.client
        .schema('financials')
        .rpc('insert_balance', params: balance.toRpcParams());
  }

  List<Transaction> transactions = [];

  Future<void> fetchAndProcessBalances() async {
    String? token = AppLocalStorage.plaidAccessToken;

    // Step 1: Fetch balance data from Plaid API
    var responseBalance = await http.post(
      Uri.parse('https://sandbox.plaid.com/accounts/balance/get'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "client_id": "63f87207e9b49300135afac8",
        "secret": "606fc93026114c32eb5dfc2d6725b6",
        "access_token": token,
      }),
    );

    if (responseBalance.statusCode == 200) {
      var output = jsonDecode(responseBalance.body);

      // Step 2: Map response accounts to a list of Account objects
      List<Account> fetchedAccounts = (output['accounts'] as List)
          .map((account) => Account.fromJson(account))
          .toList();

      // Step 3: Insert or upsert accounts before inserting balances
      for (var account in fetchedAccounts) {
        await upsertAccount(account);
      }

      // Step 4: Map response accounts to a list of Balance objects
      List<TransactionBalance> balances = (output['accounts'] as List)
          .map((account) => TransactionBalance.fromJson(account))
          .toList();

      // Step 5: Insert each balance into the database using RPC
      for (var balance in balances) {
        await insertBalance(balance);
      }

      // Step 6: Store the fetched accounts and balances for UI use
      accounts = fetchedAccounts;
      transactionBalance = balances;
    } else {
      throw Exception('Failed to fetch balances: ${responseBalance.body}');
    }
  }

  // Upsert account into database using Supabase RPC
  Future<void> upsertAccount(Account account) async {
    await Supabase.instance.client.schema('financials').rpc('insert_account',
        params: account.toRpcParams(AppLocalStorage.hushhId!));
  }

  Future<void> fetchAndUpsertTransactions() async {
    print("kdjfhkdsjh");
    String? token = AppLocalStorage.plaidAccessToken;

    // Step 1: Fetch transactions from Plaid API
    var responseTransactions = await http.post(
      Uri.parse('https://sandbox.plaid.com/transactions/sync'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "client_id": "63f87207e9b49300135afac8",
        "secret": "606fc93026114c32eb5dfc2d6725b6",
        "access_token": token,
        "count": 10
      }),
    );

    if (responseTransactions.statusCode == 200) {
      var output = jsonDecode(responseTransactions.body);

      // Step 2: Map response transactions to a list of Transaction objects
      List<Transaction> fetchedTransactions = (output['added'] as List)
          .map((transaction) => Transaction.fromJson(transaction))
          .toList();

      // Step 4: Store the transactions for UI use
      transactions = fetchedTransactions;
      emit(TransactionsUpdatedState());

      // Step 3: Upsert each transaction into the database using RPC
      await Future.wait(List.generate(transactions.length,
          (index) => upsertTransaction(transactions[index])));
    } else {
      throw Exception(
          'Failed to fetch transactions: ${responseTransactions.body}');
    }
  }

  // Upsert transaction into database using Supabase RPC
  Future<void> upsertTransaction(Transaction transaction) async {
    await Supabase.instance.client
        .schema('financials')
        .rpc('insert_transaction', params: transaction.toRpcParams());
  }
}
