import 'package:flutter/material.dart';
import 'package:poultrypro/core/theme/app_theme.dart';
import 'package:poultrypro/models/app_model.dart';
import 'package:poultrypro/viewModels/Providers/finance_provider.dart';
import 'package:poultrypro/views/shared/bottom_sheets/custom_form_field.dart';
import 'package:poultrypro/views/shared/bottom_sheets/sheet_header.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewTransactionSheet extends ConsumerStatefulWidget {
  const NewTransactionSheet({super.key});

  @override
  ConsumerState<NewTransactionSheet> createState() =>
      _NewTransactionSheetState();
}

class _NewTransactionSheetState extends ConsumerState<NewTransactionSheet> {
  bool isIncome = true; // Tracks the toggle state
  final _amountController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _saveTransaction() {
    if (_amountController.text.isEmpty || _descController.text.isEmpty) return;

    final newTx = AppTransaction(
      id: DateTime.now().millisecondsSinceEpoch % 10000,
      isIncome: isIncome,
      amount: double.tryParse(_amountController.text) ?? 0.0,
      category: _descController.text,
      date: DateTime.now(),
    );

    // Tell the provider to add it!
    ref.read(financeProvider.notifier).addTransaction(newTx);

    // Close the sheet
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 24,
        right: 24,
        top: 24,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SheetHeader(title: 'New Transaction'),
          const SizedBox(height: 24),

          // Custom Segmented Control
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? AppColors.background : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isIncome = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isIncome
                            ? (isDark ? AppColors.primaryDark : Colors.white)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: isIncome && !isDark
                            ? [
                                const BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      child: Center(
                        child: Text(
                          'INCOME',
                          style: TextStyle(
                            color: isIncome
                                ? (isDark
                                      ? Colors.white
                                      : AppColors.primaryDark)
                                : AppColors.textHint,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isIncome = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !isIncome
                            ? (isDark ? AppColors.primaryDark : Colors.white)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: !isIncome && !isDark
                            ? [
                                const BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      child: Center(
                        child: Text(
                          'EXPENSE',
                          style: TextStyle(
                            color: !isIncome
                                ? (isDark
                                      ? Colors.white
                                      : AppColors.primaryDark)
                                : AppColors.textHint,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          CustomFormField(
            controller: _amountController,
            label: 'Amount (GHS)',
            hint: '0.00',
            keyboardType: TextInputType.number,
            prefixIcon: Icon(
              Icons.money,
              color: AppColors.textHint,
              size: 20,
            ), // Placeholder for Cedis icon
          ),
          const SizedBox(height: 16),
          CustomFormField(
            controller: _descController,
            label: 'Description / Category',
            hint: 'e.g. 5 bags of feed',
          ),
          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1CB581), // Mockup green
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: _saveTransaction,
              child: const Text(
                'Record Transaction',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
