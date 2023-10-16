import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper {
  static Database? _database;
  static String tableName = "notes.db";

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await initDb();
      return _database!;
    }
  }

  Future<Database> initDb() async {
    final dbpath = await getDatabasesPath();
    final db = join(dbpath, tableName);
    return await openDatabase(db, version: 1, onCreate: ((db, version) {
      db.execute(
          "CREATE TABLE $tableName (st_id INTEGER PRIMARY KEY, st_name TEXT, st_cnic TEXT)");
    }));
  }

  insert(Notes notes) async {
    final db = await database;
    Map<String, dynamic> notemap = {
      "st_id": notes.st_id,
      "st_name": notes.st_name,
      "st_cnic": notes.st_cnic
    };
    db.insert(tableName, notemap);
  }

  Future<List<Notes>> queryAll() async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(tableName);

    return List.generate(
        maps.length,
        (index) => Notes(
            st_id: maps[index]["st_id"],
            st_name: maps[index]["st_name"],
            st_cnic: maps[index]["st_cnic"]));
  }

  update(Notes notes) async {
    final db = await database;

    Map<String, dynamic> notemap = {
      "st_id": notes.st_id,
      "st_name": notes.st_name,
      "st_cnic": notes.st_cnic
    };

    db.update(
      tableName,
      notemap,
      where: "st_id = ?",
      whereArgs: [notes.st_id],
    );
  }

  delete(int st_id) async {
    final db = await database;
    db.delete(
      tableName,
      where: "st_id = ?",
      whereArgs: [st_id],
    );
  }
}

class Notes {
  Notes({int st_id = 0, required String st_name, required String st_cnic});

  // int? id;
  int? st_cnic;
  String? st_name, st_id;
}
