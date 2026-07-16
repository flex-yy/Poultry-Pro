import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultrypro/models/app_model.dart';

class FeedNotifier extends Notifier<List<FeedLog>> {
  @override
  List<FeedLog> build() {
    // Dummy initial state
    return [
      FeedLog(
        id: 1,
        flockId: 1, // Batch A
        quantityKg: 50.0,
        feedType: 'Layer Mash',
        date: DateTime.now().subtract(const Duration(hours: 4)),
      ),
    ];
  }

  void addFeedLog(FeedLog newLog) {
    state = [newLog, ...state]; // Add to top of list
  }
}

final feedProvider = NotifierProvider<FeedNotifier, List<FeedLog>>(() {
  return FeedNotifier();
});
