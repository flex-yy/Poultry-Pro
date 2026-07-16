import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultrypro/models/app_model.dart';

class HealthNotifier extends Notifier<List<HealthLog>> {
  @override
  List<HealthLog> build() {
    // Dummy initial state
    return [
      HealthLog(
        id: 1,
        flockId: 1,
        isMortality: true,
        birdsLost: 2,
        details: 'Suspected heat stress',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      HealthLog(
        id: 2,
        flockId: 2,
        isMortality: false,
        details: 'Newcastle (NDV) Vaccine via water',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  void addHealthLog(HealthLog newLog) {
    state = [newLog, ...state]; // Add to top of list
  }
}

final healthProvider = NotifierProvider<HealthNotifier, List<HealthLog>>(() {
  return HealthNotifier();
});
