import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultrypro/models/app_model.dart';

class FinanceNotifier extends Notifier<List<AppTransaction>> {
  @override
  List<AppTransaction> build() {
    // This is our initial state: Dummy transactions
    return [
      AppTransaction(
        id: 1,
        isIncome: true,
        amount: 1200.0,
        category: 'Egg Sales (Wholesale)',
        date: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      AppTransaction(
        id: 2,
        isIncome: false,
        amount: 4500.0,
        category: 'Feed Purchase (Layer Mash)',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  void addTransaction(AppTransaction transaction) {
    // We spread the NEW transaction first, so it appears at the top of the list!
    state = [transaction, ...state];
  }
}

final financeProvider = NotifierProvider<FinanceNotifier, List<AppTransaction>>(
  () {
    return FinanceNotifier();
  },
);
