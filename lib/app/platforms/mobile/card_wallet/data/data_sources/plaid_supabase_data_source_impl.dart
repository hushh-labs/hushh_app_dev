// import 'package:hushh_app/app/platforms/mobile/card_wallet/data/data_sources/plaid_supabase_data_source.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// class PlaidSupabaseDataSourceImpl extends PlaidSupabaseDataSource {
//   final SupabaseClient supabase = Supabase.instance.client;
//
//   // Fetch User Accounts
//   @override
//   Future<List<Map<String, dynamic>>> fetchUserAccounts(String hushhId) async {
//     final response = await supabase
//         .schema('financials')
//         .rpc('get_user_accounts', params: {'_hushh_id': hushhId})
//         .execute();
//
//     if (response.error != null) {
//       throw Exception('Failed to fetch user accounts: ${response.error!.message}');
//     }
//
//     return (response.data as List).map((e) => e as Map<String, dynamic>).toList();
//   }
//
//   // Insert New Account
//   @override
//   Future<void> insertAccount({
//     required String hushhId,
//     required String accountId,
//     required String name,
//     required String type,
//     String? subtype,
//     String? institutionName,
//   }) async {
//     final response = await supabase.schema('financials').rpc('insert_account', params: {
//       '_hushh_id': hushhId,
//       '_account_id': accountId,
//       '_name': name,
//       '_type': type,
//       '_subtype': subtype,
//       '_institution_name': institutionName,
//     }).execute();
//
//     if (response.error != null) {
//       throw Exception('Failed to insert account: ${response.error!.message}');
//     }
//   }
//
//   // Fetch Balances
//   @override
//   Future<List<Map<String, dynamic>>> fetchAccountBalances(String accountId) async {
//     final response = await supabase
//         .schema('financials')
//         .rpc('get_account_balance', params: {'_account_id': accountId})
//         .execute();
//
//     if (response.error != null) {
//       throw Exception('Failed to fetch account balances: ${response.error!.message}');
//     }
//
//     return (response.data as List).map((e) => e as Map<String, dynamic>).toList();
//   }
//
//   // Insert Account Balance
//   @override
//   Future<void> insertAccountBalance({
//     required String accountId,
//     required double currentBalance,
//     double? availableBalance,
//     String? currency = 'USD',
//   }) async {
//     final response = await supabase.schema('financials').rpc('insert_balance', params: {
//       '_account_id': accountId,
//       '_current_balance': currentBalance,
//       '_available_balance': availableBalance,
//       '_currency': currency,
//     }).execute();
//
//     if (response.error != null) {
//       throw Exception('Failed to insert account balance: ${response.error!.message}');
//     }
//   }
//
//   // Fetch Transactions for an Account
//   @override
//   Future<List<Map<String, dynamic>>> fetchAccountTransactions(String accountId) async {
//     final response = await supabase
//         .schema('financials')
//         .rpc('get_account_transactions', params: {'_account_id': accountId})
//         .execute();
//
//     if (response.error != null) {
//       throw Exception('Failed to fetch transactions: ${response.error!.message}');
//     }
//
//     return (response.data as List).map((e) => e as Map<String, dynamic>).toList();
//   }
//
//   // Insert New Transaction
//   @override
//   Future<void> insertTransaction({
//     required String accountId,
//     required String transactionId,
//     required DateTime date,
//     required double amount,
//     String? category,
//     String? merchantName,
//     String? paymentChannel,
//     String? memo,
//   }) async {
//     final response = await supabase.schema('financials').rpc('insert_transaction', params: {
//       '_account_id': accountId,
//       '_transaction_id': transactionId,
//       '_date': date.toIso8601String(),
//       '_amount': amount,
//       '_category': category,
//       '_merchant_name': merchantName,
//       '_payment_channel': paymentChannel,
//       '_memo': memo,
//     }).execute();
//
//     if (response.error != null) {
//       throw Exception('Failed to insert transaction: ${response.error!.message}');
//     }
//   }
//
//   // Fetch Loans for a User
//   @override
//   Future<List<Map<String, dynamic>>> fetchUserLoans(String hushhId) async {
//     final response = await supabase
//         .schema('financials')
//         .rpc('get_user_loans', params: {'_hushh_id': hushhId})
//         .execute();
//
//     if (response.error != null) {
//       throw Exception('Failed to fetch loans: ${response.error!.message}');
//     }
//
//     return (response.data as List).map((e) => e as Map<String, dynamic>).toList();
//   }
//
//   // Insert New Loan
//   @override
//   Future<void> insertLoan({
//     required String hushhId,
//     required String loanId,
//     required String accountId,
//     required String loanType,
//     required double principalAmount,
//     double? interestRate,
//     double? remainingBalance,
//     DateTime? dueDate,
//   }) async {
//     final response = await supabase.schema('financials').rpc('insert_loan', params: {
//       '_hushh_id': hushhId,
//       '_loan_id': loanId,
//       '_account_id': accountId,
//       '_loan_type': loanType,
//       '_principal_amount': principalAmount,
//       '_interest_rate': interestRate,
//       '_remaining_balance': remainingBalance,
//       '_due_date': dueDate?.toIso8601String(),
//     }).execute();
//
//     if (response.error != null) {
//       throw Exception('Failed to insert loan: ${response.error!.message}');
//     }
//   }
//
//   // Fetch Credit Cards for a User
//   @override
//   Future<List<Map<String, dynamic>>> fetchUserCreditCards(String hushhId) async {
//     final response = await supabase
//         .schema('financials')
//         .rpc('get_user_credit_cards', params: {'_hushh_id': hushhId})
//         .execute();
//
//     if (response.error != null) {
//       throw Exception('Failed to fetch credit cards: ${response.error!.message}');
//     }
//
//     return (response.data as List).map((e) => e as Map<String, dynamic>).toList();
//   }
//
//   // Insert New Credit Card
//   @override
//   Future<void> insertCreditCard({
//     required String hushhId,
//     required String accountId,
//     required String creditCardId,
//     required double creditLimit,
//     double? availableCredit,
//     double? currentBalance,
//     DateTime? dueDate,
//   }) async {
//     final response = await supabase.schema('financials').rpc('insert_credit_card', params: {
//       '_hushh_id': hushhId,
//       '_account_id': accountId,
//       '_credit_card_id': creditCardId,
//       '_credit_limit': creditLimit,
//       '_available_credit': availableCredit,
//       '_current_balance': currentBalance,
//       '_due_date': dueDate?.toIso8601String(),
//     }).execute();
//
//     if (response.error != null) {
//       throw Exception('Failed to insert credit card: ${response.error!.message}');
//     }
//   }
//
//   // Fetch Bank Statements for an Account
//   @override
//   Future<List<Map<String, dynamic>>> fetchBankStatements(String accountId) async {
//     final response = await supabase
//         .schema('financials')
//         .rpc('get_bank_statements', params: {'_account_id': accountId})
//         .execute();
//
//     if (response.error != null) {
//       throw Exception('Failed to fetch bank statements: ${response.error!.message}');
//     }
//
//     return (response.data as List).map((e) => e as Map<String, dynamic>).toList();
//   }
//
//   // Insert Bank Statement
//   @override
//   Future<void> insertBankStatement({
//     required String accountId,
//     required String statementId,
//     required String month,
//     required int year,
//     required double totalIncome,
//     required double totalExpenses,
//     required double startingBalance,
//     required double endingBalance,
//   }) async {
//     final response = await supabase.schema('financials').rpc('insert_bank_statement', params: {
//       '_account_id': accountId,
//       '_statement_id': statementId,
//       '_month': month,
//       '_year': year,
//       '_total_income': totalIncome,
//       '_total_expenses': totalExpenses,
//       '_starting_balance': startingBalance,
//       '_ending_balance': endingBalance,
//     }).execute();
//
//     if (response.error != null) {
//       throw Exception('Failed to insert bank statement: ${response.error!.message}');
//     }
//   }
// }
