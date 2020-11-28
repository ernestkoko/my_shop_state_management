import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

/// A class that helps to manage sqlite database

class DBHelper {
  static Future<sql.Database> database() async {
    //get the path to sqlite db
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'meter_reading.db'),
        onCreate: (db, version) async {
      return await db.execute(
          "CREATE TABLE meter_reading(id TEXT PRIMARY KEY, account_number TEXT," +
              " par TEXT, comment TEXT, customer_mobile TEXT, marketer_name TEXT)");
    }, version: 1);
  }

  ///inserts into the db
  ///[table] that table name to insert into
  ///[data] tha data to be inserted
  static Future<void> insert(String table, Map<String, Object> data) async {
    //get the d. await it because it returns a future
    final db = await DBHelper.database();
    //insert the data and when a value already exists, replace the old with new one
    db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  ///get the data from the table by querying it
  static Future<List<Map<String, dynamic>>> getFromDb(String table) async {
    //get the db
    final db = await DBHelper.database();
    //query the table
    return await db.query(table);
  }

  //delete from the db
  static Future<int> deleteFromDB(String table, String id) async {
    final db = await DBHelper.database();
    int rowsAffected= await db.rawDelete("DELETE FROM $table WHERE account_number = ?", [id]);
    // await db.delete(table, where: "id = ?",whereArgs: [id]);
    print('Deleted: $id');
    return rowsAffected;
  }
}
