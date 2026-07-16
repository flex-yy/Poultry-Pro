import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultrypro/models/app_model.dart';
import 'package:poultrypro/views/shared/bottom_sheets/custom_form_field.dart';
import 'package:poultrypro/views/shared/bottom_sheets/feed_provider.dart';
import 'package:poultrypro/views/shared/bottom_sheets/sheet_header.dart';

class LogFeedSheet extends ConsumerStatefulWidget {
  const LogFeedSheet({super.key});

  @override
  ConsumerState<LogFeedSheet> createState() => _LogFeedSheetState();
}

class _LogFeedSheetState extends ConsumerState<LogFeedSheet> {
  final _qtyController = TextEditingController();
  final _typeController = TextEditingController();

  @override
  void dispose() {
    _qtyController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  void _saveLog() {
    if (_qtyController.text.isEmpty) return;

    final newLog = FeedLog(
      id: DateTime.now().millisecondsSinceEpoch % 10000,
      flockId: 1, // Hardcoded for now
      quantityKg: double.tryParse(_qtyController.text) ?? 0.0,
      feedType: _typeController.text.isNotEmpty
          ? _typeController.text
          : 'General Feed',
      date: DateTime.now(),
    );

    ref.read(feedProvider.notifier).addFeedLog(newLog);
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
          const SheetHeader(title: 'Log Feed Usage'),
          const SizedBox(height: 24),
          const CustomFormField(
            label: 'Target Flock / Batch',
            hint: 'e.g. Alpha Layers',
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
