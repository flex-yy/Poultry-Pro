import 'package:flutter/material.dart';
import 'package:poultrypro/core/theme/app_theme.dart';
import 'package:poultrypro/views/shared/bottom_sheets/custom_form_field.dart';
import 'package:poultrypro/views/shared/bottom_sheets/sheet_header.dart';

class LogHealthSheet extends StatefulWidget {
  const LogHealthSheet({super.key});

  @override
  State<LogHealthSheet> createState() => _LogHealthSheetState();
}

class _LogHealthSheetState extends State<LogHealthSheet> {
  bool isMortality = true; // Toggle between Mortality and Vaccination

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
          const SheetHeader(title: 'Log Health Event'),
          const SizedBox(height: 24),

          // Custom Segmented Control for Health Type
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
          const CustomFormField(
            label: 'Target Flock',
            hint: 'e.g. Bravo Broilers',
          ),
          const SizedBox(height: 16),

          // Conditionally render fields based on toggle
          if (isMortality) ...[
            const CustomFormField(
              label: 'Number of Birds Lost',
              hint: '0',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            const CustomFormField(
              label: 'Suspected Cause (Optional)',
              hint: 'e.g. Heat stress',
            ),
          ] else ...[
            const CustomFormField(
              label: 'Vaccine / Medication Name',
              hint: 'e.g. Newcastle (NDV)',
            ),
            const SizedBox(height: 16),
            const CustomFormField(
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
              onPressed: () => Navigator.pop(context),
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
