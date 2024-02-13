import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;
  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = await getDatabasesPath();
    String direktori = join(path, 'mocoDB.db');
    // String sql_chat = """
    //  CREATE TABLE CHAT(
    //   id INTEGER PRIMARY KEY AUTOINCREMENT,
    //   title VARCHAR(100) NOT NULL,
    //   );
    // """;

    String sql_chat = "CREATE TABLE CHAT (" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT, title VARCHAR(100) NOT NULL, image TEXT NOT NULL, konten TEXT NOT NULL " +
        ")";
    String sql_msg = "CREATE TABLE PESAN (" +
        "id INTEGER PRIMARY KEY AUTOINCREMENT, id_chat INTEGER, message TEXT, tanggal TEXT, type VARCHAR(10) NOT NULL, FOREIGN KEY(id_chat) REFERENCES CHAT (id)" +
        ");";

//     String sql_msg = """
//      CREATE TABLE PESAN(
//       id INTEGER PRIMARY KEY AUTOINCREMENT,
//       id_chat INTEGER,
//       message TEXT,
//       tanggal TEXT,
//       image TEXT,
//       konten TEXT,
//       FOREIGN KEY(id_chat) REFERENCES CHAT (id)
//       )
// """;
    return openDatabase(direktori, version: 1, onCreate: ((db, version) async {
      await db.execute(sql_chat);
      await db.execute(sql_msg);
    }));
  }

  /*
    insert ke data chat
  */
  Future<void> insertChat(
      {String? judul, String? image, String? konten}) async {
    final db = await database;
    await db
        .insert(
            "CHAT",
            {
              "title": judul,
              "image": image,
              "konten": konten,
            },
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      log("berhasil menyimpan chat");
    });
  }

  /*
    insert ke data messages
  */
  Future<void> insertMessage(
      {int? id_chat, String? msg, String? tanggal, String? type}) async {
    final db = await database;
    await db
        .insert(
            "PESAN",
            {
              "tanggal": tanggal,
              "message": msg,
              "id_chat": id_chat,
              "type": type
            },
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      log("berhasil menyimpan message");
    });
  }

  Future<List<Map<String, dynamic>>> getMessage() async {
    final db = await database;
    log("data : ${await db.query(
      "CHAT",
    )}");
    return await db.query(
      "CHAT",
    );
  }

  Future<List<Map<String, dynamic>>> getLastChat() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.rawQuery(
      "SELECT * FROM CHAT ORDER BY id DESC LIMIT 1"
    );
    return result;
  }
  Future<List<Map<String, dynamic>>> getMessageById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.rawQuery(
      "SELECT * FROM PESAN WHERE id_chat = $id ORDER BY id"
    );
    return result;
  }

}
