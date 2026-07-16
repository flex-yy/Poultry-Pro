import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultrypro/models/app_model.dart';

class FlockNotifier extends Notifier<List<Flock>> {
  @override
  List<Flock> build() {
    // This is our initial state: Some dummy data in RAM
    return [
      Flock(
        id: 1,
        name: 'Batch A - Layers',
        birdType: 'Layers',
        initialCount: 2500,
        currentCount: 2450,
        breed: 'Isa Brown',
        dateAdded: DateTime.now().subtract(
          const Duration(days: 224),
        ), // ~32 weeks ago
      ),
      Flock(
        id: 2,
        name: 'Batch C - Broilers',
        birdType: 'Broilers',
        initialCount: 1000,
        currentCount: 1000,
        breed: 'Cobb 500',
        dateAdded: DateTime.now().subtract(
          const Duration(days: 28),
        ), // 28 days ago
      ),
    ];
  }

  void addFlock(Flock newFlock) {
    // In Riverpod, state is immutable. We create a NEW list containing the old items + the new item.
    // Later, this is where we will insert into SQLite FIRST, then update the state with the DB result.
    state = [...state, newFlock];
  }
}

// This is what our UI will "listen" to.
final flockProvider = NotifierProvider<FlockNotifier, List<Flock>>(() {
  return FlockNotifier();
});
