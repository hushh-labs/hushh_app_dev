// import 'package:hushh_app/app/platforms/mobile/card_wallet/data/models/transaction.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
//
// class DatabaseHandler {
//   static Database? _database;
//   static const String tableName = 'transactions';
//
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await initializeDatabase();
//     return _database!;
//   }
//
//   Future<Database> initializeDatabase() async {
//     final path = await getDatabasesPath();
//     return openDatabase(
//       join(path, 'finance_database.db'),
//       onCreate: (db, version) {
//         return db.execute(
//           '''
//           CREATE TABLE $tableName(
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             transactionName TEXT,
//             transactionDate TEXT,
//             amount REAL,
//             categoryName TEXT,
//             categoryImage TEXT
//           )
//           ''',
//         );
//       },
//       version: 19,
//     );
//   }
//
//   Future<void> insertTransaction(TransactionModel transaction) async {
//     final db = await database;
//     await db.insert(
//       tableName,
//       transaction.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }
//
//   Future getFinanceCategoryList() async {
//     final db = await database;
//     List<TransactionModel> results = (await db.rawQuery(
//             "select transactionName, categoryImage, categoryName, SUM(amount) AS amount, count(categoryName) as noOfTransactions from $tableName group by categoryName order by noOfTransactions desc"))
//         .map((e) => TransactionModel.fromJson(e))
//         .toList();
//     return results;
//   }
//
//   Future<void> deleteAllTransactions() async {
//     final db = await database;
//     await db.delete(tableName);
//   }
// }
