import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultrypro/core/theme/app_theme.dart';
import 'package:poultrypro/models/app_model.dart';
import 'package:poultrypro/viewModels/Providers/egg_provider.dart';
import 'package:poultrypro/viewModels/Providers/flock_provider.dart';
import 'package:poultrypro/views/shared/bottom_sheets/custom_dropdown_field.dart';
import 'package:poultrypro/views/shared/bottom_sheets/custom_form_field.dart';
import 'package:poultrypro/views/shared/bottom_sheets/sheet_header.dart';

class LogCollectionSheet extends ConsumerStatefulWidget {
  const LogCollectionSheet({super.key});

  @override
  ConsumerState<LogCollectionSheet> createState() => _LogCollectionSheetState();
}

class _LogCollectionSheetState extends ConsumerState<LogCollectionSheet> {
  int? _selectedFlockId; // 2. State for the dropdown selection

  final _totalController = TextEditingController();
  final _badController = TextEditingController();

  @override
  void dispose() {
    _totalController.dispose();
    _badController.dispose();
    super.dispose();
  }

  void _saveLog() {
    // Prevent saving if no flock is selected or total is empty
    if (_selectedFlockId == null || _totalController.text.isEmpty) return;

    final newLog = EggLog(
      id: DateTime.now().millisecondsSinceEpoch % 10000,
      flockId: _selectedFlockId!, // Use the selected real ID
      totalEggs: int.tryParse(_totalController.text) ?? 0,
      badEggs: int.tryParse(_badController.text) ?? 0,
      date: DateTime.now(),
    );

    ref.read(eggProvider.notifier).addEggLog(newLog);

    // Add the Success Snackbar!
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(width: 12),
            Text(
              'Egg collection logged successfully!',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // 3. Watch the flock provider to get the real list of flocks!
    final flocks = ref.watch(flockProvider);

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
          const SheetHeader(title: 'Log Collection'),
          const SizedBox(height: 24),

          // 4. The Dropdown Field
          CustomDropdownField<int>(
            label: 'Target Flock',
            hint: flocks.isEmpty ? 'No flocks available' : 'Select a flock',
            value: _selectedFlockId,
            items: flocks.map((flock) {
              return DropdownMenuItem<int>(
                value:
                    flock.id!, // The ! ensures it reads as a non-null ID safely
                child: Text(flock.name), // Show the flock name to the user
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedFlockId = value;
              });
            },
          ),

          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomFormField(
                  controller: _totalController,
                  label: 'Total Collected',
                  hint: '0',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomFormField(
                  controller: _badController,
                  label: 'Cracked / Bad',
                  hint: '0',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: _saveLog,
              child: const Text(
                'Save Collection Log',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
