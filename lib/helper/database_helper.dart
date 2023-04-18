import 'package:path/path.dart';
import 'package:resto_app/data/model/favorite_resto.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static late Database _database;

  DatabaseHelper._internal() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._internal();

  Future<Database> get database async {
    _database = await _initializeDb();
    return _database;
  }

  static const String _tableName = 'FavoriteResto';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      join(path, 'favorite_resto_db.dab'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE $_tableName (id TEXT PRIMARY KEY, name TEXT, description TEXT, pictureId TEXT, city TEXT, rating INTEGER)',
        );
      },
      version: 1,
    );
    return db;
  }

  Future<void> insertFavoriteResto(FavoriteResto favoriteResto) async {
    final Database db = await database;
    await db.insert(_tableName, favoriteResto.toMap());
  }

  Future<List<FavoriteResto>> getFavoriteResto() async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(_tableName);
    return results.map((res) => FavoriteResto.fromMap(res)).toList();
  }

  Future<FavoriteResto> getFavoriteRestoById(String id) async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.map((res) => FavoriteResto.fromMap(res)).first;
  }

  Future<void> updateFavoriteResto(FavoriteResto favoriteResto) async {
    final Database db = await database;
    await db.update(
      _tableName,
      favoriteResto.toMap(),
      where: 'id = ?',
      whereArgs: [favoriteResto.id],
    );
  }

  Future<void> deleteFavoriteResto(String id) async {
    final Database db = await database;
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
