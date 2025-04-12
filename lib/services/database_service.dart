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
      onUpgrade: _onUpgrade,
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

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Veritabanı yapısında değişiklik yapılırsa burada güncelleme işlemleri yapılacak
  }

  // Gelir işlemleri
  Future<int> insertIncome(Map<String, dynamic> income) async {
    try {
      final db = await database;

      // Veri doğrulama
      if (income['amount'] == null) {
        throw Exception('Miktar alanı boş olamaz');
      }

      // Veriyi hazırla
      final incomeData = {
        'amount': double.parse(income['amount'].toString()),
        'description': income['description']?.toString() ?? '',
        'category': income['category']?.toString() ?? 'Diğer',
        'date': income['date']?.toString() ?? DateTime.now().toIso8601String(),
      };

      print('Eklenecek gelir verisi: $incomeData');

      final result = await db.insert('incomes', incomeData);
      print('Gelir eklendi, ID: $result');
      return result;
    } catch (e, stackTrace) {
      print('Gelir ekleme hatası: $e');
      print('Stack Trace: $stackTrace');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getIncomes() async {
    try {
      final db = await database;
      return await db.query('incomes', orderBy: 'date DESC');
    } catch (e) {
      print('Gelirleri getirme hatası: $e');
      return [];
    }
  }

  Future<double> getTotalIncome() async {
    try {
      final db = await database;
      final result =
          await db.rawQuery('SELECT SUM(amount) as total FROM incomes');
      return result.first['total'] as double? ?? 0.0;
    } catch (e) {
      print('Toplam gelir hesaplama hatası: $e');
      return 0.0;
    }
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
    try {
      final db = await database;

      // Veri doğrulama
      if (expense['amount'] == null) {
        throw Exception('Miktar alanı boş olamaz');
      }

      // Veriyi hazırla
      final expenseData = {
        'amount': double.parse(expense['amount'].toString()),
        'description': expense['description']?.toString() ?? '',
        'category': expense['category']?.toString() ?? 'Diğer',
        'date': expense['date']?.toString() ?? DateTime.now().toIso8601String(),
      };

      print('Eklenecek gider verisi: $expenseData');

      final result = await db.insert('expenses', expenseData);
      print('Gider eklendi, ID: $result');
      return result;
    } catch (e, stackTrace) {
      print('Gider ekleme hatası: $e');
      print('Stack Trace: $stackTrace');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getExpenses() async {
    try {
      final db = await database;
      return await db.query('expenses', orderBy: 'date DESC');
    } catch (e) {
      print('Giderleri getirme hatası: $e');
      return [];
    }
  }

  Future<double> getTotalExpense() async {
    try {
      final db = await database;
      final result =
          await db.rawQuery('SELECT SUM(amount) as total FROM expenses');
      return result.first['total'] as double? ?? 0.0;
    } catch (e) {
      print('Toplam gider hesaplama hatası: $e');
      return 0.0;
    }
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

  // Kategori bazlı analizler
  Future<List<Map<String, dynamic>>> getIncomesByCategory() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.rawQuery('''
        SELECT 
          COALESCE(category, 'Kategorisiz') as category,
          COALESCE(SUM(amount), 0) as total
        FROM incomes
        GROUP BY category
        ORDER BY total DESC
      ''');
      print('Gelir kategorileri sorgu sonucu: $maps');
      return maps;
    } catch (e, stackTrace) {
      print('Gelir kategorileri sorgu hatası: $e');
      print('Stack Trace: $stackTrace');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getExpensesByCategory() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.rawQuery('''
        SELECT 
          COALESCE(category, 'Kategorisiz') as category,
          COALESCE(SUM(amount), 0) as total
        FROM expenses
        GROUP BY category
        ORDER BY total DESC
      ''');
      print('Gider kategorileri sorgu sonucu: $maps');
      return maps;
    } catch (e, stackTrace) {
      print('Gider kategorileri sorgu hatası: $e');
      print('Stack Trace: $stackTrace');
      return [];
    }
  }

  // Silme işlemleri
  Future<void> deleteIncome(int id) async {
    try {
      final db = await database;
      await db.delete('incomes', where: 'id = ?', whereArgs: [id]);
      print('Gelir silindi, ID: $id');
    } catch (e) {
      print('Gelir silme hatası: $e');
      rethrow;
    }
  }

  Future<void> deleteExpense(int id) async {
    try {
      final db = await database;
      await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
      print('Gider silindi, ID: $id');
    } catch (e) {
      print('Gider silme hatası: $e');
      rethrow;
    }
  }

  // Veritabanını sıfırlama
  Future<void> resetDatabase() async {
    try {
      final db = await database;
      await db.delete('incomes');
      await db.delete('expenses');
      print('Veritabanı sıfırlandı');
    } catch (e) {
      print('Veritabanı sıfırlama hatası: $e');
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
