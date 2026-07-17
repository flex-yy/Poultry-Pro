import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:poultrypro/core/theme/app_theme.dart';
import 'package:poultrypro/viewModels/Providers/finance_provider.dart';
import 'package:poultrypro/views/finances/widgets/filter_tab.dart';
import 'package:poultrypro/views/finances/widgets/finance_hero_card.dart';
import 'package:poultrypro/views/finances/widgets/transaction_item.dart';

class FinancesScreen extends ConsumerStatefulWidget {
  const FinancesScreen({super.key});

  @override
  ConsumerState<FinancesScreen> createState() => _FinancesScreenState();
}

class _FinancesScreenState extends ConsumerState<FinancesScreen> {
  int _activeFilterIndex = 1; // Default to 'Monthly'

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 1. WATCH all data
    final allTransactions = ref.watch(financeProvider);

    // 2. Filter data based on the selected tab
    final now = DateTime.now();
    final displayedTransactions = allTransactions.where((tx) {
      if (_activeFilterIndex == 0) {
        // Weekly: Within the last 7 days
        return now.difference(tx.date).inDays <= 7;
      } else if (_activeFilterIndex == 1) {
        // Monthly: Same month and year
        return tx.date.month == now.month && tx.date.year == now.year;
      } else {
        // Flock Cycle / All Time
        return true;
      }
    }).toList();

    // 3. Dynamic Math Calculations (using the FILTERED list!)
    double totalIncome = 0;
    double totalExpense = 0;

    for (var tx in displayedTransactions) {
      if (tx.isIncome) {
        totalIncome += tx.amount;
      } else {
        totalExpense += tx.amount;
      }
    }

    double netProfit = totalIncome - totalExpense;

    return SafeArea(
      child: Column(
        children: [
          // --- HEADER & FILTERS ---
          Padding(
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: 8,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Financials',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.surface,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: IconButton(
                        icon: const Icon(LucideIcons.download, size: 18),
                        color: AppColors.textSecondary,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Segmented Date Filter
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      FilterTab(
                        title: 'Weekly',
                        isActive: _activeFilterIndex == 0,
                        onTap: () => setState(() => _activeFilterIndex = 0),
                      ),
                      FilterTab(
                        title: 'Monthly',
                        isActive: _activeFilterIndex == 1,
                        onTap: () => setState(() => _activeFilterIndex = 1),
                      ),
                      FilterTab(
                        title: 'Flock Cycle',
                        isActive: _activeFilterIndex == 2,
                        onTap: () => setState(() => _activeFilterIndex = 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --- SCROLLABLE CONTENT ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 16,
                bottom: 100,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Hero Card - Pass the calculated profit!
                  FinanceHeroCard(netProfit: netProfit),
                  const SizedBox(height: 24),

                  // 2. Revenue vs Expenses Grid (Inlined for layout simplicity)
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : AppColors.lightBorder,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight.withValues(
                                    alpha: isDark ? 0.1 : 0.5,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  LucideIcons.arrowDownLeft,
                                  color: AppColors.primaryDark,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'TOTAL REVENUE',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textHint,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '₵${totalIncome.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : AppColors.lightBorder,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.error.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  LucideIcons.arrowUpRight,
                                  color: AppColors.error,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'TOTAL EXPENSES',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textHint,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '₵${totalExpense.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // 3. Transactions Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _activeFilterIndex == 0
                            ? 'This Week\'s Transactions'
                            : _activeFilterIndex == 1
                            ? 'This Month\'s Transactions'
                            : 'All Transactions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 4. Transactions List (Dynamically mapped to the FILTERED list!)
                  if (displayedTransactions.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text(
                          'No transactions in this period.',
                          style: TextStyle(color: AppColors.textHint),
                        ),
                      ),
                    )
                  else
                    ...displayedTransactions.map((tx) {
                      return TransactionItem(
                        title: tx.category,
                        subtitle:
                            '${tx.date.day}/${tx.date.month}/${tx.date.year}',
                        amount:
                            '${tx.isIncome ? '+' : '-'}₵${tx.amount.toStringAsFixed(2)}',
                        isIncome: tx.isIncome,
                        icon: tx.isIncome
                            ? LucideIcons.trendingUp
                            : LucideIcons.trendingDown,
                      );
                    }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
