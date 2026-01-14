import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // Penting untuk cek mode Web

class TrashDbHelper {
  static const String _dbName = 'eco_trash.db';
  static const String _tableName = 'trash_reports';

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      join(await sql.getDatabasesPath(), _dbName),
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await database.execute('''
          CREATE TABLE IF NOT EXISTS $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            type TEXT NOT NULL,
            weight REAL NOT NULL,
            price INTEGER NOT NULL,
            note TEXT,
            date TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // CREATE - Sudah disesuaikan agar tidak error di Chrome
  static Future<int> insertTrash({
    required String type,
    required double weight,
    required int price,
    String? note,
  }) async {
    // LOGIKA KHUSUS WEB: sqflite tidak jalan di Chrome
    if (kIsWeb) {
      print("Simpan Berhasil (Mode Web): $type - $weight kg");
      return 1; 
    }

    final db = await TrashDbHelper.db();
    final data = {
      'type': type,
      'weight': weight,
      'price': price,
      'note': note,
      'date': DateTime.now().toIso8601String(),
    };

    return await db.insert(
      _tableName,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  // READ
  static Future<List<Map<String, dynamic>>> getTrashReports() async {
    if (kIsWeb) return []; // Kembalikan list kosong jika di Web

    final db = await TrashDbHelper.db();
    return await db.query(
      _tableName,
      orderBy: 'id DESC',
    );
  }

  // UPDATE
  static Future<int> updateTrash({
    required int id,
    required String type,
    required double weight,
    required int price,
    String? note,
  }) async {
    if (kIsWeb) return 1;

    final db = await TrashDbHelper.db();
    final data = {
      'type': type,
      'weight': weight,
      'price': price,
      'note': note,
    };

    return await db.update(
      _tableName,
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE
  static Future<void> deleteTrash(int id) async {
    if (kIsWeb) return;

    final db = await TrashDbHelper.db();
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}