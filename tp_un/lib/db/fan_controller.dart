import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tp_un/db/seed.dart';
import 'fan.dart';

class FanController {
  static final FanController instance = FanController._init();
  static Database? _database;

  FanController._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('fans.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE fans (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        audioPaths TEXT NOT NULL,
        isCustom INTEGER NOT NULL
      )
    ''');

    await Seed.insert(db);
  }

  Future<void> resetDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'fans.db');
    await deleteDatabase(path);
  }

  Future<List<Fan>> getFans() async {
    final db = await database;
    final result = await db.query('fans');
    return result.map((e) => Fan.fromMap(e)).toList();
  }

  Future<int> addFan(Fan fan) async {
    final db = await database;
    return await db.insert('fans', fan.toMap());
  }

  Future<void> deleteFan(int id) async {
    final db = await database;
    await db.delete('fans', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateFanName(int id, String name) async {
    final db = await database;
    await db.update('fans', {'name': name}, where: 'id = ?', whereArgs: [id]);
  }
}
