import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultrypro/models/app_model.dart';
import 'package:poultrypro/models/database_helper.dart';

class HealthNotifier extends Notifier<List<HealthLog>> {
  final dbHelper = DatabaseHelper(); // Get SQLite instance

  @override
  List<HealthLog> build() {
    // 2. Load health logs from hard drive on startup
    _loadHealthLogs();

    // Return empty list while it loads
    return [];
  }

  // --- READ FROM SQLITE ---
  Future<void> _loadHealthLogs() async {
    final logsFromDb = await dbHelper.getHealthLogs();
    state = logsFromDb; // Update UI
  }

  // --- WRITE TO SQLITE ---
  Future<void> addHealthLog(HealthLog newLog) async {
    // 1. Save to SQLite and get the permanent ID
    final insertedId = await dbHelper.insertHealthLog(newLog);

    // 2. Attach the real ID to a copy of the log
    final logWithRealId = HealthLog(
      id: insertedId,
      flockId: newLog.flockId,
      isMortality: newLog.isMortality,
      birdsLost: newLog.birdsLost,
      details: newLog.details,
      date: newLog.date,
    );

    // 3. Update the UI state
    state = [logWithRealId, ...state];
  }
}

final healthProvider = NotifierProvider<HealthNotifier, List<HealthLog>>(() {
  return HealthNotifier();
});
