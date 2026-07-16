import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultrypro/core/theme/app_theme.dart';
import 'package:poultrypro/models/app_model.dart';
import 'package:poultrypro/viewModels/Providers/flock_provider.dart';
import 'package:poultrypro/views/shared/bottom_sheets/custom_form_field.dart';
import 'package:poultrypro/views/shared/bottom_sheets/sheet_header.dart';

class RegisterFlockSheet extends ConsumerStatefulWidget {
  const RegisterFlockSheet({super.key});

  @override
  ConsumerState<RegisterFlockSheet> createState() => _RegisterFlockSheetState();
}

class _RegisterFlockSheetState extends ConsumerState<RegisterFlockSheet> {
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _countController = TextEditingController();
  final _breedController = TextEditingController();

  @override
  dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _countController.dispose();
    _breedController.dispose();
    super.dispose();
  }

  void _saveFlock() {
    // 1. Validate simple inputs (make sure name and count aren't empty)
    if (_nameController.text.isEmpty || _countController.text.isEmpty) return;

    // 2. Create the model
    final newFlock = Flock(
      id:
          DateTime.now().millisecondsSinceEpoch %
          10000, // Temporary random ID until we add SQLite
      name: _nameController.text,
      birdType: _typeController.text.isNotEmpty
          ? _typeController.text
          : 'Layers',
      initialCount: int.tryParse(_countController.text) ?? 0,
      currentCount: int.tryParse(_countController.text) ?? 0,
      breed: _breedController.text,
      dateAdded: DateTime.now(),
    );

    // 3. Send it to Riverpod Provider!
    ref.read(flockProvider.notifier).addFlock(newFlock);

    // 4. Close the sheet
    Navigator.pop(context);
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
        mainAxisSize: MainAxisSize.min,
        children: [
          const SheetHeader(title: 'Register Flock'),
          const SizedBox(height: 24),
          CustomFormField(
            controller: _nameController,
            label: 'Flock / Batch Name',
            hint: 'e.g. Delta Batch',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomFormField(
                  controller: _typeController,
                  label: 'Bird Type',
                  hint: 'Layers',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomFormField(
                  controller: _countController,
                  label: 'Initial Count',
                  hint: '500',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomFormField(
            controller: _breedController,
            label: 'Breed (Optional)',
            hint: 'e.g. Lohmann Brown',
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
              onPressed: _saveFlock,
              child: const Text(
                'Create Flock',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
