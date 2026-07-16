class Flock {
  final int? id;
  final String name;
  final String birdType;
  final int initialCount;
  final int currentCount;
  final String? breed;
  final DateTime dateAdded;

  Flock({
    this.id,
    required this.name,
    required this.birdType,
    required this.initialCount,
    required this.currentCount,
    this.breed,
    required this.dateAdded,
  });

  // Convert a Flock object into a Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'birdType': birdType,
      'initialCount': initialCount,
      'currentCount': currentCount,
      'breed': breed,
      'dateAdded': dateAdded.toIso8601String(), // Convert DateTime to String
    };
  }

  // Create a Flock object from a SQLite Map
  factory Flock.fromMap(Map<String, dynamic> map) {
    return Flock(
      id: map['id'],
      name: map['name'],
      birdType: map['birdType'],
      initialCount: map['initialCount'],
      currentCount: map['currentCount'],
      breed: map['breed'],
      dateAdded: DateTime.parse(
        map['dateAdded'],
      ), // Convert String back to DateTime
    );
  }
}

class EggLog {
  final int? id;
  final int flockId; // Foreign key linking to the Flock
  final int totalEggs;
  final int badEggs;
  final DateTime date;

  EggLog({
    this.id,
    required this.flockId,
    required this.totalEggs,
    required this.badEggs,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'flockId': flockId,
      'totalEggs': totalEggs,
      'badEggs': badEggs,
      'date': date.toIso8601String(),
    };
  }

  factory EggLog.fromMap(Map<String, dynamic> map) {
    return EggLog(
      id: map['id'],
      flockId: map['flockId'],
      totalEggs: map['totalEggs'],
      badEggs: map['badEggs'],
      date: DateTime.parse(map['date']),
    );
  }
}

class FeedLog {
  final int? id;
  final int flockId;
  final double quantityKg;
  final String feedType;
  final DateTime date;

  FeedLog({
    this.id,
    required this.flockId,
    required this.quantityKg,
    required this.feedType,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'flockId': flockId,
      'quantityKg': quantityKg,
      'feedType': feedType,
      'date': date.toIso8601String(),
    };
  }

  factory FeedLog.fromMap(Map<String, dynamic> map) {
    return FeedLog(
      id: map['id'],
      flockId: map['flockId'],
      quantityKg: map['quantityKg'],
      feedType: map['feedType'],
      date: DateTime.parse(map['date']),
    );
  }
}

class HealthLog {
  final int? id;
  final int flockId;
  final bool isMortality; // true for mortality, false for vaccination
  final int? birdsLost; // Only used if isMortality is true
  final String details; // Cause of death OR Vaccine name
  final DateTime date;

  HealthLog({
    this.id,
    required this.flockId,
    required this.isMortality,
    this.birdsLost,
    required this.details,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'flockId': flockId,
      'isMortality': isMortality
          ? 1
          : 0, // SQLite doesn't have booleans, so we use 1 and 0
      'birdsLost': birdsLost,
      'details': details,
      'date': date.toIso8601String(),
    };
  }

  factory HealthLog.fromMap(Map<String, dynamic> map) {
    return HealthLog(
      id: map['id'],
      flockId: map['flockId'],
      isMortality:
          map['isMortality'] == 1, // Convert 1 back to true, 0 to false
      birdsLost: map['birdsLost'],
      details: map['details'],
      date: DateTime.parse(map['date']),
    );
  }
}

class AppTransaction {
  // Named AppTransaction so it doesn't conflict with any built-in Flutter classes
  final int? id;
  final bool isIncome;
  final double amount;
  final String category; // e.g. "Feed Purchase", "Egg Sales"
  final DateTime date;

  AppTransaction({
    this.id,
    required this.isIncome,
    required this.amount,
    required this.category,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isIncome': isIncome ? 1 : 0,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
    };
  }

  factory AppTransaction.fromMap(Map<String, dynamic> map) {
    return AppTransaction(
      id: map['id'],
      isIncome: map['isIncome'] == 1,
      amount: map['amount'],
      category: map['category'],
      date: DateTime.parse(map['date']),
    );
  }
}
