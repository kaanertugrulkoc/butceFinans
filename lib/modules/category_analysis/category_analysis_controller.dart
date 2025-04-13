import 'package:get/get.dart';
import '../../services/database_service.dart';
import '../../models/category.dart';

class CategoryAnalysisController extends GetxController {
  final databaseService = DatabaseService();
  final isLoading = false.obs;
  final categorizedIncomes = <CategoryAmount>[].obs;
  final categorizedExpenses = <CategoryAmount>[].obs;

  @override
  void onInit() {
    super.onInit();
    refreshData();
  }

  Future<void> refreshData() async {
    isLoading.value = true;
    try {
      await loadData();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadData() async {
    final incomes = await databaseService.getIncomes();
    final expenses = await databaseService.getExpenses();

    // Gelirleri kategorilere göre grupla
    final incomeMap = <String, double>{};
    for (final income in incomes) {
      final category = income['category'] as String;
      final amount = income['amount'] as double;
      incomeMap[category] = (incomeMap[category] ?? 0) + amount;
    }

    // Giderleri kategorilere göre grupla
    final expenseMap = <String, double>{};
    for (final expense in expenses) {
      final category = expense['category'] as String;
      final amount = expense['amount'] as double;
      expenseMap[category] = (expenseMap[category] ?? 0) + amount;
    }

    // Kategorileri listeye dönüştür
    categorizedIncomes.value = incomeMap.entries
        .map((e) => CategoryAmount(e.key, e.value))
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));

    categorizedExpenses.value = expenseMap.entries
        .map((e) => CategoryAmount(e.key, e.value))
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));
  }
}

class CategoryAmount {
  final String name;
  final double amount;

  CategoryAmount(this.name, this.amount);
}
