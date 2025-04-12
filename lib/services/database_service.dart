import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'finance.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE incomes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        description TEXT,
        category TEXT NOT NULL,
        date TEXT NOT NULL,
        month INTEGER NOT NULL,
        year INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE expenses(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        description TEXT,
        category TEXT NOT NULL,
        date TEXT NOT NULL,
        month INTEGER NOT NULL,
        year INTEGER NOT NULL
      )
    ''');
  }

  // Gelir işlemleri
  Future<int> insertIncome(Map<String, dynamic> income) async {
    try {
      final db = await database;
      final now = DateTime.now();

      // Veri doğrulama
      if (income['amount'] == null) {
        throw Exception('Miktar alanı boş olamaz');
      }

      final data = {
        'amount': double.parse(income['amount'].toString()),
        'description': income['description']?.toString() ?? '',
        'category': income['category']?.toString() ?? 'Diğer',
        'date': income['date']?.toString() ?? now.toIso8601String(),
        'month': income['month'] ?? now.month,
        'year': income['year'] ?? now.year,
      };

      final result = await db.insert('incomes', data);
      print('Gelir başarıyla eklendi: $data');
      return result;
    } catch (e) {
      print('Gelir eklenirken hata oluştu: $e');
      Get.snackbar(
        'Hata',
        'Gelir eklenirken bir hata oluştu. Lütfen tekrar deneyin.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getIncomes({int? month, int? year}) async {
    final db = await database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (month != null && year != null) {
      whereClause = 'month = ? AND year = ?';
      whereArgs = [month, year];
    }

    return await db.query(
      'incomes',
      where: whereClause.isEmpty ? null : whereClause,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      orderBy: 'date DESC',
    );
  }

  Future<double> getTotalIncome({int? month, int? year}) async {
    final db = await database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (month != null && year != null) {
      whereClause = 'WHERE month = ? AND year = ?';
      whereArgs = [month, year];
    }

    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM incomes $whereClause',
      whereArgs,
    );
    return result.first['total'] as double? ?? 0.0;
  }

  Future<List<Map<String, dynamic>>> getIncomesByCategory(
      {int? month, int? year}) async {
    final db = await database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (month != null && year != null) {
      whereClause = 'WHERE month = ? AND year = ?';
      whereArgs = [month, year];
    }

    return await db.rawQuery('''
      SELECT category, SUM(amount) as total
      FROM incomes
      $whereClause
      GROUP BY category
      ORDER BY total DESC
    ''', whereArgs);
  }

  // Gider işlemleri
  Future<int> insertExpense(Map<String, dynamic> expense) async {
    try {
      final db = await database;
      final now = DateTime.now();

      // Veri doğrulama
      if (expense['amount'] == null) {
        throw Exception('Miktar alanı boş olamaz');
      }

      final data = {
        'amount': double.parse(expense['amount'].toString()),
        'description': expense['description']?.toString() ?? '',
        'category': expense['category']?.toString() ?? 'Diğer',
        'date': expense['date']?.toString() ?? now.toIso8601String(),
        'month': expense['month'] ?? now.month,
        'year': expense['year'] ?? now.year,
      };

      final result = await db.insert('expenses', data);
      print('Gider başarıyla eklendi: $data');
      return result;
    } catch (e) {
      print('Gider eklenirken hata oluştu: $e');
      Get.snackbar(
        'Hata',
        'Gider eklenirken bir hata oluştu. Lütfen tekrar deneyin.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getExpenses(
      {int? month, int? year}) async {
    final db = await database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (month != null && year != null) {
      whereClause = 'month = ? AND year = ?';
      whereArgs = [month, year];
    }

    return await db.query(
      'expenses',
      where: whereClause.isEmpty ? null : whereClause,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      orderBy: 'date DESC',
    );
  }

  Future<double> getTotalExpense({int? month, int? year}) async {
    final db = await database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (month != null && year != null) {
      whereClause = 'WHERE month = ? AND year = ?';
      whereArgs = [month, year];
    }

    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM expenses $whereClause',
      whereArgs,
    );
    return result.first['total'] as double? ?? 0.0;
  }

  Future<List<Map<String, dynamic>>> getExpensesByCategory(
      {int? month, int? year}) async {
    final db = await database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (month != null && year != null) {
      whereClause = 'WHERE month = ? AND year = ?';
      whereArgs = [month, year];
    }

    return await db.rawQuery('''
      SELECT category, SUM(amount) as total
      FROM expenses
      $whereClause
      GROUP BY category
      ORDER BY total DESC
    ''', whereArgs);
  }

  // Silme işlemleri
  Future<void> deleteIncome(int id) async {
    try {
      final db = await database;
      await db.delete(
        'incomes',
        where: 'id = ?',
        whereArgs: [id],
      );
      print('Gelir başarıyla silindi: $id');
    } catch (e) {
      print('Gelir silinirken hata oluştu: $e');
      Get.snackbar(
        'Hata',
        'Gelir silinirken bir hata oluştu. Lütfen tekrar deneyin.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  Future<void> deleteExpense(int id) async {
    try {
      final db = await database;
      await db.delete(
        'expenses',
        where: 'id = ?',
        whereArgs: [id],
      );
      print('Gider başarıyla silindi: $id');
    } catch (e) {
      print('Gider silinirken hata oluştu: $e');
      Get.snackbar(
        'Hata',
        'Gider silinirken bir hata oluştu. Lütfen tekrar deneyin.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  // Veritabanını sıfırlama
  Future<void> resetDatabase() async {
    try {
      final db = await database;
      await db.delete('incomes');
      await db.delete('expenses');
      print('Veritabanı başarıyla sıfırlandı');
    } catch (e) {
      print('Veritabanı sıfırlanırken hata oluştu: $e');
      Get.snackbar(
        'Hata',
        'Veritabanı sıfırlanırken bir hata oluştu. Lütfen tekrar deneyin.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  // Son 30 günlük veriler
  Future<List<Map<String, dynamic>>> getLast30DaysData() async {
    Database db = await database;
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    final dateStr = thirtyDaysAgo.toIso8601String();

    final incomes = await db.rawQuery('''
      SELECT date, SUM(amount) as total
      FROM incomes
      WHERE date >= ?
      GROUP BY date
      ORDER BY date DESC
    ''', [dateStr]);

    final expenses = await db.rawQuery('''
      SELECT date, SUM(amount) as total
      FROM expenses
      WHERE date >= ?
      GROUP BY date
      ORDER BY date DESC
    ''', [dateStr]);

    return [
      {'type': 'income', 'data': incomes},
      {'type': 'expense', 'data': expenses},
    ];
  }
}
