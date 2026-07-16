import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultrypro/models/app_model.dart';
import 'package:poultrypro/viewModels/Providers/egg_provider.dart';
import 'package:poultrypro/views/shared/bottom_sheets/custom_form_field.dart';
import 'package:poultrypro/views/shared/bottom_sheets/sheet_header.dart';

class LogCollectionSheet extends ConsumerStatefulWidget {
  const LogCollectionSheet({super.key});

  @override
  ConsumerState<LogCollectionSheet> createState() => _LogCollectionSheetState();
}

class _LogCollectionSheetState extends ConsumerState<LogCollectionSheet> {
  final _flockController = TextEditingController();
  final _totalController = TextEditingController();
  final _badController = TextEditingController();

  @override
  dispose() {
    _flockController.dispose();
    _totalController.dispose();
    _badController.dispose();
    super.dispose();
  }

  void _saveLog() {
    if (_totalController.text.isEmpty) {
      return; // Optionally show an error message
    }

    final newLog = EggLog(
      id:
          DateTime.now().millisecondsSinceEpoch %
          10000, // Unique ID based on timestamp
      flockId: 1, // This should be dynamically set based on the selected flock
      totalEggs: int.tryParse(_totalController.text) ?? 0,
      badEggs: int.tryParse(_badController.text) ?? 0,
      date: DateTime.now(),
    );

    ref.read(eggProvider.notifier).addEggLog(newLog);

    Navigator.pop(context); // Close the bottom sheet after saving
  }

  @override
  Widget build(BuildContext context) {
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
        mainAxisSize: MainAxisSize.min, // Wrap content tightly
        children: [
          const SheetHeader(title: 'Log Collection'),
          const SizedBox(height: 24),
          CustomFormField(
            controller: _flockController,
            label: 'Target Flock',
            hint: 'Alpha Layers',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomFormField(
                  controller: _totalController,
                  label: 'Total Eggs',
                  hint: '0',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomFormField(
                  controller: _badController,
                  label: 'Cracked/Bad',
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
                backgroundColor: const Color(
                  0xFFFFE492,
                ), // The yellow from the mockup
                foregroundColor: const Color(
                  0xFF9E7C3E,
                ), // Darker brownish text
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
