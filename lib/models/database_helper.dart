import 'package:path/path.dart';
import 'package:poultrypro/models/app_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Get the device's default database directory path
    String path = join(await getDatabasesPath(), 'poultry_pro.db');

    // Open the database, creating it if it doesn't exist
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // FLOCKS TABLE
    await db.execute('''
      CREATE TABLE flocks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        birdType TEXT,
        initialCount INTEGER,
        currentCount INTEGER,
        breed TEXT,
        dateAdded TEXT
      )
    ''');

    // EGG LOGS TABLE
    await db.execute('''
      CREATE TABLE egg_logs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        flockId INTEGER,
        totalEggs INTEGER,
        badEggs INTEGER,
        date TEXT
      )
    ''');

    // FEED LOGS TABLE
    await db.execute('''
      CREATE TABLE feed_logs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        flockId INTEGER,
        quantityKg REAL,
        feedType TEXT,
        date TEXT
      )
    ''');

    // HEALTH LOGS TABLE
    await db.execute('''
      CREATE TABLE health_logs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        flockId INTEGER,
        isMortality INTEGER,
        birdsLost INTEGER,
        details TEXT,
        date TEXT
      )
    ''');

    // TRANSACTIONS TABLE
    await db.execute('''
      CREATE TABLE transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        isIncome INTEGER,
        amount REAL,
        category TEXT,
        date TEXT
      )
    ''');
  }

  // --- FLOCKS ---
  Future<int> insertFlock(Flock flock) async {
    final db = await database;
    // We remove the ID before inserting so SQLite can auto-generate one
    final map = flock.toMap();
    map.remove('id');
    return await db.insert('flocks', map);
  }

  Future<List<Flock>> getFlocks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'flocks',
      orderBy: 'id DESC',
    );
    return List.generate(maps.length, (i) => Flock.fromMap(maps[i]));
  }

  Future<int> updateFlock(Flock flock) async {
    final db = await database;
    return await db.update(
      'flocks',
      flock.toMap(),
      where: 'id = ?',
      whereArgs: [flock.id],
    );
  }

  // --- TRANSACTIONS ---
  Future<int> insertTransaction(AppTransaction tx) async {
    final db = await database;
    final map = tx.toMap();
    map.remove('id');
    return await db.insert('transactions', map);
  }

  Future<List<AppTransaction>> getTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      orderBy: 'id DESC',
    );
    return List.generate(maps.length, (i) => AppTransaction.fromMap(maps[i]));
  }

  // --- EGGS ---
  Future<int> insertEggLog(EggLog log) async {
    final db = await database;
    final map = log.toMap();
    map.remove('id');
    return await db.insert('egg_logs', map);
  }

  Future<List<EggLog>> getEggLogs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'egg_logs',
      orderBy: 'id DESC',
    );
    return List.generate(maps.length, (i) => EggLog.fromMap(maps[i]));
  }

  // --- HEALTH ---
  Future<int> insertHealthLog(HealthLog log) async {
    final db = await database;
    final map = log.toMap();
    map.remove('id');
    return await db.insert('health_logs', map);
  }

  Future<List<HealthLog>> getHealthLogs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'health_logs',
      orderBy: 'id DESC',
    );
    return List.generate(maps.length, (i) => HealthLog.fromMap(maps[i]));
  }

  // --- FEED ---
  Future<int> insertFeedLog(FeedLog log) async {
    final db = await database;
    final map = log.toMap();
    map.remove('id');
    return await db.insert('feed_logs', map);
  }

  Future<List<FeedLog>> getFeedLogs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'feed_logs',
      orderBy: 'id DESC',
    );
    return List.generate(maps.length, (i) => FeedLog.fromMap(maps[i]));
  }
}
