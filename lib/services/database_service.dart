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
    String path = join(await getDatabasesPath(), 'finance.db');
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
        month INTEGER NOT NULL,
        year INTEGER NOT NULL,
        date TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE expenses(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        description TEXT,
        category TEXT NOT NULL,
        month INTEGER NOT NULL,
        year INTEGER NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertIncome(Map<String, dynamic> income) async {
    final db = await database;
    final now = DateTime.now();

    final data = {
      'amount': income['amount'],
      'description': income['description'],
      'category': income['category'],
      'month': income['month'] ?? now.month,
      'year': income['year'] ?? now.year,
      'date': now.toIso8601String(),
    };

    return await db.insert('incomes', data);
  }

  Future<int> insertExpense(Map<String, dynamic> expense) async {
    final db = await database;
    final now = DateTime.now();

    final data = {
      'amount': expense['amount'],
      'description': expense['description'],
      'category': expense['category'],
      'month': expense['month'] ?? now.month,
      'year': expense['year'] ?? now.year,
      'date': now.toIso8601String(),
    };

    return await db.insert('expenses', data);
  }

  Future<List<Map<String, dynamic>>> getIncomes({
    int? month,
    int? year,
    String? category,
  }) async {
    final db = await database;
    String whereClause = '1=1';
    List<dynamic> whereArgs = [];

    if (month != null) {
      whereClause += ' AND month = ?';
      whereArgs.add(month);
    }
    if (year != null) {
      whereClause += ' AND year = ?';
      whereArgs.add(year);
    }
    if (category != null) {
      whereClause += ' AND category = ?';
      whereArgs.add(category);
    }

    return await db.query(
      'incomes',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'date DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getExpenses({
    int? month,
    int? year,
    String? category,
  }) async {
    final db = await database;
    String whereClause = '1=1';
    List<dynamic> whereArgs = [];

    if (month != null) {
      whereClause += ' AND month = ?';
      whereArgs.add(month);
    }
    if (year != null) {
      whereClause += ' AND year = ?';
      whereArgs.add(year);
    }
    if (category != null) {
      whereClause += ' AND category = ?';
      whereArgs.add(category);
    }

    return await db.query(
      'expenses',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'date DESC',
    );
  }

  Future<double> getTotalIncome({int? month, int? year}) async {
    final db = await database;
    String whereClause = '1=1';
    List<dynamic> whereArgs = [];

    if (month != null) {
      whereClause += ' AND month = ?';
      whereArgs.add(month);
    }
    if (year != null) {
      whereClause += ' AND year = ?';
      whereArgs.add(year);
    }

    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM incomes WHERE $whereClause',
      whereArgs,
    );

    return result.first['total'] as double? ?? 0.0;
  }

  Future<double> getTotalExpense({int? month, int? year}) async {
    final db = await database;
    String whereClause = '1=1';
    List<dynamic> whereArgs = [];

    if (month != null) {
      whereClause += ' AND month = ?';
      whereArgs.add(month);
    }
    if (year != null) {
      whereClause += ' AND year = ?';
      whereArgs.add(year);
    }

    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM expenses WHERE $whereClause',
      whereArgs,
    );

    return result.first['total'] as double? ?? 0.0;
  }

  Future<List<Map<String, dynamic>>> getIncomesByCategory({
    int? month,
    int? year,
  }) async {
    final db = await database;
    String whereClause = '1=1';
    List<dynamic> whereArgs = [];

    if (month != null) {
      whereClause += ' AND month = ?';
      whereArgs.add(month);
    }
    if (year != null) {
      whereClause += ' AND year = ?';
      whereArgs.add(year);
    }

    return await db.rawQuery('''
      SELECT category, SUM(amount) as total
      FROM incomes
      WHERE $whereClause
      GROUP BY category
      ORDER BY total DESC
    ''', whereArgs);
  }

  Future<List<Map<String, dynamic>>> getExpensesByCategory({
    int? month,
    int? year,
  }) async {
    final db = await database;
    String whereClause = '1=1';
    List<dynamic> whereArgs = [];

    if (month != null) {
      whereClause += ' AND month = ?';
      whereArgs.add(month);
    }
    if (year != null) {
      whereClause += ' AND year = ?';
      whereArgs.add(year);
    }

    return await db.rawQuery('''
      SELECT category, SUM(amount) as total
      FROM expenses
      WHERE $whereClause
      GROUP BY category
      ORDER BY total DESC
    ''', whereArgs);
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

  Future<void> deleteIncome(int id) async {
    final db = await database;
    await db.delete('incomes', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteExpense(int id) async {
    final db = await database;
    await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
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
