import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultrypro/models/app_model.dart';
import 'package:poultrypro/models/database_helper.dart';

class FinanceNotifier extends Notifier<List<AppTransaction>> {
  final dbHelper = DatabaseHelper(); // Get our SQLite instance

  @override
  List<AppTransaction> build() {
    // 2. Load transactions from the hard drive when the app starts
    _loadTransactions();

    // Return empty temporarily while it loads
    return [];
  }

  // --- READ FROM SQLITE ---
  Future<void> _loadTransactions() async {
    final transactionsFromDb = await dbHelper.getTransactions();
    state = transactionsFromDb; // Update UI with saved data
  }

  // --- WRITE TO SQLITE ---
  Future<void> addTransaction(AppTransaction newTx) async {
    // 1. Insert into SQLite. It returns the newly generated permanent ID.
    final insertedId = await dbHelper.insertTransaction(newTx);

    // 2. Create a copy of the transaction, attaching the REAL ID
    final txWithRealId = AppTransaction(
      id: insertedId,
      isIncome: newTx.isIncome,
      amount: newTx.amount,
      category: newTx.category,
      date: newTx.date,
    );

    // 3. Update the UI state to show the new transaction at the top
    state = [txWithRealId, ...state];
  }
}

final financeProvider = NotifierProvider<FinanceNotifier, List<AppTransaction>>(
  () {
    return FinanceNotifier();
  },
);
