import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class DatabaseService extends GetxService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'finansapp.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE incomes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        description TEXT,
        category TEXT,
        date TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE expenses(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        description TEXT,
        category TEXT,
        date TEXT NOT NULL
      )
    ''');
  }

  // Gelir işlemleri
  Future<int> addIncome(Map<String, dynamic> income) async {
    final db = await database;
    return await db.insert('incomes', income);
  }

  Future<List<Map<String, dynamic>>> getIncomes() async {
    final db = await database;
    return await db.query('incomes', orderBy: 'date DESC');
  }

  Future<double?> getTotalIncome() async {
    final db = await database;
    final result =
        await db.rawQuery('SELECT SUM(amount) as total FROM incomes');
    if (result.isEmpty || result.first['total'] == null) {
      return 0.0;
    }
    return result.first['total'] as double;
  }

  Future<List<Map<String, dynamic>>> getIncomesByCategory() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT category, SUM(amount) as total 
      FROM incomes 
      GROUP BY category
    ''');
  }

  Future<int> deleteIncome(int id) async {
    final db = await database;
    return await db.delete('incomes', where: 'id = ?', whereArgs: [id]);
  }

  // Gider işlemleri
  Future<int> addExpense(Map<String, dynamic> expense) async {
    final db = await database;
    return await db.insert('expenses', expense);
  }

  Future<List<Map<String, dynamic>>> getExpenses() async {
    final db = await database;
    return await db.query('expenses', orderBy: 'date DESC');
  }

  Future<double?> getTotalExpense() async {
    final db = await database;
    final result =
        await db.rawQuery('SELECT SUM(amount) as total FROM expenses');
    if (result.isEmpty || result.first['total'] == null) {
      return 0.0;
    }
    return result.first['total'] as double;
  }

  Future<List<Map<String, dynamic>>> getExpensesByCategory() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT category, SUM(amount) as total 
      FROM expenses 
      GROUP BY category
    ''');
  }

  Future<int> deleteExpense(int id) async {
    final db = await database;
    return await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getMonthlySummary({
    int? year,
  }) async {
    final db = await database;
    String whereClause = '1=1';
    List<dynamic> whereArgs = [];

    if (year != null) {
      whereClause += ' AND year = ?';
      whereArgs.add(year);
    }

    return await db.rawQuery('''
      SELECT 
        month,
        year,
        SUM(CASE WHEN table_name = 'incomes' THEN amount ELSE 0 END) as total_income,
        SUM(CASE WHEN table_name = 'expenses' THEN amount ELSE 0 END) as total_expense
      FROM (
        SELECT month, year, amount, 'incomes' as table_name FROM incomes
        UNION ALL
        SELECT month, year, amount, 'expenses' as table_name FROM expenses
      )
      WHERE $whereClause
      GROUP BY month, year
      ORDER BY year DESC, month DESC
    ''', whereArgs);
  }

  Future<List<Map<String, dynamic>>> getYearlySummary() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT 
        year,
        SUM(CASE WHEN table_name = 'incomes' THEN amount ELSE 0 END) as total_income,
        SUM(CASE WHEN table_name = 'expenses' THEN amount ELSE 0 END) as total_expense
      FROM (
        SELECT year, amount, 'incomes' as table_name FROM incomes
        UNION ALL
        SELECT year, amount, 'expenses' as table_name FROM expenses
      )
      GROUP BY year
      ORDER BY year DESC
    ''');
  }

  Future<void> resetDatabase() async {
    final db = await database;
    await db.delete('incomes');
    await db.delete('expenses');
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
