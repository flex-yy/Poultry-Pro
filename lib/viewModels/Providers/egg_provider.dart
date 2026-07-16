import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultrypro/models/app_model.dart';

class EggNotifier extends Notifier<List<EggLog>> {
  @override
  List<EggLog> build() {
    final today = DateTime.now();
    return [
      EggLog(
        id: 1,
        flockId: 1, // Linking to Batch A
        totalEggs: 460,
        badEggs: 12,
        date: today, // Logged today
      ),
      EggLog(
        id: 2,
        flockId: 1,
        totalEggs: 455,
        badEggs: 8,
        date: today.subtract(const Duration(days: 1)), // Logged yesterday
      ),
    ];
  }

  void addEggLog(EggLog newLog) {
    state = [newLog, ...state];
  }
}

final eggProvider = NotifierProvider<EggNotifier, List<EggLog>>(() {
  return EggNotifier();
});
