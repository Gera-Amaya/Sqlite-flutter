import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite/planetas/planetas.dart';

class DB {
  static Future<Database> db() async {
    String ruta = await getDatabasesPath();
    return openDatabase(
      join(ruta, "solarsystem.db"),
      version: 1,
      onCreate: (db, version) async {
        await db.execute("""
          CREATE TABLE planeta (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            distanciaSol REAL NOT NULL,
            radio REAL NOT NULL,
            createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
          )
        """);
      },
    );
  }

  static Future<List<Planetas>> consulta() async {
    final Database db = await DB.db();
    final List<Map<String, dynamic>> query = await db.query("planeta");
    return query.map((e) => Planetas.delMapa(e)).toList();
  }

  static Future<int> insertar(Planetas planeta) async {
    final Database db = await DB.db();
    return await db.insert("planeta", planeta.mapeador(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> borrar(int id) async {
    final Database db = await DB.db();
    await db.delete("planeta", where: "id = ?", whereArgs: [id]);
  }

  static Future<int> actualizar(Planetas planeta) async {
    final Database db = await DB.db();
    return await db.update(
      "planeta",
      planeta.mapeador(),
      where: "id = ?",
      whereArgs: [planeta.id],
    );
  }
}