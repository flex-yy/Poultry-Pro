import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultrypro/models/app_model.dart';
import 'package:poultrypro/models/database_helper.dart';

class FeedNotifier extends Notifier<List<FeedLog>> {
  final dbHelper = DatabaseHelper(); // Get SQLite instance

  @override
  List<FeedLog> build() {
    // 2. Load feed logs from hard drive on startup
    _loadFeedLogs();

    // Return empty list while it loads
    return [];
  }

  // --- READ FROM SQLITE ---
  Future<void> _loadFeedLogs() async {
    final logsFromDb = await dbHelper.getFeedLogs();
    state = logsFromDb; // Update UI
  }

  // --- WRITE TO SQLITE ---
  Future<void> addFeedLog(FeedLog newLog) async {
    // 1. Save to SQLite and get the permanent ID
    final insertedId = await dbHelper.insertFeedLog(newLog);

    // 2. Attach the real ID to a copy of the log
    final logWithRealId = FeedLog(
      id: insertedId,
      flockId: newLog.flockId,
      quantityKg: newLog.quantityKg,
      feedType: newLog.feedType,
      date: newLog.date,
    );

    // 3. Update the UI state
    state = [logWithRealId, ...state];
  }
}

final feedProvider = NotifierProvider<FeedNotifier, List<FeedLog>>(() {
  return FeedNotifier();
});
