import 'package:get/get.dart';
import '../services/database_service.dart';

class TransactionsController extends GetxController {
  final DatabaseService _databaseService = DatabaseService();

  // Gelir ve gider listeleri
  final RxList<Map<String, dynamic>> incomes = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> expenses = <Map<String, dynamic>>[].obs;

  // Kategori bazlı analizler
  final RxList<Map<String, dynamic>> incomeCategories =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> expenseCategories =
      <Map<String, dynamic>>[].obs;

  // Toplam değerler
  final RxDouble totalIncome = 0.0.obs;
  final RxDouble totalExpense = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadTransactions();
    loadCategoryAnalyses();
  }

  Future<void> loadTransactions() async {
    try {
      final loadedIncomes = await _databaseService.getIncomes();
      final loadedExpenses = await _databaseService.getExpenses();

      incomes.value = loadedIncomes;
      expenses.value = loadedExpenses;

      totalIncome.value = await _databaseService.getTotalIncome();
      totalExpense.value = await _databaseService.getTotalExpense();
    } catch (e) {
      print('İşlemleri yükleme hatası: $e');
    }
  }

  Future<void> loadCategoryAnalyses() async {
    try {
      final loadedIncomeCategories =
          await _databaseService.getIncomesByCategory();
      final loadedExpenseCategories =
          await _databaseService.getExpensesByCategory();

      incomeCategories.value = loadedIncomeCategories;
      expenseCategories.value = loadedExpenseCategories;
    } catch (e) {
      print('Kategori analizlerini yükleme hatası: $e');
    }
  }

  Future<void> addIncome(Map<String, dynamic> income) async {
    try {
      await _databaseService.insertIncome(income);
      await loadTransactions();
      await loadCategoryAnalyses();
    } catch (e) {
      print('Gelir ekleme hatası: $e');
      rethrow;
    }
  }

  Future<void> addExpense(Map<String, dynamic> expense) async {
    try {
      await _databaseService.insertExpense(expense);
      await loadTransactions();
      await loadCategoryAnalyses();
    } catch (e) {
      print('Gider ekleme hatası: $e');
      rethrow;
    }
  }

  Future<void> deleteIncome(int id) async {
    try {
      await _databaseService.deleteIncome(id);
      await loadTransactions();
      await loadCategoryAnalyses();
    } catch (e) {
      print('Gelir silme hatası: $e');
      rethrow;
    }
  }

  Future<void> deleteExpense(int id) async {
    try {
      await _databaseService.deleteExpense(id);
      await loadTransactions();
      await loadCategoryAnalyses();
    } catch (e) {
      print('Gider silme hatası: $e');
      rethrow;
    }
  }
}
