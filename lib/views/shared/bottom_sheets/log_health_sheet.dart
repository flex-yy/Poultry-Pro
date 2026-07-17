import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultrypro/core/theme/app_theme.dart';
import 'package:poultrypro/models/app_model.dart';
import 'package:poultrypro/viewModels/Providers/flock_provider.dart';
import 'package:poultrypro/viewModels/Providers/health_provider.dart';
import 'package:poultrypro/views/shared/bottom_sheets/custom_dropdown_field.dart';
import 'package:poultrypro/views/shared/bottom_sheets/custom_form_field.dart';
import 'package:poultrypro/views/shared/bottom_sheets/sheet_header.dart';

class LogHealthSheet extends ConsumerStatefulWidget {
  const LogHealthSheet({super.key});

  @override
  ConsumerState<LogHealthSheet> createState() => _LogHealthSheetState();
}

class _LogHealthSheetState extends ConsumerState<LogHealthSheet> {
  bool isMortality = true; // Toggle between Mortality and Vaccination
  int? _selectedFlockId; // Dropdown state

  // Controllers for Mortality
  final _deadbirdsController = TextEditingController();
  final _causeController = TextEditingController();

  // Controllers for Vaccination
  final _vaccineNameController = TextEditingController();
  final _adminMethodController = TextEditingController();

  @override
  void dispose() {
    _deadbirdsController.dispose();
    _causeController.dispose();
    _vaccineNameController.dispose();
    _adminMethodController.dispose();
    super.dispose();
  }

  void _saveLog() {
    if (_selectedFlockId == null) return; // Prevent saving if no flock chosen

    final int lostCount = isMortality
        ? (int.tryParse(_deadbirdsController.text) ?? 0)
        : 0;

    final newLog = HealthLog(
      id: DateTime.now().millisecondsSinceEpoch % 10000,
      flockId: 1, // Hardcoded for now
      isMortality: isMortality,
      birdsLost: isMortality
          ? (int.tryParse(_deadbirdsController.text) ?? 0)
          : null,
      details: isMortality
          ? _causeController.text
          : '${_vaccineNameController.text} (${_adminMethodController.text})',
      date: DateTime.now(),
    );

    ref.read(healthProvider.notifier).addHealthLog(newLog);

    if (isMortality && lostCount > 0) {
      ref
          .read(flockProvider.notifier)
          .recordMortality(1, lostCount); // Hardcoded flockId 1 for now
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final flocks = ref.watch(flockProvider); // Get the flocks!

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
          const SheetHeader(title: 'Log Health Event'),
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
                    onTap: () => setState(() => isMortality = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isMortality
                            ? (isDark ? AppColors.error : Colors.white)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: isMortality && !isDark
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
                          'MORTALITY',
                          style: TextStyle(
                            color: isMortality
                                ? (isDark ? Colors.white : AppColors.error)
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
                    onTap: () => setState(() => isMortality = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !isMortality
                            ? (isDark ? Colors.purple.shade600 : Colors.white)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: !isMortality && !isDark
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
                          'VACCINATION',
                          style: TextStyle(
                            color: !isMortality
                                ? (isDark
                                      ? Colors.white
                                      : Colors.purple.shade600)
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
          CustomDropdownField<int>(
            label: 'Target Flock',
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

          // Conditionally render fields based on toggle
          if (isMortality) ...[
            CustomFormField(
              controller: _deadbirdsController,
              label: 'Number of Birds Lost',
              hint: '0',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            CustomFormField(
              controller: _causeController,
              label: 'Suspected Cause (Optional)',
              hint: 'e.g. Heat stress',
            ),
          ] else ...[
            CustomFormField(
              controller: _vaccineNameController,
              label: 'Vaccine / Medication Name',
              hint: 'e.g. Newcastle (NDV)',
            ),
            const SizedBox(height: 16),
            CustomFormField(
              controller: _adminMethodController,
              label: 'Administration Method',
              hint: 'e.g. Drinking Water',
            ),
          ],

          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isMortality
                    ? AppColors.error
                    : Colors.purple.shade600,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: _saveLog,
              child: Text(
                isMortality ? 'Log Mortality' : 'Log Vaccination',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
