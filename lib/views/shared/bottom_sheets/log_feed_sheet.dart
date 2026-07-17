import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultrypro/core/theme/app_theme.dart';
import 'package:poultrypro/models/app_model.dart';
import 'package:poultrypro/viewModels/Providers/feed_provider.dart';
import 'package:poultrypro/viewModels/Providers/flock_provider.dart';
import 'package:poultrypro/views/shared/bottom_sheets/custom_dropdown_field.dart';
import 'package:poultrypro/views/shared/bottom_sheets/custom_form_field.dart';
import 'package:poultrypro/views/shared/bottom_sheets/sheet_header.dart';

class LogFeedSheet extends ConsumerStatefulWidget {
  const LogFeedSheet({super.key});

  @override
  ConsumerState<LogFeedSheet> createState() => _LogFeedSheetState();
}

class _LogFeedSheetState extends ConsumerState<LogFeedSheet> {
  int? _selectedFlockId; // State for dropdown

  final _qtyController = TextEditingController();
  final _typeController = TextEditingController();

  @override
  void dispose() {
    _qtyController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  void _saveLog() {
    if (_selectedFlockId == null || _qtyController.text.isEmpty) return;

    final newLog = FeedLog(
      id: DateTime.now().millisecondsSinceEpoch % 10000,
      flockId: _selectedFlockId!, // Use real ID!
      quantityKg: double.tryParse(_qtyController.text) ?? 0.0,
      feedType: _typeController.text.isNotEmpty
          ? _typeController.text
          : 'General Feed',
      date: DateTime.now(),
    );

    ref.read(feedProvider.notifier).addFeedLog(newLog);

    // Add the Success Snackbar!
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(width: 12),
            Text(
              'Feed usage logged successfully!',
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
    final flocks = ref.watch(flockProvider); // Get the flocks

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
          const SheetHeader(title: 'Log Feed Usage'),
          const SizedBox(height: 24),

          CustomDropdownField<int>(
            label: 'Target Flock / Batch',
            hint: flocks.isEmpty ? 'No flocks available' : 'Select a flock',
            value: _selectedFlockId,
            items: flocks.map((flock) {
              return DropdownMenuItem<int>(
                value: flock.id!,
                child: Text(flock.name),
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
                  controller: _qtyController,
                  label: 'Quantity (kg)',
                  hint: 'e.g. 50',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomFormField(
                  controller: _typeController,
                  label: 'Feed Type',
                  hint: 'e.g. Layer Mash',
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
                backgroundColor: Colors.amber.shade600,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: _saveLog,
              child: const Text(
                'Save Feed Log',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
