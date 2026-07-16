import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poultrypro/models/app_model.dart';
import 'package:poultrypro/models/database_helper.dart';

class FlockNotifier extends Notifier<List<Flock>> {
  // Create an instance of our database helper
  final dbHelper = DatabaseHelper();

  @override
  List<Flock> build() {
    // 2. The moment this provider starts, tell it to load data from the hard drive
    _loadFlocks();

    // Return an empty list temporarily while the database loads (it takes milliseconds)
    return [];
  }

  // --- READ FROM SQLITE ---
  Future<void> _loadFlocks() async {
    final flocksFromDb = await dbHelper.getFlocks();
    state = flocksFromDb; // Update the UI with the saved flocks!
  }

  // --- WRITE TO SQLITE ---
  Future<void> addFlock(Flock newFlock) async {
    // 1. Insert into SQLite. The database returns the newly generated permanent ID.
    final insertedId = await dbHelper.insertFlock(newFlock);

    // 2. Create a copy of the flock, but this time attach the REAL ID from the database
    final flockWithRealId = Flock(
      id: insertedId, // The permanent SQLite ID!
      name: newFlock.name,
      birdType: newFlock.birdType,
      initialCount: newFlock.initialCount,
      currentCount: newFlock.currentCount,
      breed: newFlock.breed,
      dateAdded: newFlock.dateAdded,
    );

    // 3. Update the UI state to show the new flock at the top of the list
    state = [flockWithRealId, ...state];
  }

  // --- UPDATE SQLITE (Mortality) ---
  Future<void> recordMortality(int flockId, int birdsLost) async {
    // 1. Find the target flock in our current state
    final targetFlock = state.firstWhere((f) => f.id == flockId);

    // 2. Create the updated flock object with the lower bird count
    final updatedFlock = Flock(
      id: targetFlock.id,
      name: targetFlock.name,
      birdType: targetFlock.birdType,
      initialCount: targetFlock.initialCount,
      currentCount: targetFlock.currentCount - birdsLost,
      breed: targetFlock.breed,
      dateAdded: targetFlock.dateAdded,
    );

    // 3. Save the update permanently to SQLite
    await dbHelper.updateFlock(updatedFlock);

    // 4. Update the UI state
    state = state.map((flock) {
      if (flock.id == flockId) {
        return updatedFlock;
      }
      return flock;
    }).toList();
  }
}

final flockProvider = NotifierProvider<FlockNotifier, List<Flock>>(() {
  return FlockNotifier();
});
