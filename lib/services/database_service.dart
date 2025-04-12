import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

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
    // Gelirler tablosu
    await db.execute('''
      CREATE TABLE incomes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        description TEXT,
        category TEXT,
        date TEXT NOT NULL
      )
    ''');

    // Giderler tablosu
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
  Future<int> insertIncome(Map<String, dynamic> income) async {
    Database db = await database;
    return await db.insert('incomes', income);
  }

  Future<List<Map<String, dynamic>>> getIncomes() async {
    Database db = await database;
    return await db.query('incomes', orderBy: 'date DESC');
  }

  Future<double> getTotalIncome() async {
    Database db = await database;
    final result =
        await db.rawQuery('SELECT SUM(amount) as total FROM incomes');
    return result.first['total'] as double? ?? 0.0;
  }

  Future<List<Map<String, dynamic>>> getIncomeLast30Days() async {
    Database db = await database;
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    return await db.query(
      'incomes',
      where: 'date >= ?',
      whereArgs: [thirtyDaysAgo.toIso8601String()],
      orderBy: 'date DESC',
    );
  }

  // Gider işlemleri
  Future<int> insertExpense(Map<String, dynamic> expense) async {
    Database db = await database;
    return await db.insert('expenses', expense);
  }

  Future<List<Map<String, dynamic>>> getExpenses() async {
    Database db = await database;
    return await db.query('expenses', orderBy: 'date DESC');
  }

  Future<double> getTotalExpense() async {
    Database db = await database;
    final result =
        await db.rawQuery('SELECT SUM(amount) as total FROM expenses');
    return result.first['total'] as double? ?? 0.0;
  }

  Future<List<Map<String, dynamic>>> getExpenseLast30Days() async {
    Database db = await database;
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    return await db.query(
      'expenses',
      where: 'date >= ?',
      whereArgs: [thirtyDaysAgo.toIso8601String()],
      orderBy: 'date DESC',
    );
  }

  // Kategori bazlı gider analizi
  Future<List<Map<String, dynamic>>> getExpensesByCategory() async {
    Database db = await database;
    return await db.rawQuery('''
      SELECT category, SUM(amount) as total
      FROM expenses
      GROUP BY category
      ORDER BY total DESC
    ''');
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

  Future<void> deleteIncome(int id) async {
    Database db = await database;
    await db.delete('incomes', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteExpense(int id) async {
    Database db = await database;
    await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getIncomesByCategory() async {
    Database db = await database;
    return await db.rawQuery('''
      SELECT category, SUM(amount) as total
      FROM incomes
      GROUP BY category
      ORDER BY total DESC
    ''');
  }
}
