import 'package:marketdesktop/main.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbService {
  String dbName = "";
  static final DbService _instance = DbService._internal();
  factory DbService() => _instance;
  DbService._internal();
  static Database? _database;

  Future<Database?> get database async {
    return _database!;
  }

  Future<void> initDatabase() async {
    try {
      await closeDatabase();
      if (userData != null) {
        dbName = userData!.userId!;
        String path = join(await getDatabasesPath(), dbName);
        _database = await openDatabase(path, version: 1, onCreate: _createDb);
      }
    } catch (e) {
      print(e);
      return;
    }
  }

  void _createDb(Database db, int newVersion) async {
    try {
      for (int i = 1; i <= 5; i++) {
        await db.execute('''
        CREATE TABLE watchList$i (
          position INTEGER PRIMARY KEY,
          scriptId TEXT
        )
      ''');
      }
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      dbName = "";
      await _database!.close();
      _database = null;
    }
  }

  Future<void> addScript(String watchListNo, String scriptId, int position) async {
    try {
      Database? db = await database;
      await db!.insert(
        "watchList$watchListNo",
        {'position': position, 'scriptId': scriptId},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<List<Map<String, dynamic>>> readScripts(String watchListNo) async {
    try {
      Database? db = await database;
      return await db!.query("watchList$watchListNo");
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> updateScript(String watchListNo, String scriptId, int newPosition) async {
    try {
      Database? db = await database;
      await db!.update(
        "watchList$watchListNo",
        {'position': newPosition},
        where: 'scriptId = ?',
        whereArgs: [scriptId],
      );
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<void> removeScript(String watchListNo, String scriptId) async {
    try {
      Database? db = await database;
      await db!.delete(
        "watchList$watchListNo",
        where: 'scriptId = ?',
        whereArgs: [scriptId],
      );
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<void> bulkUpdate(String watchListNo, List<Map<String, dynamic>> updates) async {
    try {
      Database? db = await database;
      await db!.transaction((txn) async {
        await txn.delete("watchList$watchListNo");

        for (var update in updates) {
          await txn.insert(
            "watchList$watchListNo",
            {'position': update.keys.first, 'scriptId': update.values.first},
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });
    } catch (e) {
      print(e);
      return;
    }
  }
}
