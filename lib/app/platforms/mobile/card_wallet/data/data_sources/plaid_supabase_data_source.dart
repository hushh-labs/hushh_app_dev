abstract class PlaidSupabaseDataSource {
  // Fetch user accounts
  Future<List<Map<String, dynamic>>> fetchUserAccounts(String hushhId);

  // Insert new account
  Future<void> insertAccount({
    required String hushhId,
    required String accountId,
    required String name,
    required String type,
    String? subtype,
    String? institutionName,
  });

  // Fetch account balances
  Future<List<Map<String, dynamic>>> fetchAccountBalances(String accountId);

  // Insert account balance
  Future<void> insertAccountBalance({
    required String accountId,
    required double currentBalance,
    double? availableBalance,
    String? currency,
  });

  // Fetch account transactions
  Future<List<Map<String, dynamic>>> fetchAccountTransactions(String accountId);

  // Insert transaction
  Future<void> insertTransaction({
    required String accountId,
    required String transactionId,
    required DateTime date,
    required double amount,
    String? category,
    String? merchantName,
    String? paymentChannel,
    String? memo,
  });

  // Fetch user loans
  Future<List<Map<String, dynamic>>> fetchUserLoans(String hushhId);

  // Insert loan
  Future<void> insertLoan({
    required String hushhId,
    required String loanId,
    required String accountId,
    required String loanType,
    required double principalAmount,
    double? interestRate,
    double? remainingBalance,
    DateTime? dueDate,
  });

  // Fetch user credit cards
  Future<List<Map<String, dynamic>>> fetchUserCreditCards(String hushhId);

  // Insert credit card
  Future<void> insertCreditCard({
    required String hushhId,
    required String accountId,
    required String creditCardId,
    required double creditLimit,
    double? availableCredit,
    double? currentBalance,
    DateTime? dueDate,
  });

  // Fetch bank statements
  Future<List<Map<String, dynamic>>> fetchBankStatements(String accountId);

  // Insert bank statement
  Future<void> insertBankStatement({
    required String accountId,
    required String statementId,
    required String month,
    required int year,
    required double totalIncome,
    required double totalExpenses,
    required double startingBalance,
    required double endingBalance,
  });
}
