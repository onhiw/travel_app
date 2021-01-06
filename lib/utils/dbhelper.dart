import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'dart:async';
import 'dart:io';

import 'package:submission_flutter/model/tourism_place.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();

  factory DbHelper() => _instance;
  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDB();
      return _db;
    }
  }

  DbHelper._internal();

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, "favorite.db");

    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE Favorites(
      no INTEGER PRIMARY KEY AUTOINCREMENT,
          id TEXT, 
          name TEXT,
          location TEXT,
          description TEXT,
          openDays TEXT, 
          openTime TEXT,
          ticketPrice TEXT,
          imageAsset TEXT,
          category TEXT,
          ratingAvg TEXT,
          favored REAL,
          latitude TEXT,
          longitude TEXT,
          imageUrls TEXT)
          ''');
    print("Database was created");
  }

  Future<List<TourismPlace>> getFavorites() async {
    var dbClient = await db;
    List<Map> res = await dbClient.query(
      "Favorites",
      orderBy: "no DESC",
    );
    return res.map((m) => TourismPlace.fromDB(m)).toList();
  }

  Future<TourismPlace> getFavorite(String id) async {
    var dbClient = await db;
    var res =
        await dbClient.query("Favorites", where: "id = ?", whereArgs: [id]);
    if (res.length == 0) {
      return null;
    } else {
      return TourismPlace.fromDB(res[0]);
    }
  }

  Future<int> addFavorite(TourismPlace favorite) async {
    var dbClient = await db;
    try {
      int res = await dbClient.insert("Favorites", favorite.toMap());
      print("Favorite added $res");
      return res;
    } catch (e) {
      int res = await updateFavorite(favorite);
      return res;
    }
  }

  Future<int> updateFavorite(TourismPlace favorite) async {
    var dbClient = await db;
    var res = await dbClient.update("Favorites", favorite.toMap(),
        where: "id = ?", whereArgs: [favorite.id]);
    print("Favorite updated $res");
    return res;
  }

  Future<int> deleteFavorite(String id) async {
    var dbClient = await db;
    var res =
        await dbClient.delete("Favorites", where: "id = ?", whereArgs: [id]);
    print("Favorite deleted $res");
    return res;
  }

  Future closeDb() async {
    var dbClient = await db;
    dbClient.close();
  }
}
