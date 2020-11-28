import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

class DBHelper {
  /// @database is a method that creates a database if it does not exist already
  /// or updgrades, downgrades it depending on the version number specified

  static Future<sql.Database> database() async {
    //get the db path
    final dbPath = await sql.getDatabasesPath();
    //opens the db
    return sql.openDatabase(path.join(dbPath, 'places.db'),
        //creates it if it does not exist already
        onCreate: (db, version) async {
      return await db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT)');
    }, version: 1);
  }

  /// @table is the name of the db table
  ///@data is the data to be inserted into the tabel, it's of type Map
  /// The insert function inserts @data into the @table of the db

  static Future<void> insert(String table, Map<String, Object> data) async {
    //call the database
    final db = await DBHelper.database();
    //inserts the data into the table, if conflicts, the new value overwrites
    // the old
    db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  /// getData queries the database to get info from it
  /// It returns a list of Map, since that is what the db holds

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    //get the db opened
    final db = await DBHelper.database();
    //It queries it
    return db.query(table);
  }
}
