import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String _tableName = 'dd_demo_table';
  String _colId = 'id';
  String _colVal = 'value';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'dd_demo.db';
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
      onOpen: (db) => print('Database is being opened!'),
    );
  }

  void _createDb(Database db, int version) async {
    print('Database is being created');
    await db.execute(
        'CREATE TABLE $_tableName($_colId INTEGER PRIMARY KEY AUTOINCREMENT, $_colVal INTEGER)');
  }

  //Returns a list of map;
  Future<List<Map<String, dynamic>>> getAllValues() async {
    Database database = await this.database;
    var result = await database.query(_tableName);
    return result;
  }

  Future<int> insertData(int val) async {
    Database database = await this.database;
    var result = await database.insert(_tableName, {'value': val});
    return result;
  }

  Future<int> updateData(int val) async {
    Database database = await this.database;
    var result = await database.update(
      _tableName,
      {'value': val},
      where: '$_colId = ?',
      whereArgs: [1],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  Future<int> deleteData() async {
    Database database = await this.database;
    var result = await database.delete(
      _tableName,
      where: '$_tableName = ?',
      whereArgs: [1],
    );
    return result;
  }

  Future<int> getCount() async {
    Database database = await this.database;
    var result = await database.rawQuery('SELECT COUNT (*) FROM $_tableName');
    return Sqflite.firstIntValue(result);
  }

  Future<void> dropTable() async {
    print('Table is being deleted');
    Database database = await this.database;
    database.rawQuery('DROP TABLE $_tableName');
  }
}
